#ifndef __INT_H__
#define __INT_H__

#include "common.h"
#include "layernorm.h"
#include "matmul.h"

using namespace std;

template<

    // global shapes
    int     T,                  // input  feature map sequence length, shared by all layers
    int     TP,                 // input  feature map sequence parallel degree
    int     CI,                 // 
    int     CIAP,               // 
    int     CO,                 // 
    int     COAP,               //

    // global types
    class   __if_t,             // input feature map type
    class   __ln_t,             // layernorm type
    class   __we_t,             // weight type
    class   __bi_t,             // bias type
    class   __mc_t,             // mac type

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

    // matmul
    int     CIP,             // input  feature map channel parallel degree
    int     COP,             // output feature map channel parallel degree
    int     ADPT_FIFO_DEPTH, // adapter fifo depth
    int     WIND_FIFO_DEPTH, // cache window fifo depth
    int     WGHT_FIFO_DEPTH, // weight fifo depth
    int     MACS_FIFO_DEPTH, // mac fifo depth
    bool    USE_DSP         // use DSP or not
> class Head{
public:

    // static assertions
    static_assert(  CI  % CIAP      == 0, "C must be multiple of CIAP");
    static_assert(  CO  % COAP      == 0, "C must be multiple of COAP");
    static_assert(  T   % TP        == 0, "T must be multiple of TP");
    static_assert(  CI  % CIP       == 0, "C must be multiple of CIP");
    static_assert(  CO  % COP       == 0, "C must be multiple of COP");

    // static hyper parameters
    static constexpr int TT     = T / TP;
    static constexpr int CIAT   = CI / CIAP;
    static constexpr int COAT   = CO / COAP;

    // components
    Layernorm<
        __if_t,
        __ln_sum_t,
        __ln_divc_t,
        __ln_mu_t,
        __ln_var_t,
        __ln_cursor_t,
        __ln_rsqrt_t,
        __ln_affine_t,
        __ln_shift_t,
        __ln_t,
        LN_ENTRIES_RSQRT,
        1,
        1,
        CI,
        CIAP
    > lnq;

    Matmul<
        __ln_t,
        __we_t,
        __bi_t,
        __mc_t,
        1,
        1,
        CI,
        CIP,
        CIAP,
        CO,
        COP,
        COAP,
        ADPT_FIFO_DEPTH,
        WIND_FIFO_DEPTH,
        WGHT_FIFO_DEPTH,
        MACS_FIFO_DEPTH,
        BRAM_STYLE,             // must use BRAM_STYLE
        USE_DSP
    > matmul;

    explicit Head(
        const int ln_scalars_init[],        const int ln_lnw_init[CI],   const int64_t ln_lnb_init[CI],  const int ln_rsqrt_table_init[],
        const int weight_init[CO][CI],      const int bias_init[CO]
    ):
        lnq     (ln_scalars_init,   ln_lnw_init,    ln_lnb_init,    ln_rsqrt_table_init ),
        matmul  (weight_init,       bias_init                                           )
    {}

    void select_cls(
        hls::stream<hls::vector<__if_t, TP*CIAP> >& i_stream,
        hls::stream<hls::vector<__if_t, CIAP> >& o_stream
    ){
        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            CIAT_LOOP: for(int ciat=0; ciat<CIAT; ++ciat){
                #pragma HLS pipeline II=1

                // read input
                hls::vector<__if_t, TP*CIAP> vec_i = i_stream.read();

                // select cls
                if(tt==0){
                    hls::vector<__if_t, CIAP> vec_o;
                    for(int ciap=0; ciap<CIAP; ++ciap){
                        #pragma HLS unroll
                        vec_o[ciap] = vec_i[ciap];
                    }
                    o_stream.write(vec_o);
                }

            } // end of CIAT_LOOP
        } // end of TT_LOOP
    }

    void do_head(
        hls::stream<hls::vector<__if_t, TP*CIAP> >& i_stream,
        hls::stream<hls::vector<__mc_t,    COAP> >& o_stream
    ) {

        #pragma HLS dataflow

        hls::stream<hls::vector<__if_t, CIAP    > > cls_sm  ("cls_sm");     // cls
        hls::stream<hls::vector<__ln_t, CIAP    > > ln_sm   ("ln_sm");      // layernorm

        #pragma HLS stream variable=cls_sm     depth=2
        #pragma HLS stream variable=ln_sm      depth=2

        // two residual related adapters

        this->              select_cls      (   i_stream,   cls_sm      );
        lnq.                do_layernorm    (   cls_sm,     ln_sm       );
        matmul.             do_matmul       (   ln_sm,      o_stream    );

    }

};

#endif