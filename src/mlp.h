#ifndef __INT_MLP_H__
#define __INT_MLP_H__

#include "common.h"
#include "layernorm.h"
#include "matmul.h"
#include "gelu.h"

using namespace std;

template<class __data_t, int _T, int _TP, int _C, int _CP>
void check_stream(hls::stream<hls::vector<__data_t, _CP*_TP> >& stream, const int ref[_T*_C], const char* name){
    constexpr int _TT = _T / _TP;
    constexpr int _CT = _C / _CP;

    for(int tt = 0; tt < _TT; tt++){
        for(int ct = 0; ct < _CT; ++ct){

            hls::vector<__data_t, _TP*_CP> vec = stream.read();

            for(int tp = 0; tp < _TP; tp++){
                for(int cp = 0; cp < _CP; cp++){
                    int t = tt * _TP + tp;
                    int c = ct * _CP + cp;
                    int idx = t*_C + c;

                    int dut_val = vec[tp*_CP + cp];
                    int ref_val = ref[idx];

                    if(dut_val != ref_val){
                        printf("ERROR at %s: stream[%d][%d] = %d, ref[%d] = %d\n", name, tt, ct, dut_val, idx, ref_val);
                    }

                }
            }
        }
    }

    if(!stream.empty()){
        cout << "ERROR: stream is not empty!" << endl;
        exit(1);
    }

    for(int tt = 0; tt < _TT; tt++){
        for(int ct = 0; ct < _CT; ++ct){

            hls::vector<__data_t, _TP*_CP> vec;

            for(int tp = 0; tp < _TP; tp++){
                for(int cp = 0; cp < _CP; cp++){
                    int t = tt * _TP + tp;
                    int c = ct * _CP + cp;
                    int idx = t*_C + c;
                    vec[tp*_CP + cp] = ref[idx];
                }
            }

            stream.write(vec);

        }
    }

}



template<

    // mlp                                  
    int     T,                  // input  feature map sequence length, shared by all layers
    int     TP,                 // input  feature map sequence parallel degree
    int     C,                  // input & output feature map channels
    int     CAP,                // input & output feature map channel adaptive parallel degree
    int     RESI_CP,            // residual branch channel parallel degree
    int     CH,                 // hidden feature map channels
    int     CHAP,               // hidden feature map channel adaptive parallel degree, shared by gelu

    class   __mlp_if_t,         // input feature map type
    class   __mlp_ln_t,         // layernorm type
    class   __mlp_m1_t,         // mac type
    class   __mlp_ge_t,         // gelu type
    class   __mlp_m2_t,         // mac type
    class   __mlp_of_t,         // output feature map type

    // layernorm
    class   __ln_sum_t,         // sum type
    class   __ln_divc_t,        // type of sum(x) * C_1_m
    class   __ln_mu_t,          // type of x mean
    class   __ln_var_t,         // type of pow diff sum
    class   __ln_cursor_t,      // (varx + b) >> s1
    class   __ln_rsqrt_t,       // lookup table data
    class   __ln_affine_t,      // (x-mu) * rsqrt_table * lnw + lnb
    class   __ln_shift_t,       // >> s2
    int     LN_ENTRIES_RSQRT,

    // matmul 1
    class   __m1_we_t,          // weight type
    class   __m1_bi_t,
    class   __m1_mc_t,          // mac type
    int     M1_CIP,             // input  feature map channel parallel degree
    int     M1_COP,             // output feature map channel parallel degree
    int     M1_ADPT_FIFO_DEPTH, // adapter fifo depth
    int     M1_WIND_FIFO_DEPTH, // cache window fifo depth
    int     M1_WGHT_FIFO_DEPTH, // weight fifo depth
    int     M1_MACS_FIFO_DEPTH, // mac fifo depth
    bool    M1_USE_DSP,         // use DSP or not

    // gelu
    class   __gelu_cursor_t,    // lookup table cursor type
    int     GELU_ENTRIES,

    // matmul 2
    class   __m2_we_t,          // weight type
    class   __m2_bi_t,
    class   __m2_mc_t,          // mac type
    int     M2_CIP,             // input  feature map channel parallel degree
    int     M2_COP,             // output feature map channel parallel degree
    int     M2_ADPT_FIFO_DEPTH, // adapter fifo depth
    int     M2_WIND_FIFO_DEPTH, // cache window fifo depth
    int     M2_WGHT_FIFO_DEPTH, // weight fifo depth
    int     M2_MACS_FIFO_DEPTH, // mac fifo depth
    bool    M2_USE_DSP          // use DSP or not
> class MLP{
public:

    // static assertions
    static_assert(  C   % CAP      == 0, "C must be multiple of CAP");
    static_assert(  CH  % CHAP      == 0, "CH must be multiple of CHAP");
    static_assert(  T   % TP        == 0, "T must be multiple of TP");
    static_assert(  C   % M1_CIP    == 0, "C must be multiple of M1_CIP");
    static_assert(  CH  % M1_COP    == 0, "CH must be multiple of M1_COP");
    static_assert(  CH  % M2_CIP    == 0, "CH must be multiple of M2_CIP");
    static_assert(  C   % M2_COP    == 0, "C must be multiple of M2_COP");

    // static hyper parameters
    static constexpr int TT  = T    / TP;
    static constexpr int CAT = C    / CAP;

    // scalar weights
    int RM, RS, RB;

    // array weights

    // components
    Layernorm<
        __mlp_if_t,
        __ln_sum_t,
        __ln_divc_t,
        __ln_mu_t,
        __ln_var_t,
        __ln_cursor_t,
        __ln_rsqrt_t,
        __ln_affine_t,
        __ln_shift_t,
        __mlp_ln_t,
        LN_ENTRIES_RSQRT,
        T,
        TP,
        C,
        CAP
    > lnq;

    Matmul<
        __mlp_ln_t,
        __m1_we_t,
        __m1_bi_t,
        __mlp_m1_t,
        T,
        TP,
        C,
        M1_CIP,
        CAP,
        CH,
        M1_COP,
        CHAP,
        M1_ADPT_FIFO_DEPTH,
        M1_WIND_FIFO_DEPTH,
        M1_WGHT_FIFO_DEPTH,
        M1_MACS_FIFO_DEPTH,
        BRAM_STYLE,             // must use BRAM_STYLE
        M1_USE_DSP
    > m1;

    GeLU<
        __mlp_m1_t,
        __gelu_cursor_t,
        __mlp_ge_t,
        T,
        TP,
        CH,
        CHAP,
        GELU_ENTRIES
    > ge;

    Matmul<
        __mlp_ge_t,
        __m2_we_t,
        __m2_bi_t,
        __mlp_m2_t,
        T,
        TP,
        CH,
        M2_CIP,
        CHAP,
        C,
        M2_COP,
        CAP,
        M2_ADPT_FIFO_DEPTH,
        M2_WIND_FIFO_DEPTH,
        M2_WGHT_FIFO_DEPTH,
        M2_MACS_FIFO_DEPTH,
        BRAM_STYLE,     // must use BRAM_STYLE
        M2_USE_DSP
    > m2;

    explicit MLP(
        const int mlp_scalars_init[],
        const int ln_scalars_init[],        const int ln_lnw_init[C],   const int64_t ln_lnb_init[C],  const int ln_rsqrt_table_init[],
        const int m1_weight_init[CH][C],    const int m1_bias_init[CH],
        const int ge_scalars_init[],        const int ge_table_init[],
        const int m2_weight_init[C][CH],    const int m2_bias_init[C]
    ):
        lnq (ln_scalars_init,   ln_lnw_init,    ln_lnb_init,    ln_rsqrt_table_init ),
        m1  (m1_weight_init,    m1_bias_init                                        ),
        ge  (ge_scalars_init,   ge_table_init                                       ),
        m2  (m2_weight_init,    m2_bias_init                                        )
    {
        RM = mlp_scalars_init[0];
        RS = mlp_scalars_init[1];
        RB = 1 << (RS - 1);

        // report static parameters
        printf("MLP: T=%d, TP=%d, C=%d, CAP=%d, CH=%d, CHAP=%d\n", T, TP, C, CAP, CH, CHAP);
    }

    void stream_copy(
        hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& i_stream,
        hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& o_stream1,
        hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& o_stream2
    ) const {
        for(int tt=0; tt<TT; ++tt){
            for(int cat=0; cat<CAT; ++cat){
                #pragma HLS pipeline II=1

                hls::vector<__mlp_if_t, TP*CAP> vec_i = i_stream.read();
                o_stream1.write(vec_i);
                o_stream2.write(vec_i);

            } // end of CAT_LOOP
        } // end of TT_LOOP
    }

    void stream_merge(
        hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& i_stream1, // residual branch
        hls::stream<hls::vector<__mlp_m2_t, TP*CAP> >& i_stream2, // main branch
        hls::stream<hls::vector<__mlp_of_t, TP*CAP> >& o_stream
    ) const {
        for(int tt=0; tt<TT; ++tt){
            for(int cat=0; cat<CAT; ++cat){
                #pragma HLS pipeline II=1

                hls::vector<__mlp_if_t, TP*CAP> vec_i1 = i_stream1.read();
                hls::vector<__mlp_m2_t, TP*CAP> vec_i2 = i_stream2.read();
                hls::vector<__mlp_of_t, TP*CAP> vec_o;

                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS unroll
                    for(int cap=0; cap<CAP; ++cap){
                        #pragma HLS unroll
                        vec_o[tp*CAP + cap] = vec_i2[tp*CAP + cap] + __mlp_of_t( (vec_i1[tp*CAP + cap] * RM + RB) >> RS );
                    }
                }

                o_stream.write(vec_o);

            } // end of CAT_LOOP
        } // end of TT_LOOP
    }

    void do_mlp(
        hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& i_stream,
        hls::stream<hls::vector<__mlp_of_t, TP*CAP> >& o_stream
    ) {

        #pragma HLS dataflow

        hls::stream<hls::vector<__mlp_if_t,     TP*     CAP         > > main_sm;    
        hls::stream<hls::vector<__mlp_if_t,     TP*     CAP         > > resi_i_sm;  
        hls::stream<hls::vector<__mlp_if_t,     TP*     RESI_CP     > > resi_sm;    
        hls::stream<hls::vector<__mlp_if_t,     TP*     CAP         > > resi_o_sm;
        hls::stream<hls::vector<__mlp_ln_t,     TP*     CAP         > > ln_sm;      
        hls::stream<hls::vector<__mlp_m1_t,     TP*     CHAP        > > m1_sm;      
        hls::stream<hls::vector<__mlp_ge_t,     TP*     CHAP        > > ge_sm;      
        hls::stream<hls::vector<__mlp_m2_t,     TP*     CAP         > > m2_sm;      

        #pragma HLS stream variable=main_sm     depth=2
        #pragma HLS stream variable=resi_i_sm   depth=2
        #pragma HLS stream variable=resi_sm     depth=512 // in fact, 300
        #pragma HLS stream variable=resi_o_sm   depth=2
        #pragma HLS stream variable=ln_sm       depth=2
        #pragma HLS stream variable=m1_sm       depth=2
        #pragma HLS stream variable=ge_sm       depth=2
        #pragma HLS stream variable=m2_sm       depth=2

        // two residual related adapters
        Adapter<__mlp_if_t, T, TP, C, CAP, RESI_CP> resi_i_adapter;
        Adapter<__mlp_if_t, T, TP, C, RESI_CP, CAP> resi_o_adapter;

        this->              stream_copy     (   i_stream,   main_sm,    resi_i_sm   );
        resi_i_adapter.     do_adapt        (   resi_i_sm,  resi_sm                 );
        resi_o_adapter.     do_adapt        (   resi_sm,    resi_o_sm               );
        lnq.                do_layernorm    (   main_sm,    ln_sm                   );
        m1.                 do_matmul       (   ln_sm,      m1_sm                   );
        ge.                 do_gelu         (   m1_sm,      ge_sm                   );
        m2.                 do_matmul       (   ge_sm,      m2_sm                   );
        this->              stream_merge    (   resi_o_sm,  m2_sm,      o_stream    );

    }

    // #ifndef __SYNTHESIS__
    // void do_mlp(
    //     hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& i_stream,
    //     hls::stream<hls::vector<__mlp_of_t, TP*CAP> >& o_stream,
    //     const int x_ref[],
    //     const int lnq_ref[],
    //     const int m1_ref[],
    //     const int ge_ref[],
    //     const int m2_ref[]
    // ) {

    //     #pragma HLS dataflow

    //     hls::stream<hls::vector<__mlp_if_t, TP*CAP  > > main_sm;    // main branch
    //     hls::stream<hls::vector<__mlp_if_t, TP*CAP  > > resi_sm;    // residual branch
    //     hls::stream<hls::vector<__mlp_ln_t, TP*CAP  > > ln_sm;      // layernorm
    //     hls::stream<hls::vector<__mlp_m1_t, TP*CHAP > > m1_sm;      // matmul 1
    //     hls::stream<hls::vector<__mlp_ge_t, TP*CHAP > > ge_sm;      // gelu
    //     hls::stream<hls::vector<__mlp_m2_t, TP*CAP  > > m2_sm;      // matmul 2

    //     this->  stream_copy     (   i_stream,  main_sm,    resi_sm  );  check_stream<__mlp_if_t, T, TP, C,  CAP >(main_sm,  x_ref,      "main");
    //     lnq.    do_layernorm    (   main_sm,   ln_sm                );  check_stream<__mlp_ln_t, T, TP, C,  CAP >(ln_sm,    lnq_ref,    "lnq");
    //     m1.     do_matmul       (   ln_sm,     m1_sm                );  check_stream<__mlp_m1_t, T, TP, CH, CHAP>(m1_sm,    m1_ref,     "m1" );
    //     ge.     do_gelu         (   m1_sm,     ge_sm                );  check_stream<__mlp_ge_t, T, TP, CH, CHAP>(ge_sm,    ge_ref,     "ge" );
    //     m2.     do_matmul       (   ge_sm,     m2_sm                );  check_stream<__mlp_m2_t, T, TP, C,  CAP >(m2_sm,    m2_ref,     "m2" );
    //     this->  stream_merge    (   resi_sm,   m2_sm,      o_stream );

    // }

    // #endif

};

#endif