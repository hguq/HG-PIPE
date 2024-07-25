#ifndef __INT_ATTN_H__
#define __INT_ATTN_H__

#include "common.h"
#include "layernorm.h"
#include "matmul.h"
#include "quant.h"
#include "head_split.h"
#include "softmax.h"
#include "reshaper.h"

using namespace std;

template<

    // attn global shapes
    int     H,                  // head number
    int     T,                  // input  feature map sequence length, shared by all layers
    int     TP,                 // input  feature map sequence parallel degree
    int     C,                  // input & output feature map channels
    int     CAP,                // input & output feature map channel adaptive parallel degree, also for output
    int     RESI_CP,            // residual parallel degree

    // layernorm
    // use same TP and CAP

    // qkv generation parallel degree,
    int     MATMUL_QKV_CIP,   
    int     MATMUL_QKV_COP,  

    // qkv quantize parallel degree,
    int     Q_QKV_CP,

    // QK = R
    int     MATMUL_R_CIP,      
    int     MATMUL_R_COP,     

    // softmaxq for R
    int     RQ_CP,        

    // RV = A
    int     MATMUL_A_CIP,      
    int     MATMUL_A_COP,     

    // a quantize parallel degree
    int     AQ_CP,          

    // O
    int     MATMUL_O_CIP, 
    int     MATMUL_O_COP,       

    // attn global types
    class   __attn_if_t,        // input feature map type
    class   __attn_lnq_t,       // layernorm type
    class   __attn_q_t,         // query type
    class   __attn_k_t,         // key   type
    class   __attn_v_t,         // value type
    class   __attn_r_t,         // relation type
    class   __attn_a_t,         // attention type
    class   __attn_o_t,         // output feature map type
    class   __attn_qq_t,        // quantized query type
    class   __attn_kq_t,        // quantized key   type
    class   __attn_vq_t,        // quantized value type
    class   __attn_rq_t,        // quantized relation type
    class   __attn_aq_t,        // quantized attention type
    class   __attn_of_t,        // output feature map type

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

    // q generation
    class   __q_we_t,           // weight type
    class   __q_bi_t,
    int     Q_ADPT_FIFO_DEPTH,  // adapter fifo depth
    int     Q_WIND_FIFO_DEPTH,  // cache window fifo depth
    int     Q_WGHT_FIFO_DEPTH,  // weight fifo depth
    int     Q_MACS_FIFO_DEPTH,  // mac fifo depth
    int     Q_WEIGHT_RAM_STYLE, // weight ram style
    bool    Q_USE_DSP,          // use DSP or not

    // k generation
    class   __k_we_t,           // weight type
    class   __k_bi_t,
    int     K_ADPT_FIFO_DEPTH,  // adapter fifo depth
    int     K_WIND_FIFO_DEPTH,  // cache window fifo depth
    int     K_WGHT_FIFO_DEPTH,  // weight fifo depth
    int     K_MACS_FIFO_DEPTH,  // mac fifo depth
    int     K_WEIGHT_RAM_STYLE, // weight ram style
    bool    K_USE_DSP,          // use DSP or not

    // v generation
    class   __v_we_t,           // weight type
    class   __v_bi_t,
    int     V_ADPT_FIFO_DEPTH,  // adapter fifo depth
    int     V_WIND_FIFO_DEPTH,  // cache window fifo depth
    int     V_WGHT_FIFO_DEPTH,  // weight fifo depth
    int     V_MACS_FIFO_DEPTH,  // mac fifo depth
    int     V_WEIGHT_RAM_STYLE, // weight ram style
    bool    V_USE_DSP,          // use DSP or not

    // qq
    class   __qq_cursor_t,      // lookup table cursor type
    int     QQ_ENTRIES,

    // kq
    class   __kq_cursor_t,      // lookup table cursor type
    int     KQ_ENTRIES,

    // vq
    class   __vq_cursor_t,      // lookup table cursor type
    int     VQ_ENTRIES,

    // aq
    class   __aq_cursor_t,      // lookup table cursor type
    int     AQ_ENTRIES,


    // qk matmul
    int     QK_MATMUL_ADPT_FIFO_DEPTH,
    int     QK_MATMUL_WIND_FIFO_DEPTH,
    int     QK_MATMUL_WGHT_FIFO_DEPTH,
    int     QK_MATMUL_MACS_FIFO_DEPTH,
    int     QK_MATMUL_WEIGHT_RAM_STYLE,
    bool    QK_MATMUL_USE_DSP,

    // softmax
    class   __softmax_minus_t,  
    class   __softmax_cursor1_t,
    class   __softmax_exp_t,
    class   __softmax_acc_t,
    class   __softmax_recip_t,
    class   __softmax_cursor2_one_t,
    class   __softmax_cursor2_two_t,
    class   __softmax_affine_t,
    class   __softmax_cursor3_t,
    int     SOFTMAX_ENTRIES_EXP,
    int     SOFTMAX_ENTRIES_RECIP,

    // rv matmul
    int     RV_MATMUL_ADPT_FIFO_DEPTH,
    int     RV_MATMUL_WIND_FIFO_DEPTH,
    int     RV_MATMUL_WGHT_FIFO_DEPTH,
    int     RV_MATMUL_MACS_FIFO_DEPTH,
    int     RV_MATMUL_WEIGHT_RAM_STYLE,
    bool    RV_MATMUL_USE_DSP,

    // o matmul
    class   __o_we_t,           // weight type
    class   __o_bi_t,
    int     O_MATMUL_ADPT_FIFO_DEPTH,
    int     O_MATMUL_WIND_FIFO_DEPTH,
    int     O_MATMUL_WGHT_FIFO_DEPTH,
    int     O_MATMUL_MACS_FIFO_DEPTH,
    int     O_MATMUL_WEIGHT_RAM_STYLE,
    bool    O_MATMUL_USE_DSP,

    // FIFO depths
    int     MAIN_FIFO_DEPTH,
    int     RESI_I_FIFO_DEPTH,
    int     RESI_FIFO_DEPTH,
    int     RESI_O_FIFO_DEPTH,
    int     LNQ_FIFO_DEPTH,
    int     LNQ_CP_FIFO_DEPTH,
    int     Q_FIFO_DEPTH,
    int     K_FIFO_DEPTH,
    int     V_FIFO_DEPTH,
    int     QQ_FIFO_DEPTH,
    int     KQ_FIFO_DEPTH,
    int     VQ_FIFO_DEPTH,
    int     QQ_HEAD_FIFO_DEPTH,
    int     KQ_HEAD_FIFO_DEPTH,
    int     VQ_HEAD_FIFO_DEPTH,
    int     R_HEAD_FIFO_DEPTH,
    int     RQ_HEAD_FIFO_DEPTH,
    int     KQ_RESHAPE_HEAD_FIFO_DEPTH,
    int     VQ_TRANSPOSE_HEAD_FIFO_DEPTH,
    int     A_HEAD_FIFO_DEPTH,
    int     A_FIFO_DEPTH,
    int     AQ_FIFO_DEPTH,
    int     O_FIFO_DEPTH
> class Attn{
public:

    // static assertions
    static_assert(  C   % H     == 0, "C must be multiple of H"  );
    static_assert(  C   % CAP   == 0, "C must be multiple of CAP");
    static_assert(  T   % TP    == 0, "T must be multiple of TP" );

    // static hyper parameters
    static constexpr int CH  = C / H;
    static constexpr int TT  = T / TP;
    static constexpr int CAT = C / CAP;

    // scalar weights
    int RM, RS, RB;

    // array weights

    // layernorm
    Layernorm   <__attn_if_t, __ln_sum_t, __ln_divc_t, __ln_mu_t, __ln_var_t, __ln_cursor_t, __ln_rsqrt_t, __ln_affine_t, __ln_shift_t, __attn_lnq_t, LN_ENTRIES_RSQRT, T, TP, C, CAP> lnq;

    // matmul    if,           we,          bi,       of,         T  TP, C,  CIP,            CIAP,     CO,   COP,             COAP,         ADPT_FIFO_DEPTH,    WIND_FIFO_DEPTH,    WGHT_FIFO_DEPHT,    MACS_FIFO_DEPTH,    RAM_STYLE,     USE_DSP     
    Matmul      <__attn_lnq_t, __q_we_t,    __q_bi_t, __attn_q_t, T, TP, C,  MATMUL_QKV_CIP, CAP,      C,    MATMUL_QKV_COP,  Q_QKV_CP,     Q_ADPT_FIFO_DEPTH,  Q_WIND_FIFO_DEPTH,  Q_WGHT_FIFO_DEPTH,  Q_MACS_FIFO_DEPTH,  Q_WEIGHT_RAM_STYLE,  Q_USE_DSP >  matmul_gen_q;
    Matmul      <__attn_lnq_t, __k_we_t,    __k_bi_t, __attn_k_t, T, TP, C,  MATMUL_QKV_CIP, CAP,      C,    MATMUL_QKV_COP,  Q_QKV_CP,     K_ADPT_FIFO_DEPTH,  K_WIND_FIFO_DEPTH,  K_WGHT_FIFO_DEPTH,  K_MACS_FIFO_DEPTH,  K_WEIGHT_RAM_STYLE,  K_USE_DSP >  matmul_gen_k;
    Matmul      <__attn_lnq_t, __v_we_t,    __v_bi_t, __attn_v_t, T, TP, C,  MATMUL_QKV_CIP, CAP,      C,    MATMUL_QKV_COP,  Q_QKV_CP,     V_ADPT_FIFO_DEPTH,  V_WIND_FIFO_DEPTH,  V_WGHT_FIFO_DEPTH,  V_MACS_FIFO_DEPTH,  V_WEIGHT_RAM_STYLE,  V_USE_DSP >  matmul_gen_v;

    Matmul      <__attn_qq_t,  __attn_kq_t, int,      __attn_r_t, T, TP, CH, MATMUL_R_CIP,   Q_QKV_CP, T,    MATMUL_R_COP,    RQ_CP,        QK_MATMUL_ADPT_FIFO_DEPTH, QK_MATMUL_WIND_FIFO_DEPTH, QK_MATMUL_WGHT_FIFO_DEPTH, QK_MATMUL_MACS_FIFO_DEPTH, QK_MATMUL_WEIGHT_RAM_STYLE, QK_MATMUL_USE_DSP>  matmul_qk_head1;
    Matmul      <__attn_qq_t,  __attn_kq_t, int,      __attn_r_t, T, TP, CH, MATMUL_R_CIP,   Q_QKV_CP, T,    MATMUL_R_COP,    RQ_CP,        QK_MATMUL_ADPT_FIFO_DEPTH, QK_MATMUL_WIND_FIFO_DEPTH, QK_MATMUL_WGHT_FIFO_DEPTH, QK_MATMUL_MACS_FIFO_DEPTH, QK_MATMUL_WEIGHT_RAM_STYLE, QK_MATMUL_USE_DSP>  matmul_qk_head2;
    Matmul      <__attn_qq_t,  __attn_kq_t, int,      __attn_r_t, T, TP, CH, MATMUL_R_CIP,   Q_QKV_CP, T,    MATMUL_R_COP,    RQ_CP,        QK_MATMUL_ADPT_FIFO_DEPTH, QK_MATMUL_WIND_FIFO_DEPTH, QK_MATMUL_WGHT_FIFO_DEPTH, QK_MATMUL_MACS_FIFO_DEPTH, QK_MATMUL_WEIGHT_RAM_STYLE, QK_MATMUL_USE_DSP>  matmul_qk_head3;

    Matmul      <__attn_rq_t,  __attn_vq_t, int,      __attn_a_t, T, TP, T,  MATMUL_A_CIP,   RQ_CP,    CH,   MATMUL_A_COP,    AQ_CP,        RV_MATMUL_ADPT_FIFO_DEPTH, RV_MATMUL_WIND_FIFO_DEPTH, RV_MATMUL_WGHT_FIFO_DEPTH, RV_MATMUL_MACS_FIFO_DEPTH, RV_MATMUL_WEIGHT_RAM_STYLE, RV_MATMUL_USE_DSP>  matmul_rv_head1;
    Matmul      <__attn_rq_t,  __attn_vq_t, int,      __attn_a_t, T, TP, T,  MATMUL_A_CIP,   RQ_CP,    CH,   MATMUL_A_COP,    AQ_CP,        RV_MATMUL_ADPT_FIFO_DEPTH, RV_MATMUL_WIND_FIFO_DEPTH, RV_MATMUL_WGHT_FIFO_DEPTH, RV_MATMUL_MACS_FIFO_DEPTH, RV_MATMUL_WEIGHT_RAM_STYLE, RV_MATMUL_USE_DSP>  matmul_rv_head2;
    Matmul      <__attn_rq_t,  __attn_vq_t, int,      __attn_a_t, T, TP, T,  MATMUL_A_CIP,   RQ_CP,    CH,   MATMUL_A_COP,    AQ_CP,        RV_MATMUL_ADPT_FIFO_DEPTH, RV_MATMUL_WIND_FIFO_DEPTH, RV_MATMUL_WGHT_FIFO_DEPTH, RV_MATMUL_MACS_FIFO_DEPTH, RV_MATMUL_WEIGHT_RAM_STYLE, RV_MATMUL_USE_DSP>  matmul_rv_head3;

    Matmul      <__attn_aq_t,  __o_we_t,    __o_bi_t, __attn_o_t, T, TP, C,  MATMUL_O_CIP,   AQ_CP,    C,    MATMUL_O_COP,    CAP,          O_MATMUL_ADPT_FIFO_DEPTH,  O_MATMUL_WIND_FIFO_DEPTH,  O_MATMUL_WGHT_FIFO_DEPTH,  O_MATMUL_MACS_FIFO_DEPTH,  O_MATMUL_WEIGHT_RAM_STYLE,  O_MATMUL_USE_DSP>  matmul_gen_o;

    // quant
    Quant       <__attn_q_t, __qq_cursor_t, __attn_qq_t, T, TP, C, Q_QKV_CP, QQ_ENTRIES>    quant_q;
    Quant       <__attn_k_t, __kq_cursor_t, __attn_kq_t, T, TP, C, Q_QKV_CP, KQ_ENTRIES>    quant_k;
    Quant       <__attn_v_t, __vq_cursor_t, __attn_vq_t, T, TP, C, Q_QKV_CP, VQ_ENTRIES>    quant_v;
    Quant       <__attn_a_t, __aq_cursor_t, __attn_aq_t, T, TP, C, AQ_CP,    AQ_ENTRIES>    quant_a;

    // head split
    HeadSplit   <__attn_qq_t, H, T, TP, C, Q_QKV_CP> split_q;
    HeadSplit   <__attn_kq_t, H, T, TP, C, Q_QKV_CP> split_k;
    HeadSplit   <__attn_vq_t, H, T, TP, C, Q_QKV_CP> split_v;

    // softmax
    Softmax     <__attn_r_t, __softmax_minus_t, __softmax_cursor1_t, __softmax_exp_t, __softmax_acc_t, __softmax_recip_t, __softmax_cursor2_one_t, __softmax_cursor2_two_t, __softmax_affine_t, __softmax_cursor3_t, __attn_rq_t, SOFTMAX_ENTRIES_EXP, SOFTMAX_ENTRIES_RECIP, T, TP, T, RQ_CP> softmax_qk_head1;
    Softmax     <__attn_r_t, __softmax_minus_t, __softmax_cursor1_t, __softmax_exp_t, __softmax_acc_t, __softmax_recip_t, __softmax_cursor2_one_t, __softmax_cursor2_two_t, __softmax_affine_t, __softmax_cursor3_t, __attn_rq_t, SOFTMAX_ENTRIES_EXP, SOFTMAX_ENTRIES_RECIP, T, TP, T, RQ_CP> softmax_qk_head2;
    Softmax     <__attn_r_t, __softmax_minus_t, __softmax_cursor1_t, __softmax_exp_t, __softmax_acc_t, __softmax_recip_t, __softmax_cursor2_one_t, __softmax_cursor2_two_t, __softmax_affine_t, __softmax_cursor3_t, __attn_rq_t, SOFTMAX_ENTRIES_EXP, SOFTMAX_ENTRIES_RECIP, T, TP, T, RQ_CP> softmax_qk_head3;

    // reshaper
    Reshaper    <__attn_kq_t, T, TP, MATMUL_R_COP, CH, Q_QKV_CP, MATMUL_R_CIP> reshape_k_head1;
    Reshaper    <__attn_kq_t, T, TP, MATMUL_R_COP, CH, Q_QKV_CP, MATMUL_R_CIP> reshape_k_head2;
    Reshaper    <__attn_kq_t, T, TP, MATMUL_R_COP, CH, Q_QKV_CP, MATMUL_R_CIP> reshape_k_head3;
    Reshaper    <__attn_vq_t, T, TP, MATMUL_A_CIP, CH, Q_QKV_CP, MATMUL_A_COP> reshape_v_head1; // v will be transposed
    Reshaper    <__attn_vq_t, T, TP, MATMUL_A_CIP, CH, Q_QKV_CP, MATMUL_A_COP> reshape_v_head2; // v will be transposed
    Reshaper    <__attn_vq_t, T, TP, MATMUL_A_CIP, CH, Q_QKV_CP, MATMUL_A_COP> reshape_v_head3; // v will be transposed

    // head merge
    HeadSplit   <__attn_a_t, H, T, TP, C, AQ_CP> merge_a;

    explicit Attn(
        // this module scalars
        const int       attn_scalars_init           [],
        // layernorm
        const int       ln_scalars_init             [],        
        const int       ln_lnw_init                 [],
        const int64_t   ln_lnb_init                 [],  
        const int       ln_rsqrt_table_init         [],
        // qkv matmul
        const int       q_weight_init               [C][C],   
        const int       k_weight_init               [C][C],   
        const int       v_weight_init               [C][C],
        const int       q_bias_init                 [C], 
        const int       k_bias_init                 [C],
        const int       v_bias_init                 [C],
        // qkva quant
        const int       qq_scalars_init             [],        
        const int       qq_table_init               [],
        const int       kq_scalars_init             [],        
        const int       kq_table_init               [],
        const int       vq_scalars_init             [],        
        const int       vq_table_init               [],
        const int       aq_scalars_init             [],
        const int       aq_table_init               [],
        // softmaxq
        const int       softmax_scalars_init        [],   
        const int       softmax_exp_table_init      [], 
        const int       softmax_recip_table_one_init[],
        const int       softmax_recip_table_two_init[],
        // o matmul
        const int       o_weight_init               [C][C],
        const int       o_bias_init                 [C]
    ):
        lnq                 (ln_scalars_init,       ln_lnw_init,            ln_lnb_init,                    ln_rsqrt_table_init             ),
        matmul_gen_q        (q_weight_init,         q_bias_init                                                                             ),
        matmul_gen_k        (k_weight_init,         k_bias_init                                                                             ),
        matmul_gen_v        (v_weight_init,         v_bias_init                                                                             ),
        quant_q             (qq_scalars_init,       qq_table_init                                                                           ),
        quant_k             (kq_scalars_init,       kq_table_init                                                                           ),
        quant_v             (vq_scalars_init,       vq_table_init                                                                           ),
        softmax_qk_head1    (softmax_scalars_init,  softmax_exp_table_init, softmax_recip_table_one_init,   softmax_recip_table_two_init    ),
        softmax_qk_head2    (softmax_scalars_init,  softmax_exp_table_init, softmax_recip_table_one_init,   softmax_recip_table_two_init    ),
        softmax_qk_head3    (softmax_scalars_init,  softmax_exp_table_init, softmax_recip_table_one_init,   softmax_recip_table_two_init    ),
        quant_a             (aq_scalars_init,       aq_table_init                                                                           ),
        matmul_gen_o        (o_weight_init,         o_bias_init                                                                             )
    {
        RM = attn_scalars_init[0];
        RS = attn_scalars_init[1];
        RB = 1 << (RS - 1);
    }

    void stream_copy2(
        hls::stream<hls::vector<__attn_if_t, TP*CAP> >& i_stream,
        hls::stream<hls::vector<__attn_if_t, TP*CAP> >& o_stream1,
        hls::stream<hls::vector<__attn_if_t, TP*CAP> >& o_stream2
    ) const {
        for(int tt=0; tt<TT; ++tt){
            for(int cat=0; cat<CAT; ++cat){
                #pragma HLS pipeline II=1

                hls::vector<__attn_if_t, TP*CAP> vec_i = i_stream.read();
                o_stream1.write(vec_i);
                o_stream2.write(vec_i);

            } // end of CAT_LOOP
        } // end of TT_LOOP
    }

    // for qkv matmul, the stream should be copied 3 times
    void stream_copy3(
        hls::stream<hls::vector<__attn_lnq_t, TP*CAP> >& i_stream,
        hls::stream<hls::vector<__attn_lnq_t, TP*CAP> >& o_stream1,
        hls::stream<hls::vector<__attn_lnq_t, TP*CAP> >& o_stream2,
        hls::stream<hls::vector<__attn_lnq_t, TP*CAP> >& o_stream3
    ) const {
        for(int tt=0; tt<TT; ++tt){
            for(int cat=0; cat<CAT; ++cat){
                #pragma HLS pipeline II=1

                hls::vector<__attn_lnq_t, TP*CAP> vec_i = i_stream.read();
                o_stream1.write(vec_i);
                o_stream2.write(vec_i);
                o_stream3.write(vec_i);

            } // end of CAT_LOOP
        } // end of TT_LOOP
    }

    void stream_merge(
        hls::stream<hls::vector<__attn_if_t, TP*CAP> >& i_stream1, // residual branch
        hls::stream<hls::vector<__attn_o_t,  TP*CAP> >& i_stream2, // main branch
        hls::stream<hls::vector<__attn_of_t, TP*CAP> >& o_stream
    ) const {
        for(int tt=0; tt<TT; ++tt){
            for(int cat=0; cat<CAT; ++cat){
                #pragma HLS pipeline II=1

                hls::vector<__attn_if_t, TP*CAP> vec_i1 = i_stream1.read();
                hls::vector<__attn_o_t,  TP*CAP> vec_i2 = i_stream2.read();
                hls::vector<__attn_of_t, TP*CAP> vec_o;

                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS unroll
                    for(int cap=0; cap<CAP; ++cap){
                        #pragma HLS unroll
                        vec_o[tp*CAP + cap] = vec_i2[tp*CAP + cap] + __attn_of_t( (vec_i1[tp*CAP + cap] * RM + RB) >> RS );
                    }
                }

                o_stream.write(vec_o);

            } // end of CAT_LOOP
        } // end of TT_LOOP
    }


    void do_attn(
        hls::stream<hls::vector<__attn_if_t, TP*CAP> >& i_stream,
        hls::stream<hls::vector<__attn_of_t, TP*CAP> >& o_stream
    ) {
        #pragma HLS dataflow

        // backbone streams
        // residual
        hls::stream<hls::vector<__attn_if_t,    TP          * CAP           > > main_sm                 ("main_sm");
        hls::stream<hls::vector<__attn_if_t,    TP          * CAP           > > resi_i_sm               ("resi_i_sm");
        hls::stream<hls::vector<__attn_if_t,    TP          * RESI_CP       > > resi_sm                 ("resi_sm");
        hls::stream<hls::vector<__attn_if_t,    TP          * CAP           > > resi_o_sm               ("resi_o_sm");
        // layernorm
        hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm                  ("lnq_sm");
        // copied
        hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp1              ("lnq_sm_cp1");
        hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp2              ("lnq_sm_cp2");
        hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp3              ("lnq_sm_cp3");
        // qkv matmul
        hls::stream<hls::vector<__attn_q_t,     TP          * Q_QKV_CP      > > q_sm                    ("q_sm");
        hls::stream<hls::vector<__attn_k_t,     TP          * Q_QKV_CP      > > k_sm                    ("k_sm");
        hls::stream<hls::vector<__attn_v_t,     TP          * Q_QKV_CP      > > v_sm                    ("v_sm");
        // qkv quant
        hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm                   ("qq_sm");
        hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm                   ("kq_sm");
        hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm                   ("vq_sm");
        // head split
        hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head1             ("qq_sm_head1");
        hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head2             ("qq_sm_head2");
        hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head3             ("qq_sm_head3");
        // head split
        hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head1             ("kq_sm_head1");
        hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head2             ("kq_sm_head2");
        hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head3             ("kq_sm_head3");
        // head split
        hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head1             ("vq_sm_head1");
        hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head2             ("vq_sm_head2");
        hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head3             ("vq_sm_head3");
        // qk matmul result
        hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head1              ("r_sm_head1");
        hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head2              ("r_sm_head2");
        hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head3              ("r_sm_head3");
        // softmaxq result
        hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head1             ("rq_sm_head1");
        hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head2             ("rq_sm_head2");
        hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head3             ("rq_sm_head3");
        // reshape
        hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head1     ("kq_sm_reshape_head1");
        hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head2     ("kq_sm_reshape_head2");
        hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head3     ("kq_sm_reshape_head3");
        hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head1   ("vq_sm_transpose_head1");
        hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head2   ("vq_sm_transpose_head2");
        hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head3   ("vq_sm_transpose_head3");
        // rv matmul result
        hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head1              ("a_sm_head1");
        hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head2              ("a_sm_head2");
        hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head3              ("a_sm_head3");
        // head merge
        hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm                    ("a_sm");
        // a quant
        hls::stream<hls::vector<__attn_aq_t,    TP          * AQ_CP         > > aq_sm                   ("aq_sm");
        // o matmul
        hls::stream<hls::vector<__attn_o_t,     TP          * CAP           > > o_sm                    ("o_sm");

        // set others to 500
        #pragma HLS stream variable=main_sm                 depth=MAIN_FIFO_DEPTH
        #pragma HLS stream variable=resi_i_sm               depth=RESI_I_FIFO_DEPTH
        #pragma HLS stream variable=resi_sm                 depth=RESI_FIFO_DEPTH
        #pragma HLS stream variable=resi_o_sm               depth=RESI_O_FIFO_DEPTH
        #pragma HLS stream variable=lnq_sm                  depth=LNQ_FIFO_DEPTH
        #pragma HLS stream variable=lnq_sm_cp1              depth=LNQ_CP_FIFO_DEPTH
        #pragma HLS stream variable=lnq_sm_cp2              depth=LNQ_CP_FIFO_DEPTH
        #pragma HLS stream variable=lnq_sm_cp3              depth=LNQ_CP_FIFO_DEPTH
        #pragma HLS stream variable=q_sm                    depth=Q_FIFO_DEPTH
        #pragma HLS stream variable=k_sm                    depth=K_FIFO_DEPTH
        #pragma HLS stream variable=v_sm                    depth=V_FIFO_DEPTH
        #pragma HLS stream variable=qq_sm                   depth=QQ_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm                   depth=KQ_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm                   depth=VQ_FIFO_DEPTH
        #pragma HLS stream variable=qq_sm_head1             depth=QQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=qq_sm_head2             depth=QQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=qq_sm_head3             depth=QQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_head1             depth=KQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_head2             depth=KQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_head3             depth=KQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_head1             depth=VQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_head2             depth=VQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_head3             depth=VQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=r_sm_head1              depth=R_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=r_sm_head2              depth=R_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=r_sm_head3              depth=R_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=rq_sm_head1             depth=RQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=rq_sm_head2             depth=RQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=rq_sm_head3             depth=RQ_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_reshape_head1     depth=KQ_RESHAPE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_reshape_head2     depth=KQ_RESHAPE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=kq_sm_reshape_head3     depth=KQ_RESHAPE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_transpose_head1   depth=VQ_TRANSPOSE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_transpose_head2   depth=VQ_TRANSPOSE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=vq_sm_transpose_head3   depth=VQ_TRANSPOSE_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=a_sm_head1              depth=A_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=a_sm_head2              depth=A_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=a_sm_head3              depth=A_HEAD_FIFO_DEPTH
        #pragma HLS stream variable=a_sm                    depth=A_FIFO_DEPTH
        #pragma HLS stream variable=aq_sm                   depth=AQ_FIFO_DEPTH
        #pragma HLS stream variable=o_sm                    depth=O_FIFO_DEPTH


        // two residual related adapters
        Adapter<__attn_if_t, T, TP, C, CAP, RESI_CP> resi_i_adapter;
        Adapter<__attn_if_t, T, TP, C, RESI_CP, CAP> resi_o_adapter;

        // residual
        this->              stream_copy2    (   i_stream,       main_sm,    resi_i_sm                   );
        resi_i_adapter.     do_adapt        (   resi_i_sm,      resi_sm                                 );
        resi_o_adapter.     do_adapt        (   resi_sm,        resi_o_sm                               );
        // layernorm
        lnq.                do_layernorm    (   main_sm,        lnq_sm                                  );
        // copy stream 3 times,
        this->              stream_copy3    (   lnq_sm,         lnq_sm_cp1, lnq_sm_cp2,  lnq_sm_cp3     );
        // qkv matmul
        matmul_gen_q.       do_matmul       (   lnq_sm_cp1,     q_sm    );
        matmul_gen_k.       do_matmul       (   lnq_sm_cp2,     k_sm    );
        matmul_gen_v.       do_matmul       (   lnq_sm_cp3,     v_sm    );
        // qkv quant
        quant_q.            do_quant        (   q_sm,           qq_sm   );
        quant_k.            do_quant        (   k_sm,           kq_sm   );
        quant_v.            do_quant        (   v_sm,           vq_sm   );
        // head split
        split_q.            do_split        (   qq_sm,          qq_sm_head1,    qq_sm_head2,    qq_sm_head3    );
        split_k.            do_split        (   kq_sm,          kq_sm_head1,    kq_sm_head2,    kq_sm_head3    );
        split_v.            do_split        (   vq_sm,          vq_sm_head1,    vq_sm_head2,    vq_sm_head3    );
        // reshape
        reshape_k_head1.    do_reshape      (   kq_sm_head1,    kq_sm_reshape_head1,    false);
        reshape_k_head2.    do_reshape      (   kq_sm_head2,    kq_sm_reshape_head2,    false);
        reshape_k_head3.    do_reshape      (   kq_sm_head3,    kq_sm_reshape_head3,    false);
        // qk matmul
        matmul_qk_head1.    do_matmul       (   qq_sm_head1,    kq_sm_reshape_head1,    r_sm_head1, false);
        matmul_qk_head2.    do_matmul       (   qq_sm_head2,    kq_sm_reshape_head2,    r_sm_head2, false);
        matmul_qk_head3.    do_matmul       (   qq_sm_head3,    kq_sm_reshape_head3,    r_sm_head3, false);
        // softmaxq
        softmax_qk_head1.   do_softmax      (   r_sm_head1,     rq_sm_head1     );
        softmax_qk_head2.   do_softmax      (   r_sm_head2,     rq_sm_head2     );
        softmax_qk_head3.   do_softmax      (   r_sm_head3,     rq_sm_head3     );
        // reshape
        reshape_v_head1.    do_reshape      (   vq_sm_head1,    vq_sm_transpose_head1,  true);
        reshape_v_head2.    do_reshape      (   vq_sm_head2,    vq_sm_transpose_head2,  true);
        reshape_v_head3.    do_reshape      (   vq_sm_head3,    vq_sm_transpose_head3,  true);
        // rv matmul
        matmul_rv_head1.    do_matmul       (   rq_sm_head1,    vq_sm_transpose_head1,  a_sm_head1, true);
        matmul_rv_head2.    do_matmul       (   rq_sm_head2,    vq_sm_transpose_head2,  a_sm_head2, true);
        matmul_rv_head3.    do_matmul       (   rq_sm_head3,    vq_sm_transpose_head3,  a_sm_head3, true);
        // head merge
        merge_a.            do_merge        (   a_sm_head1,     a_sm_head2,     a_sm_head3,     a_sm);
        quant_a.            do_quant        (   a_sm,           aq_sm                               );
        matmul_gen_o.       do_matmul       (   aq_sm,          o_sm                                );
        stream_merge                        (   resi_o_sm,      o_sm,    o_stream                   );
    }

    // // #ifndef __SYNTHESIS__

    // // void do_attn(
    // //     hls::stream<hls::vector<__attn_if_t, TP*CAP> >& i_stream,
    // //     hls::stream<hls::vector<__attn_of_t, TP*CAP> >& o_stream,
    // //     const int main_ref                  [T*C],
    // //     const int lnq_ref                   [T*C],
    // //     const int q_ref                     [T*C],
    // //     const int k_ref                     [T*C],
    // //     const int v_ref                     [T*C],
    // //     const int qq_ref                    [T*C],
    // //     const int kq_ref                    [T*C],
    // //     const int vq_ref                    [T*C],
    // //     const int qq_split_head1_ref        [T*CH],
    // //     const int qq_split_head2_ref        [T*CH],
    // //     const int qq_split_head3_ref        [T*CH],
    // //     const int kq_split_head1_ref        [T*CH],
    // //     const int kq_split_head2_ref        [T*CH],
    // //     const int kq_split_head3_ref        [T*CH],
    // //     const int vq_split_head1_ref        [T*CH],
    // //     const int vq_split_head2_ref        [T*CH],
    // //     const int vq_split_head3_ref        [T*CH],
    // //     const int qk_matmul_head1_ref       [T*T],
    // //     const int qk_matmul_head2_ref       [T*T],
    // //     const int qk_matmul_head3_ref       [T*T],
    // //     const int softmax_head1_ref         [T*T],
    // //     const int softmax_head2_ref         [T*T],
    // //     const int softmax_head3_ref         [T*T],
    // //     const int vq_reshape_head1_ref      [T*CH],
    // //     const int vq_reshape_head2_ref      [T*CH],
    // //     const int vq_reshape_head3_ref      [T*CH],
    // //     const int rv_matmul_head1_ref       [T*CH],
    // //     const int rv_matmul_head2_ref       [T*CH],
    // //     const int rv_matmul_head3_ref       [T*CH],
    // //     const int aq_ref                    [T*C],
    // //     const int o_matmul_ref              [T*C],
    // //     const int y_ref                     [T*C]
    // // ) {
    // //     #pragma HLS dataflow

    // //     // backbone streams
    // //     // residual
    // //     hls::stream<hls::vector<__attn_if_t,    TP          * CAP           > > main_sm                 ("main_sm");
    // //     hls::stream<hls::vector<__attn_if_t,    TP          * CAP           > > resi_sm                 ("resi_sm");
    // //     // layernorm
    // //     hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm                  ("lnq_sm");
    // //     // copied
    // //     hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp1              ("lnq_sm_cp1");
    // //     hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp2              ("lnq_sm_cp2");
    // //     hls::stream<hls::vector<__attn_lnq_t,   TP          * CAP           > > lnq_sm_cp3              ("lnq_sm_cp3");
    // //     // qkv matmul
    // //     hls::stream<hls::vector<__attn_q_t,     TP          * Q_QKV_CP      > > q_sm                    ("q_sm");
    // //     hls::stream<hls::vector<__attn_k_t,     TP          * Q_QKV_CP      > > k_sm                    ("k_sm");
    // //     hls::stream<hls::vector<__attn_v_t,     TP          * Q_QKV_CP      > > v_sm                    ("v_sm");
    // //     // qkv quant
    // //     hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm                   ("qq_sm");
    // //     hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm                   ("kq_sm");
    // //     hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm                   ("vq_sm");
    // //     // head split
    // //     hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head1             ("qq_sm_head1");
    // //     hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head2             ("qq_sm_head2");
    // //     hls::stream<hls::vector<__attn_qq_t,    TP          * Q_QKV_CP      > > qq_sm_head3             ("qq_sm_head3");
    // //     // head split
    // //     hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head1             ("kq_sm_head1");
    // //     hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head2             ("kq_sm_head2");
    // //     hls::stream<hls::vector<__attn_kq_t,    TP          * Q_QKV_CP      > > kq_sm_head3             ("kq_sm_head3");
    // //     // head split
    // //     hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head1             ("vq_sm_head1");
    // //     hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head2             ("vq_sm_head2");
    // //     hls::stream<hls::vector<__attn_vq_t,    TP          * Q_QKV_CP      > > vq_sm_head3             ("vq_sm_head3");
    // //     // qk matmul result
    // //     hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head1              ("r_sm_head1");
    // //     hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head2              ("r_sm_head2");
    // //     hls::stream<hls::vector<__attn_r_t,     TP          * RQ_CP         > > r_sm_head3              ("r_sm_head3");
    // //     // softmaxq result
    // //     hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head1             ("rq_sm_head1");
    // //     hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head2             ("rq_sm_head2");
    // //     hls::stream<hls::vector<__attn_rq_t,    TP          * RQ_CP         > > rq_sm_head3             ("rq_sm_head3");
    // //     // reshape
    // //     hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head1     ("kq_sm_reshape_head1");
    // //     hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head2     ("kq_sm_reshape_head2");
    // //     hls::stream<hls::vector<__attn_kq_t,    MATMUL_R_COP* MATMUL_R_CIP  > > kq_sm_reshape_head3     ("kq_sm_reshape_head3");
    // //     hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head1   ("vq_sm_transpose_head1");
    // //     hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head2   ("vq_sm_transpose_head2");
    // //     hls::stream<hls::vector<__attn_vq_t,    MATMUL_A_COP* MATMUL_A_CIP  > > vq_sm_transpose_head3   ("vq_sm_transpose_head3");
    // //     // rv matmul result
    // //     hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head1              ("a_sm_head1");
    // //     hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head2              ("a_sm_head2");
    // //     hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm_head3              ("a_sm_head3");
    // //     // head merge
    // //     hls::stream<hls::vector<__attn_a_t,     TP          * AQ_CP         > > a_sm                    ("a_sm");
    // //     // a quant
    // //     hls::stream<hls::vector<__attn_aq_t,    TP          * AQ_CP         > > aq_sm                   ("aq_sm");
    // //     // ao matmul
    // //     hls::stream<hls::vector<__attn_o_t,     TP          * CAP           > > o_sm                    ("o_sm");

    // //     // residual
    // //     stream_copy2                        (   i_stream,       main_sm,    resi_sm                     );          // check_stream<__attn_if_t,   T, TP, C, CAP>(main_sm,     main_ref,   "main");        
    // //                                                                                                                 // check_stream<__attn_if_t,   T, TP, C, CAP>(resi_sm,     main_ref,   "resi");
    // //     // layernorm
    // //     lnq.                do_layernorm    (   main_sm,        lnq_sm                                  );          // check_stream<__attn_lnq_t,  T, TP, C, CAP>(lnq_sm,      lnq_ref,    "lnq");
    // //     // copy stream 3 times,
    // //     stream_copy3                        (   lnq_sm,         lnq_sm_cp1, lnq_sm_cp2,  lnq_sm_cp3     );          // check_stream<__attn_lnq_t,  T, TP, C, CAP>(lnq_sm_cp1,  lnq_ref,    "lnq_cp1");
    // //                                                                                                                 // check_stream<__attn_lnq_t,  T, TP, C, CAP>(lnq_sm_cp2,  lnq_ref,    "lnq_cp2");
    // //                                                                                                                 // check_stream<__attn_lnq_t,  T, TP, C, CAP>(lnq_sm_cp3,  lnq_ref,    "lnq_cp3");
    // //     // qkv matmul
    // //     matmul_gen_q.       do_matmul       (   lnq_sm_cp1,     q_sm        );                                      // check_stream<__attn_q_t,    T, TP, C, Q_QKV_CP>(q_sm,       q_ref,      "q");
    // //     matmul_gen_k.       do_matmul       (   lnq_sm_cp2,     k_sm        );                                      // check_stream<__attn_k_t,    T, TP, C, Q_QKV_CP>(k_sm,       k_ref,      "k");
    // //     matmul_gen_v.       do_matmul       (   lnq_sm_cp3,     v_sm        );                                      // check_stream<__attn_v_t,    T, TP, C, Q_QKV_CP>(v_sm,       v_ref,      "v");
    // //     // qkv quant
    // //     quant_q.            do_quant        (   q_sm,           qq_sm       );                                      // check_stream<__attn_qq_t,   T, TP, C, Q_QKV_CP>(qq_sm,      qq_ref,     "qq");
    // //     quant_k.            do_quant        (   k_sm,           kq_sm       );                                      // check_stream<__attn_kq_t,   T, TP, C, Q_QKV_CP>(kq_sm,      kq_ref,     "kq");
    // //     quant_v.            do_quant        (   v_sm,           vq_sm       );                                      // check_stream<__attn_vq_t,   T, TP, C, Q_QKV_CP>(vq_sm,      vq_ref,     "vq");
    // //     // head split
    // //     split_q.            do_split        (   qq_sm,          qq_sm_head1,    qq_sm_head2,    qq_sm_head3    );   // check_stream<__attn_qq_t,   T, TP, CH, Q_QKV_CP>(qq_sm_head1, qq_split_head1_ref, "qq_head1");   
    // //                                                                                                                 // check_stream<__attn_qq_t,   T, TP, CH, Q_QKV_CP>(qq_sm_head2, qq_split_head2_ref, "qq_head2");   
    // //                                                                                                                 // check_stream<__attn_qq_t,   T, TP, CH, Q_QKV_CP>(qq_sm_head3, qq_split_head3_ref, "qq_head3");
    // //     split_k.            do_split        (   kq_sm,          kq_sm_head1,    kq_sm_head2,    kq_sm_head3    );   // check_stream<__attn_kq_t,   T, TP, CH, Q_QKV_CP>(kq_sm_head1, kq_split_head1_ref, "kq_head1");   
    // //                                                                                                                 // check_stream<__attn_kq_t,   T, TP, CH, Q_QKV_CP>(kq_sm_head2, kq_split_head2_ref, "kq_head2");   
    // //                                                                                                                 // check_stream<__attn_kq_t,   T, TP, CH, Q_QKV_CP>(kq_sm_head3, kq_split_head3_ref, "kq_head3");
    // //     split_v.            do_split        (   vq_sm,          vq_sm_head1,    vq_sm_head2,    vq_sm_head3    );   // check_stream<__attn_vq_t,   T, TP, CH, Q_QKV_CP>(vq_sm_head1, vq_split_head1_ref, "vq_head1");
    // //                                                                                                                 // check_stream<__attn_vq_t,   T, TP, CH, Q_QKV_CP>(vq_sm_head2, vq_split_head2_ref, "vq_head2");
    // //                                                                                                                 // check_stream<__attn_vq_t,   T, TP, CH, Q_QKV_CP>(vq_sm_head3, vq_split_head3_ref, "vq_head3");
    // //     // reshape
    // //     reshape_k_head1.    do_reshape      (   kq_sm_head1,    kq_sm_reshape_head1,    false);                     // check_stream<__attn_kq_t,   T, MATMUL_R_COP, CH, MATMUL_R_CIP>(kq_sm_reshape_head1, kq_split_head1_ref, "kq_reshape_head1");
    // //     reshape_k_head2.    do_reshape      (   kq_sm_head2,    kq_sm_reshape_head2,    false);                     // check_stream<__attn_kq_t,   T, MATMUL_R_COP, CH, MATMUL_R_CIP>(kq_sm_reshape_head2, kq_split_head2_ref, "kq_reshape_head2");
    // //     reshape_k_head3.    do_reshape      (   kq_sm_head3,    kq_sm_reshape_head3,    false);                     // check_stream<__attn_kq_t,   T, MATMUL_R_COP, CH, MATMUL_R_CIP>(kq_sm_reshape_head3, kq_split_head3_ref, "kq_reshape_head3");
    // //     // qk matmul
    // //     matmul_qk_head1.    do_matmul       (   qq_sm_head1,    kq_sm_reshape_head1,    r_sm_head1, false);         // check_stream<__attn_r_t,    T, TP, T, RQ_CP>(r_sm_head1, qk_matmul_head1_ref, "qk_matmul_head1");
    // //     matmul_qk_head2.    do_matmul       (   qq_sm_head2,    kq_sm_reshape_head2,    r_sm_head2, false);         // check_stream<__attn_r_t,    T, TP, T, RQ_CP>(r_sm_head2, qk_matmul_head2_ref, "qk_matmul_head2");
    // //     matmul_qk_head3.    do_matmul       (   qq_sm_head3,    kq_sm_reshape_head3,    r_sm_head3, false);         // check_stream<__attn_r_t,    T, TP, T, RQ_CP>(r_sm_head3, qk_matmul_head3_ref, "qk_matmul_head3");
    // //     // softmaxq
    // //     softmax_qk_head1.   do_softmax      (   r_sm_head1,     rq_sm_head1     );                                  // check_stream<__attn_rq_t,   T, TP, T, RQ_CP>(rq_sm_head1, softmax_head1_ref, "softmax_head1");
    // //     softmax_qk_head2.   do_softmax      (   r_sm_head2,     rq_sm_head2     );                                  // check_stream<__attn_rq_t,   T, TP, T, RQ_CP>(rq_sm_head2, softmax_head2_ref, "softmax_head2");
    // //     softmax_qk_head3.   do_softmax      (   r_sm_head3,     rq_sm_head3     );                                  // check_stream<__attn_rq_t,   T, TP, T, RQ_CP>(rq_sm_head3, softmax_head3_ref, "softmax_head3");
    // //     // reshape
    // //     reshape_v_head1.    do_reshape      (   vq_sm_head1,    vq_sm_transpose_head1,  true);                      // check_stream<__attn_vq_t,   CH, MATMUL_A_COP, T, MATMUL_A_CIP>(vq_sm_transpose_head1, vq_reshape_head1_ref, "vq_reshape_head1");
    // //     reshape_v_head2.    do_reshape      (   vq_sm_head2,    vq_sm_transpose_head2,  true);                      // check_stream<__attn_vq_t,   CH, MATMUL_A_COP, T, MATMUL_A_CIP>(vq_sm_transpose_head2, vq_reshape_head2_ref, "vq_reshape_head2");
    // //     reshape_v_head3.    do_reshape      (   vq_sm_head3,    vq_sm_transpose_head3,  true);                      // check_stream<__attn_vq_t,   CH, MATMUL_A_COP, T, MATMUL_A_CIP>(vq_sm_transpose_head3, vq_reshape_head3_ref, "vq_reshape_head3");
    // //     // rv matmul
    // //     matmul_rv_head1.    do_matmul       (   rq_sm_head1,    vq_sm_transpose_head1,  a_sm_head1, true);          check_stream<__attn_a_t,    T, TP, CH, AQ_CP>(a_sm_head1, rv_matmul_head1_ref, "rv_matmul_head1");
    // //     matmul_rv_head2.    do_matmul       (   rq_sm_head2,    vq_sm_transpose_head2,  a_sm_head2, true);          check_stream<__attn_a_t,    T, TP, CH, AQ_CP>(a_sm_head2, rv_matmul_head2_ref, "rv_matmul_head2");
    // //     matmul_rv_head3.    do_matmul       (   rq_sm_head3,    vq_sm_transpose_head3,  a_sm_head3, true);          check_stream<__attn_a_t,    T, TP, CH, AQ_CP>(a_sm_head3, rv_matmul_head3_ref, "rv_matmul_head3");
    // //     // head merge
    // //     merge_a.            do_merge        (   a_sm_head1,     a_sm_head2,     a_sm_head3,     a_sm);              
    // //     quant_a.            do_quant        (   a_sm,           aq_sm                               );              check_stream<__attn_aq_t,   T, TP, C,  AQ_CP>   (aq_sm, aq_ref,         "aq");
    // //     matmul_gen_o.       do_matmul       (   aq_sm,          o_sm                                );              check_stream<__attn_o_t,    T, TP, C,  CAP>     (o_sm,  o_matmul_ref,   "o");
    // //     stream_merge                        (   resi_sm,        o_sm,    o_stream                   );              check_stream<__attn_of_t,   T, TP, C,  CAP>     (o_stream, y_ref,       "y");
    // // }

    // // #endif

};

#endif