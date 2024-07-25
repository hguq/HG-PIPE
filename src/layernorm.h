#include "common.h"
#include "utils.h"

template<
    class   __if_t,         // input feature map data type
    class   __sum_t,        // sum type
    class   __divc_t,       // type of sum(x) * C_1_m
    class   __mu_t,         // type of x mean
    class   __var_t,        // type of pow diff sum
    class   __cursor_t,     // (varx + b) >> s1
    class   __rsqrt_t,      // lookup table data
    class   __affine_t,     // (x-mu) * rsqrt_table * lnw + lnb
    class   __shift_t,      // >> s2
    class   __of_t,         // output
    int     ENTRIES_RSQRT,
    int     T,              // input  feature map token
    int     TP,             // input  feature map token  parallel degree
    int     C,              // input  feature map channel
    int     CP>             // input  feature map channel parallel degree
class Layernorm{
public:

    // static assertions
    static_assert(T % TP == 0, "T must be multiple of TP");
    static_assert(C % CP == 0, "C must be multiple of CP");

    // static hyper parameters
    static constexpr int TT = T / TP;
    static constexpr int CT = C / CP;

    // scalar weights
    int C_1_m;
    int C_1_s;
    int b;
    int s1;
    int bound;
    int s2;
    int clamp_bits;

    // array weights
    __rsqrt_t  rsqrt_table[ENTRIES_RSQRT];

    // layernorm weights and bias
    // more than 32 bits for lnb
    // NOTE: I tested use specific width for lnw and lnb, that doesn't improve performance
    int         lnw[C];
    long long   lnb[C];


    explicit Layernorm(
        const int scalars_init[],
        const int lnw_m_init[],
        const long long lnb_m_init[],
        const int rsqrt_tb_init[]){
        // initial scalers
        C_1_m       = scalars_init[0];
        C_1_s       = scalars_init[1];
        b           = scalars_init[2];
        s1          = scalars_init[3];
        bound       = scalars_init[4];
        s2          = scalars_init[5];
        clamp_bits  = scalars_init[6];

        // initialize lnw&lnb
        for(int i=0; i<C; i++){
            lnw[i] = lnw_m_init[i];
            lnb[i] = lnb_m_init[i];
        }
        // initialize sqrt_table
        for(int i=0; i<(bound+1); i++){
            rsqrt_table[i] = rsqrt_tb_init[i];
        }

    }



    void do_layernorm(hls::stream<hls::vector<__if_t, CP*TP> >& i_stream, hls::stream<hls::vector<__of_t, CP*TP> >& o_stream){

        // lnw
        #pragma HLS array_reshape   variable=lnw            dim=1 cyclic factor=CP
        #pragma HLS bind_storage    variable=lnw            type=rom_1p impl=lutram

        // lnb
        #pragma HLS array_reshape   variable=lnb            dim=1 cyclic factor=CP
        #pragma HLS bind_storage    variable=lnb            type=rom_1p impl=lutram

        // rsqrt_table
        #pragma HLS bind_storage    variable=rsqrt_table    type=rom_2p impl=lutram

        // buffer
        __if_t      buffer  [TP][C];
        #pragma HLS array_reshape   variable=buffer         dim=1 complete
        #pragma HLS array_reshape   variable=buffer         dim=2 cyclic factor=CP
        #pragma HLS bind_storage    variable=buffer         type=ram_2p impl=lutram

        // other
        __mu_t      mean    [TP];
        __rsqrt_t   st_sqrt [TP];
        __sum_t     acc     [TP];
        __var_t     sum     [TP];
        #pragma HLS array_partition variable=mean    complete
        #pragma HLS array_partition variable=st_sqrt complete
        #pragma HLS array_partition variable=acc     complete
        #pragma HLS array_partition variable=sum     complete

        TT_LOOP:for(int tt=0; tt<TT; tt++){
            STATE_LOOP: for(int state=0; state<3; state++){
                CT_LOOP:for(int ct=0; ct<CT; ct++){
                    #pragma HLS pipeline II = 1

                    if(state == 0){
                        // first pass, read in, buffer & mean

                        // read in
                        hls::vector<__if_t, CP*TP> vec_i = i_stream.read();

                        // init acc
                        if(ct == 0){
                            for(int tp=0; tp<TP; tp++){
                                #pragma HLS unroll
                                acc[tp] = 0;
                            }
                        }

                        // buffer & mean
                        for(int tp=0; tp<TP; tp++){
                            #pragma HLS unroll
                            for(int cp=0; cp<CP; cp++){
                                #pragma HLS unroll
                                buffer[tp][ct*CP + cp] = vec_i[tp*CP + cp];
                                acc[tp] += vec_i[tp*CP + cp];
                            }
                        }

                        // divide by C
                        if(ct == CT-1) {
                            for(int tp=0; tp<TP; tp++){
                                #pragma HLS unroll
                                __divc_t tmp = acc[tp] * C_1_m;
                                tmp += (1 << C_1_s - 1);
                                mean[tp] = tmp >> C_1_s;
                            }
                        }
                    }

                    else if(state == 1){
                        // second pass, pow diff sum, sqrt

                        // pow diff sum
                        for(int tp=0; tp<TP; tp++){
                            #pragma HLS unroll
                            for(int cp=0; cp<CP; cp++){
                                #pragma HLS unroll
                                __if_t diff = buffer[tp][ct*CP + cp] - mean[tp];
                                auto diff_pow2 = diff * diff;
                                // sum[tp] = (ct == 0 && cp==0) ? __var_t(diff_pow2) : __var_t(sum[tp] + diff_pow2);
                                sum[tp] = (ct == 0 && cp==0) ? __var_t(diff_pow2) : __var_t(sum[tp] + diff_pow2);
                            }
                        }

                        // sqrt
                        if(ct == CT - 1){
                            for(int tp=0; tp<TP; tp++){
                                #pragma HLS unroll
                                __cursor_t cursor = (sum[tp] + b) >> s1;
                                cursor = clamp(cursor, 0, bound);
                                st_sqrt[tp] = rsqrt_table[cursor];
                            }
                        }
                    }

                    else if(state == 2){
                        // third pass, norm, lnw, lnb, rescale

                        hls::vector<__of_t,CP*TP> o_vec;

                        for(int tp=0; tp<TP; tp++){
                        #pragma HLS unroll
                            for(int cp=0; cp<CP; cp++){
                                #pragma HLS unroll
                                __if_t diff = buffer[tp][ct*CP + cp] - mean[tp]; 
                                // __affine_t mul = diff * st_sqrt[tp] * lnw[ct*CP + cp];
                                // __affine_t val = mul + lnb[ct*CP + cp];
                                __affine_t val = diff * st_sqrt[tp] * lnw[ct*CP + cp] + lnb[ct*CP + cp];
                                __shift_t rel = val >> s2;
                                o_vec[tp*CP + cp] = quantize_clamp(rel, clamp_bits, true);
                            }
                        }
                        o_stream.write(o_vec);
                    }

                } // end of CT_LOOP
            } // end of STATE_LOOP
        } // end of TT_LOOP

    }
};