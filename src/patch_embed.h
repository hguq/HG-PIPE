#ifndef __INT_MATMUL_H__
#define __INT_MATMUL_H__

#include "common.h"

// replace first token
// should make fake input

template<
    class   __if_t,                     // input feature map type
    class   __we_t,                     // weight type
    class   __bi_t,                     // the same type for cls
    class   __mc_t,                     // mac type
    class   __of_t,                     // output type
    int     T,                          // input  feature map sequence length
    int     TP,                         // input  feature map sequence parallel degree
    int     CI,                         // input  feature map channel
    int     CIP,                        // input  feature map channel parallel degree
    int     CIAP,
    int     CO,                         // output feature map channel
    int     COP,                        // output feature map channel parallel degree
    int     COAP,
    bool    USE_DSP                     // use DSP or not
>
class PatchEmbed{
public:
    static_assert(CI % CIP == 0, "CI must be multiple of CIP");
    static_assert(CO % COP == 0, "CO must be multiple of COP");

    static constexpr int CIT = CI / CIP;
    static constexpr int COT = CO / COP;
    static constexpr int TT  = T  / TP;

    __we_t weight_arr   [CO][CI];
    __bi_t bias_arr     [T][CO];    // two-dimensional bias
    __bi_t cls_arr      [CO];       // should be insert at t=0

    int s;
    int b;

    template<class __scalar_init_t, class __weight_init_t, class __bias_init_t, class __cls_init_t>
    PatchEmbed(const __scalar_init_t scalars_init[], const __weight_init_t weight_init[CO][CI], const __bias_init_t bias_init[T][CO], const __cls_init_t cls_init[CO]){
        // scalar init
        s = scalars_init[0];
        b = 1 << (s - 1);

        // weight init, non-transposed init
        for(int co=0; co<CO; ++co){
            for(int ci=0; ci<CI; ++ci){
                weight_arr[co][ci] = weight_init[co][ci];
            }
        }

        // bias init
        for(int t=0; t<T; ++t){
            for(int co=0; co<CO; ++co){
                bias_arr[t][co] = bias_init[t][co];
            }
        }

        // cls init
        for(int co=0; co<CO; ++co){
            cls_arr[co] = cls_init[co];
        }

    }

    void step1_cache_window(hls::stream<hls::vector<__if_t, TP*CIP> >& i_stream, hls::stream<hls::vector<__if_t, TP*CIP> >& o_stream) const {

        __if_t wb[TP][CI];
        #pragma HLS array_reshape   variable=wb dim=1       complete
        #pragma HLS array_reshape   variable=wb dim=2       cyclic factor=CIP
        #pragma HLS bind_storage    variable=wb type=ram_1p impl=LUTRAM

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    hls::vector<__if_t, TP*CIP> vec_o;

                    if(cot == 0){
                        // first pass, store input feature map to window buffer
                        vec_o = i_stream.read();
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll
                                wb[tp][cit*CIP + cip] = vec_o[tp*CIP + cip];
                            }
                        }
                    } else {
                        // not first pass, read from window buffer
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll
                                vec_o[tp*CIP + cip] = wb[tp][cit*CIP + cip];
                            }
                        }
                    }

                    o_stream.write(vec_o);

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TPT_LOOP

    }

    void step2_mac_replace_shift(hls::stream<hls::vector<__if_t, TP*CIP> >&i_stream, hls::stream<hls::vector<__of_t, TP*COP> >& o_stream) const {

        #pragma HLS array_reshape variable=weight_arr   cyclic factor=COP dim=1
        #pragma HLS array_reshape variable=weight_arr   cyclic factor=CIP dim=2
        // #pragma HLS bind_storage variable=weight_arr    type=rom_1p impl=BRAM
        #pragma HLS bind_storage variable=weight_arr    type=ram_1p impl=URAM latency=3

        #pragma HLS array_reshape   variable=bias_arr   cyclic factor=TP  dim=1
        #pragma HLS array_reshape   variable=bias_arr   cyclic factor=COP dim=2
        #pragma HLS bind_storage    variable=bias_arr   type=rom_1p impl=BRAM

        #pragma HLS array_reshape   variable=cls_arr    cyclic factor=COP dim=1

        hls::vector<__mc_t, TP*COP> vec_o;

        TT_LOOP: for(int tt=0;tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    // initialize output vector if first trip
                    if(cit == 0){
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                // vec_o[tp*COP + cop] = bias_arr[cot*COP + cop];
                                if(tt == 0 && tp == 0){
                                    // is first token
                                    vec_o[tp*COP + cop] = 0; // random number
                                } else {
                                    vec_o[tp*COP + cop] = bias_arr[tt*TP + tp][cot*COP + cop];
                                }
                            }
                        }
                    }

                    // each time read from input stream
                    hls::vector<__if_t, TP*CIP> vec_i = i_stream.read();

                    TP_LOOP: for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        COP_LOOP: for(int cop=0; cop<COP; ++cop){
                            #pragma HLS unroll
                            CIP_LOOP: for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll

                                if(USE_DSP){
                                    auto mul_res = vec_i[tp*CIP + cip] * weight_arr[cot*COP + cop][cit*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=dsp
                                    vec_o[tp*COP + cop] += mul_res;
                                } else {
                                    auto mul_res = vec_i[tp*CIP + cip] * weight_arr[cot*COP + cop][cit*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=fabric
                                    vec_o[tp*COP + cop] += mul_res;
                                }

                            } // end of CIP_LOOP
                        } // end of COP_LOOP
                    } // end of TP_LOOP

                    // write to output stream if last trip
                    if(cit == CIT-1){
                        // overwrite first token as cls, if first trip
                        if(tt == 0){
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                vec_o[cop] = cls_arr[cot*COP + cop];
                            }
                        }

                        hls::vector<__of_t, TP*COP> vec_o_shift;
                        // do inplace scaling
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                vec_o_shift[tp*COP + cop] = ( vec_o[tp*COP + cop] + b ) >> s;
                            }
                        }
                        o_stream.write(vec_o_shift);
                    }

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TT_LOOP

    }

    void do_patch_embed(hls::stream<hls::vector<__if_t, TP*CIAP> > &i_stream, hls::stream<hls::vector<__of_t, TP*COAP> > &o_stream) const {
        #pragma HLS dataflow

        // adapter
        Adapter<__if_t, T, TP, CI, CIAP, CIP> adapter_i;
        Adapter<__of_t, T, TP, CO, COP, COAP> adapter_o;

        // internal stream
        hls::stream<hls::vector<__if_t, TP*CIP> >   adpt_sm             ("adpt_sm"             );
        hls::stream<hls::vector<__if_t, TP*CIP> >   cache_window_sm     ("cache_window_sm"     );
        hls::stream<hls::vector<__of_t, TP*COP> >   mac_sm              ("mac_sm"              );

        #pragma HLS stream variable=adpt_sm             depth=64
        #pragma HLS stream variable=cache_window_sm     depth=2
        #pragma HLS stream variable=mac_sm              depth=2

        adapter_i.do_adapt          (   i_stream,           adpt_sm             );
        step1_cache_window          (   adpt_sm,            cache_window_sm     );
        step2_mac_replace_shift     (   cache_window_sm,    mac_sm              );
        adapter_o.do_adapt          (   mac_sm,             o_stream            );

    }


};

#endif