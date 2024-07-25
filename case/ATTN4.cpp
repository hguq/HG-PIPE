#include "../src/common.h"
#include "../src/attn.h"

// ATTN

// attn global shapes
const int H         = 3;
const int T         = 196;
const int TP        = 2;
const int C         = 192;
const int CAP       = 1;
const int RESI_CP   = 2;

// layernorm
// use same TP and CP

// qkv generation parallel degree
const int MATMUL_QKV_CIP    = 6;
const int MATMUL_QKV_COP    = 12;

// qkv quantize parallel degree
const int Q_QKV_CP          = 1;

// QK = R
const int MATMUL_R_CIP      = 4;
const int MATMUL_R_COP      = 7;

// softmax for R
const int RQ_CP             = 1;    // TP=2, total>3, therefore, CP=2

// RV = A
const int MATMUL_A_CIP      = 7;
const int MATMUL_A_COP      = 4;

// a quantize parallel degree
const int AQ_CP             = 1;

// O
const int MATMUL_O_CIP      = 12;
const int MATMUL_O_COP      = 6;

// attn global tyeps
typedef ap_int   <  13 >   __attn_if_t;
typedef ap_int   <   3 >   __attn_lnq_t;
typedef ap_int   <  11 >   __attn_q_t;
typedef ap_int   <  10 >   __attn_k_t;
typedef ap_int   <  10 >   __attn_v_t;
typedef ap_int   <  10 >   __attn_r_t;
typedef ap_int   <  11 >   __attn_a_t;
typedef ap_int   <  10 >   __attn_o_t;
typedef ap_int   <   3 >   __attn_qq_t;
typedef ap_int   <   3 >   __attn_kq_t;
typedef ap_int   <   3 >   __attn_vq_t;
typedef ap_uint  <   3 >   __attn_rq_t;
typedef ap_int   <   3 >   __attn_aq_t;
typedef ap_int   <  13 >   __attn_of_t;    // output, not o matrix

// layernorm
typedef ap_int   <  17 >   __ln_sum_t;
typedef ap_int   <  33 >   __ln_divc_t;
typedef ap_int   <  10 >   __ln_mu_t;
typedef ap_uint  <  25 >   __ln_var_t;
typedef ap_uint  <   7 >   __ln_cursor_t;
typedef ap_uint  <  12 >   __ln_rsqrt_t;
typedef ap_int   <  39 >   __ln_affine_t;
typedef ap_int   <   6 >   __ln_shift_t;
const int LN_ENTRIES_RSQRT = 128;

// q generation
typedef ap_int  <   3   >   __q_we_t;
typedef __attn_q_t          __q_bi_t;
// const int Q_ADPT_FIFO_DEPTH
// const int Q_WIND_FIFO_DEPTH
// const int Q_WGHT_FIFO_DEPTH
// const int Q_MACS_FIFO_DEPTH
const int Q_WEIGHT_RAM_STYLE = BRAM_STYLE;
const bool Q_USE_DSP = false;

// k generation
typedef ap_int  <   3   >   __k_we_t;
typedef __attn_k_t          __k_bi_t;
// const int K_ADPT_FIFO_DEPTH
// const int K_WIND_FIFO_DEPTH
// const int K_WGHT_FIFO_DEPTH
// const int K_MACS_FIFO_DEPTH
const int K_WEIGHT_RAM_STYLE = BRAM_STYLE;
const bool K_USE_DSP = false;

// v generation
typedef ap_int  <   3   >   __v_we_t;
typedef __attn_v_t          __v_bi_t;
// const int V_ADPT_FIFO_DEPTH
// const int V_WIND_FIFO_DEPTH
// const int V_WGHT_FIFO_DEPTH
// const int V_MACS_FIFO_DEPTH
const int V_WEIGHT_RAM_STYLE = BRAM_STYLE;
const bool V_USE_DSP = false;

// qq
typedef ap_int   <   9 >   __qq_cursor_t;
const int QQ_ENTRIES = 64;

// kq
typedef ap_int   <   9 >   __kq_cursor_t;
const int KQ_ENTRIES = 64;

// vq
typedef ap_int   <   9 >   __vq_cursor_t;
const int VQ_ENTRIES = 64;


// no rq, r is quantized by softmaxq

// aq
typedef ap_int   <   9 >   __aq_cursor_t;
const int AQ_ENTRIES = 64;

// qk matmul
// const int QK_MATMUL_ADPT_FIFO_DEPTH
// const int QK_MATMUL_WIND_FIFO_DEPTH
// const int QK_MATMUL_WGHT_FIFO_DEPTH
// const int QK_MATMUL_MACS_FIFO_DEPTH
const int QK_MATMUL_WEIGHT_RAM_STYLE = LRAM_STYLE;
const bool QK_MATMUL_USE_DSP = false;

// softmax
typedef ap_int   <  11 >   __softmax_minus_t;              
typedef ap_uint  <   6 >   __softmax_cursor1_t;            
typedef ap_uint  <  16 >   __softmax_exp_t;                
typedef ap_uint  <  22 >   __softmax_acc_t;                
typedef ap_uint  <   8 >   __softmax_recip_t;
typedef ap_uint  <   9 >   __softmax_cursor2_one_t;        
typedef ap_int   <   7 >   __softmax_cursor2_two_t;        
typedef ap_uint  <  23 >   __softmax_affine_t;             
typedef ap_uint  <   7 >   __softmax_cursor3_t;
const int SOFTMAX_ENTRIES_EXP       = 32;
const int SOFTMAX_ENTRIES_RECIP     = 64;

// rv matmul
// const int RV_MATMUL_ADPT_FIFO_DEPTH
// const int RV_MATMUL_WIND_FIFO_DEPTH
// const int RV_MATMUL_WGHT_FIFO_DEPTH
// const int RV_MATMUL_MACS_FIFO_DEPTH
const int RV_MATMUL_WEIGHT_RAM_STYLE = LRAM_STYLE;
const bool RV_MATMUL_USE_DSP = false;

// o matmul
typedef ap_int  <   3   >   __o_we_t;
typedef __attn_o_t          __o_bi_t;
// const int O_MATMUL_ADPT_FIFO_DEPTH
// const int O_MATMUL_WIND_FIFO_DEPTH
// const int O_MATMUL_WGHT_FIFO_DEPTH
// const int O_MATMUL_MACS_FIFO_DEPTH
const int O_MATMUL_WEIGHT_RAM_STYLE = BRAM_STYLE;
const bool O_MATMUL_USE_DSP = false;


// FIFO depths
// const int Q_ADPT_FIFO_DEPTH             = 16000;
// const int Q_WIND_FIFO_DEPTH             = 16001;
// const int Q_WGHT_FIFO_DEPTH             = 16002;
// const int Q_MACS_FIFO_DEPTH             = 16003;

// const int K_ADPT_FIFO_DEPTH             = 16004;
// const int K_WIND_FIFO_DEPTH             = 16005;
// const int K_WGHT_FIFO_DEPTH             = 16006;
// const int K_MACS_FIFO_DEPTH             = 16007;

// const int V_ADPT_FIFO_DEPTH             = 16008;
// const int V_WIND_FIFO_DEPTH             = 16009;
// const int V_WGHT_FIFO_DEPTH             = 16010;
// const int V_MACS_FIFO_DEPTH             = 16011;

// const int QK_MATMUL_ADPT_FIFO_DEPTH     = 16012;
// const int QK_MATMUL_WIND_FIFO_DEPTH     = 16013;
// const int QK_MATMUL_WGHT_FIFO_DEPTH     = 16014;
// const int QK_MATMUL_MACS_FIFO_DEPTH     = 16015;

// const int RV_MATMUL_ADPT_FIFO_DEPTH     = 16016;
// const int RV_MATMUL_WIND_FIFO_DEPTH     = 16017;
// const int RV_MATMUL_WGHT_FIFO_DEPTH     = 16018;
// const int RV_MATMUL_MACS_FIFO_DEPTH     = 16019;

// const int O_MATMUL_ADPT_FIFO_DEPTH      = 16020;
// const int O_MATMUL_WIND_FIFO_DEPTH      = 16021;
// const int O_MATMUL_WGHT_FIFO_DEPTH      = 16022;
// const int O_MATMUL_MACS_FIFO_DEPTH      = 16023;

// const int MAIN_FIFO_DEPTH               = 16024;
// const int RESI_I_FIFO_DEPTH             = 16025;
// const int RESI_FIFO_DEPTH               = 16026;
// const int RESI_O_FIFO_DEPTH             = 16027;
// const int LNQ_FIFO_DEPTH                = 16028;
// const int LNQ_CP_FIFO_DEPTH             = 16029;
// const int Q_FIFO_DEPTH                  = 16030;
// const int K_FIFO_DEPTH                  = 16031;
// const int V_FIFO_DEPTH                  = 16032;
// const int QQ_FIFO_DEPTH                 = 16033;
// const int KQ_FIFO_DEPTH                 = 16034;
// const int VQ_FIFO_DEPTH                 = 16035;
// const int QQ_HEAD_FIFO_DEPTH            = 16036;
// const int KQ_HEAD_FIFO_DEPTH            = 16037;
// const int VQ_HEAD_FIFO_DEPTH            = 16038;
// const int R_HEAD_FIFO_DEPTH             = 16039;
// const int RQ_HEAD_FIFO_DEPTH            = 16040;
// const int KQ_RESHAPE_HEAD_FIFO_DEPTH    = 16041;
// const int VQ_TRANSPOSE_HEAD_FIFO_DEPTH  = 16042;
// const int A_HEAD_FIFO_DEPTH             = 16043;
// const int A_FIFO_DEPTH                  = 16044;
// const int AQ_FIFO_DEPTH                 = 16045;
// const int O_FIFO_DEPTH                  = 16046;

const int Q_ADPT_FIFO_DEPTH             = 32;
const int Q_WIND_FIFO_DEPTH             = 2;
const int Q_WGHT_FIFO_DEPTH             = 0;
const int Q_MACS_FIFO_DEPTH             = 2;

const int K_ADPT_FIFO_DEPTH             = 32;
const int K_WIND_FIFO_DEPTH             = 2;
const int K_WGHT_FIFO_DEPTH             = 0;
const int K_MACS_FIFO_DEPTH             = 2;

const int V_ADPT_FIFO_DEPTH             = 32;
const int V_WIND_FIFO_DEPTH             = 2;
const int V_WGHT_FIFO_DEPTH             = 0;
const int V_MACS_FIFO_DEPTH             = 2;

const int QK_MATMUL_ADPT_FIFO_DEPTH     = 32;
const int QK_MATMUL_WIND_FIFO_DEPTH     = 2;
const int QK_MATMUL_WGHT_FIFO_DEPTH     = 2;
const int QK_MATMUL_MACS_FIFO_DEPTH     = 2;

const int RV_MATMUL_ADPT_FIFO_DEPTH     = 32;
const int RV_MATMUL_WIND_FIFO_DEPTH     = 2;
const int RV_MATMUL_WGHT_FIFO_DEPTH     = 2;
const int RV_MATMUL_MACS_FIFO_DEPTH     = 2;

const int O_MATMUL_ADPT_FIFO_DEPTH      = 32;
const int O_MATMUL_WIND_FIFO_DEPTH      = 2;
const int O_MATMUL_WGHT_FIFO_DEPTH      = 0;
const int O_MATMUL_MACS_FIFO_DEPTH      = 2;

const int MAIN_FIFO_DEPTH               = 2;
const int RESI_I_FIFO_DEPTH             = 512;
const int RESI_FIFO_DEPTH               = 4096 * 3; // 3 URAMs
const int RESI_O_FIFO_DEPTH             = 512;
const int LNQ_FIFO_DEPTH                = 2;
const int LNQ_CP_FIFO_DEPTH             = 2;
const int Q_FIFO_DEPTH                  = 2;
const int K_FIFO_DEPTH                  = 2;
const int V_FIFO_DEPTH                  = 2;
const int QQ_FIFO_DEPTH                 = 2;
const int KQ_FIFO_DEPTH                 = 2;
const int VQ_FIFO_DEPTH                 = 2;
const int QQ_HEAD_FIFO_DEPTH            = 8000;
const int KQ_HEAD_FIFO_DEPTH            = 64;
const int VQ_HEAD_FIFO_DEPTH            = 64;
const int R_HEAD_FIFO_DEPTH             = 512;
const int RQ_HEAD_FIFO_DEPTH            = 512;
const int KQ_RESHAPE_HEAD_FIFO_DEPTH    = 512;
const int VQ_TRANSPOSE_HEAD_FIFO_DEPTH  = 512;
const int A_HEAD_FIFO_DEPTH             = 64;
const int A_FIFO_DEPTH                  = 2;
const int AQ_FIFO_DEPTH                 = 2;
const int O_FIFO_DEPTH                  = 2;


// static hyper parameters
const int CH    = C / H;
const int TT    = T / TP;
const int CAT   = C / CAP;


// weights
const int attn_scalars_init [] = {
    #include "./refs/attn_4_scalars.txt"
};
const int attn_lnq_scalars_init [] = {
    #include "./refs/attn_4_lnq_scalars.txt"
};
const int64_t attn_lnq_lnb_m_init [] = {
    #include "./refs/attn_4_lnq_lnb_m.txt"
};
const int attn_lnq_lnw_m_init [] = {
    #include "./refs/attn_4_lnq_lnw_m.txt"
};
const int attn_lnq_rsqrt_table_init [] = {
    #include "./refs/attn_4_lnq_rsqrt_table_m.txt"
};
const int attn_q_weight_init [C][C] = {
    #include "./refs/attn_4_gen_q_matmul_weight.txt"
};
const int attn_q_bias_init [C] = {
    #include "./refs/attn_4_gen_q_matmul_bias.txt"
};
const int attn_k_weight_init [C][C] = {
    // #include "./refs/attn_4_Iwk.txt"
    #include "./refs/attn_4_gen_k_matmul_weight.txt"
};
const int attn_k_bias_init [C] = {
    #include "./refs/attn_4_gen_k_matmul_bias.txt"
};
const int attn_v_weight_init [C][C] = {
    // #include "./refs/attn_4_Iwv.txt"
    #include "./refs/attn_4_gen_v_matmul_weight.txt"
};
const int attn_v_bias_init [C] = {
    #include "./refs/attn_4_gen_v_matmul_bias.txt"
};
const int attn_qq_scalars_init [] = {
    #include "./refs/attn_4_q_q_scalars.txt"
};
const int attn_qq_table_init [] = {
    #include "./refs/attn_4_q_q_table_m.txt"
};
const int attn_kq_scalars_init [] = {
    #include "./refs/attn_4_k_q_scalars.txt"
};
const int attn_kq_table_init [] = {
    #include "./refs/attn_4_k_q_table_m.txt"
};
const int attn_vq_scalars_init [] = {
    #include "./refs/attn_4_v_q_scalars.txt"
};
const int attn_vq_table_init [] = {
    #include "./refs/attn_4_v_q_table_m.txt"
};
const int attn_aq_scalars_init [] = {
    #include "./refs/attn_4_a_q_scalars.txt"
};
const int attn_aq_table_init [] = {
    #include "./refs/attn_4_a_q_table_m.txt"
};
const int attn_softmax_scalars_init [] = {
    #include "./refs/attn_4_softmaxq_scalars.txt"
};
const int attn_softmax_exp_table_init [] = {
    #include "./refs/attn_4_softmaxq_exp_opp_table_m.txt"
};
const int attn_softmax_recip_table_one_init [] = {
    #include "./refs/attn_4_softmaxq_recip_scaled_table_m_one.txt"
};
const int attn_softmax_recip_table_two_init [] = {
    #include "./refs/attn_4_softmaxq_recip_scaled_table_m_two.txt"
};
const int attn_o_weight_init [C][C] = {
    // #include "./refs/attn_4_Iwo.txt"
    #include "./refs/attn_4_gen_o_matmul_weight.txt"
};
const int attn_o_bias_init [C] = {
    #include "./refs/attn_4_gen_o_matmul_bias.txt"
};


// test refs
const int x_ref[T][C] = {
    #include "./refs/attn_4_input.txt"
};
const int y_ref[T][C] = {
    #include "./refs/attn_4_output.txt"
};

// internal refv
const int main_ref[] = {
    #include "./refs/attn_4_input.txt"
};
const int lnq_ref[] = {
    #include "./refs/attn_4_lnq_output.txt"
};
const int q_ref[] = {
    #include "./refs/attn_4_gen_q_matmul_output.txt"
};
const int k_ref[] = {
    #include "./refs/attn_4_gen_k_matmul_output.txt"
};
const int v_ref[] = {
    #include "./refs/attn_4_gen_v_matmul_output.txt"
};
const int qq_ref[] = {
    #include "./refs/attn_4_qq_output.txt"
};
const int kq_ref[] = {
    #include "./refs/attn_4_kq_output.txt"
};
const int vq_ref[] = {
    #include "./refs/attn_4_vq_output.txt"
};

const int qq_split_ref[] = {
    #include "./refs/attn_4_gen_r_matmul_input.txt"
};
const int *qq_split_head1_ref = qq_split_ref;
const int *qq_split_head2_ref = qq_split_ref + T*CH;
const int *qq_split_head3_ref = qq_split_ref + T*CH*2;

const int kq_split_ref[] = {
    #include "./refs/attn_4_gen_r_matmul_weight.txt"
};
const int *kq_split_head1_ref = kq_split_ref;
const int *kq_split_head2_ref = kq_split_ref + T*CH;
const int *kq_split_head3_ref = kq_split_ref + T*CH*2;

const int vq_split_ref[] = {
    #include "./refs/attn_4_gen_a_matmul_weight_transpose.txt"
};
const int *vq_split_head1_ref = vq_split_ref;
const int *vq_split_head2_ref = vq_split_ref + T*CH;
const int *vq_split_head3_ref = vq_split_ref + T*CH*2;

const int kq_matmul_ref[] = {
    #include "./refs/attn_4_gen_r_matmul_output.txt"
};
const int* kq_matmul_head1_ref = kq_matmul_ref;
const int* kq_matmul_head2_ref = kq_matmul_ref + T*T;
const int* kq_matmul_head3_ref = kq_matmul_ref + T*T*2;

const int softmax_ref[] = {
    #include "./refs/attn_4_softmaxq_output.txt"
};
const int* softmax_head1_ref = softmax_ref;
const int* softmax_head2_ref = softmax_ref + T*T;
const int* softmax_head3_ref = softmax_ref + T*T*2;

const int vq_reshape_ref[] = {
    // #include "./refs/attn_4_gen_a_matmul_weight.txt"
    #include "./refs/attn_4_qq_output.txt"
};
const int* vq_reshape_head1_ref = vq_reshape_ref;
const int* vq_reshape_head2_ref = vq_reshape_ref + T*CH;
const int* vq_reshape_head3_ref = vq_reshape_ref + T*CH*2;

const int rv_matmul_ref[] = {
    #include "./refs/attn_4_gen_a_matmul_output.txt"
};
const int* rv_matmul_head1_ref = rv_matmul_ref;
const int* rv_matmul_head2_ref = rv_matmul_ref + T*CH;
const int* rv_matmul_head3_ref = rv_matmul_ref + T*CH*2;

const int a_ref[] = {
    #include "./refs/attn_4_gen_o_matmul_input.txt"
};

const int o_ref[] = {
    #include "./refs/attn_4_gen_o_matmul_output.txt"
};

// attn
Attn<
    H,
    T,
    TP,
    C,
    CAP,
    RESI_CP,

    MATMUL_QKV_CIP,
    MATMUL_QKV_COP,

    Q_QKV_CP,

    MATMUL_R_CIP,
    MATMUL_R_COP,

    RQ_CP,

    MATMUL_A_CIP,
    MATMUL_A_COP,

    AQ_CP,

    MATMUL_O_CIP,
    MATMUL_O_COP,

    __attn_if_t,
    __attn_lnq_t,
    __attn_q_t,
    __attn_k_t,
    __attn_v_t,
    __attn_r_t,
    __attn_a_t,
    __attn_o_t,
    __attn_qq_t,
    __attn_kq_t,
    __attn_vq_t,
    __attn_rq_t,
    __attn_aq_t,
    __attn_of_t,

    __ln_sum_t,
    __ln_divc_t,
    __ln_mu_t,
    __ln_var_t,
    __ln_cursor_t,
    __ln_rsqrt_t,
    __ln_affine_t,
    __ln_shift_t,
    LN_ENTRIES_RSQRT,

    __q_we_t,
    __q_bi_t,
    Q_ADPT_FIFO_DEPTH,
    Q_WIND_FIFO_DEPTH,
    Q_WGHT_FIFO_DEPTH,
    Q_MACS_FIFO_DEPTH,
    Q_WEIGHT_RAM_STYLE,
    Q_USE_DSP,

    __k_we_t,
    __k_bi_t,
    K_ADPT_FIFO_DEPTH,
    K_WIND_FIFO_DEPTH,
    K_WGHT_FIFO_DEPTH,
    K_MACS_FIFO_DEPTH,
    K_WEIGHT_RAM_STYLE,
    K_USE_DSP,

    __v_we_t,
    __v_bi_t,
    V_ADPT_FIFO_DEPTH,
    V_WIND_FIFO_DEPTH,
    V_WGHT_FIFO_DEPTH,
    V_MACS_FIFO_DEPTH,
    V_WEIGHT_RAM_STYLE,
    V_USE_DSP,

    __qq_cursor_t,
    QQ_ENTRIES,

    __kq_cursor_t,
    KQ_ENTRIES,

    __vq_cursor_t,
    VQ_ENTRIES,

    __aq_cursor_t,
    AQ_ENTRIES,

    QK_MATMUL_ADPT_FIFO_DEPTH,
    QK_MATMUL_WIND_FIFO_DEPTH,
    QK_MATMUL_WGHT_FIFO_DEPTH,
    QK_MATMUL_MACS_FIFO_DEPTH,
    QK_MATMUL_WEIGHT_RAM_STYLE,
    QK_MATMUL_USE_DSP,

    __softmax_minus_t,
    __softmax_cursor1_t,
    __softmax_exp_t,
    __softmax_acc_t,
    __softmax_recip_t,
    __softmax_cursor2_one_t,
    __softmax_cursor2_two_t,
    __softmax_affine_t,
    __softmax_cursor3_t,
    SOFTMAX_ENTRIES_EXP,
    SOFTMAX_ENTRIES_RECIP,

    RV_MATMUL_ADPT_FIFO_DEPTH,
    RV_MATMUL_WIND_FIFO_DEPTH,
    RV_MATMUL_WGHT_FIFO_DEPTH,
    RV_MATMUL_MACS_FIFO_DEPTH,
    RV_MATMUL_WEIGHT_RAM_STYLE,
    RV_MATMUL_USE_DSP,

    __o_we_t,
    __o_bi_t,
    O_MATMUL_ADPT_FIFO_DEPTH,
    O_MATMUL_WIND_FIFO_DEPTH,
    O_MATMUL_WGHT_FIFO_DEPTH,
    O_MATMUL_MACS_FIFO_DEPTH,
    O_MATMUL_WEIGHT_RAM_STYLE,
    O_MATMUL_USE_DSP,

    MAIN_FIFO_DEPTH,
    RESI_I_FIFO_DEPTH,
    RESI_FIFO_DEPTH,
    RESI_O_FIFO_DEPTH,
    LNQ_FIFO_DEPTH,
    LNQ_CP_FIFO_DEPTH,
    Q_FIFO_DEPTH,
    K_FIFO_DEPTH,
    V_FIFO_DEPTH,
    QQ_FIFO_DEPTH,
    KQ_FIFO_DEPTH,
    VQ_FIFO_DEPTH,
    QQ_HEAD_FIFO_DEPTH,
    KQ_HEAD_FIFO_DEPTH,
    VQ_HEAD_FIFO_DEPTH,
    R_HEAD_FIFO_DEPTH,
    RQ_HEAD_FIFO_DEPTH,
    KQ_RESHAPE_HEAD_FIFO_DEPTH,
    VQ_TRANSPOSE_HEAD_FIFO_DEPTH,
    A_HEAD_FIFO_DEPTH,
    A_FIFO_DEPTH,
    AQ_FIFO_DEPTH,
    O_FIFO_DEPTH
> attn_inst(
    attn_scalars_init,
    attn_lnq_scalars_init,
    attn_lnq_lnw_m_init,
    attn_lnq_lnb_m_init,
    attn_lnq_rsqrt_table_init,
    attn_q_weight_init,
    attn_k_weight_init,
    attn_v_weight_init,
    attn_q_bias_init,
    attn_k_bias_init,
    attn_v_bias_init,
    attn_qq_scalars_init,
    attn_qq_table_init,
    attn_kq_scalars_init,
    attn_kq_table_init,
    attn_vq_scalars_init,
    attn_vq_table_init,
    attn_aq_scalars_init,
    attn_aq_table_init,
    attn_softmax_scalars_init,
    attn_softmax_exp_table_init,
    attn_softmax_recip_table_one_init,
    attn_softmax_recip_table_two_init,
    attn_o_weight_init,
    attn_o_bias_init
);


int y_dut[T][C];

void top(hls::stream<hls::vector<__attn_if_t, TP*CAP> >& i_stream, hls::stream<hls::vector<__attn_of_t, TP*CAP> >& o_stream){
    #pragma HLS dataflow
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    // attn_inst.do_attn(
    //     i_stream, o_stream,
    //     main_ref, lnq_ref, 
    //     q_ref, k_ref, v_ref, 
    //     qq_ref, kq_ref, vq_ref,
    //     qq_split_head1_ref, qq_split_head2_ref, qq_split_head3_ref,
    //     kq_split_head1_ref, kq_split_head2_ref, kq_split_head3_ref,
    //     vq_split_head1_ref, vq_split_head2_ref, vq_split_head3_ref,
    //     kq_matmul_head1_ref, kq_matmul_head2_ref, kq_matmul_head3_ref,
    //     softmax_head1_ref, softmax_head2_ref, softmax_head3_ref,
    //     vq_reshape_head1_ref, vq_reshape_head2_ref, vq_reshape_head3_ref,
    //     rv_matmul_head1_ref, rv_matmul_head2_ref, rv_matmul_head3_ref,
    //     a_ref,
    //     o_ref,
    //     (const int *)y_ref
    // );

    attn_inst.do_attn(i_stream, o_stream);

    // attn_inst.do_attn_tasks(i_stream, o_stream);

}

int main(){

    // stream declaration
    hls::stream<hls::vector<__attn_if_t, TP*CAP> > i_stream("i_stream");
    hls::stream<hls::vector<__attn_of_t, TP*CAP> > o_stream("o_stream");

    const int TEST_ROUND = 4; // how many rounds. data are replicated

    // write stream
    for(int test_round=0; test_round<TEST_ROUND; test_round++){
        for(int tt=0; tt<TT; tt++){
            for(int cat=0; cat<CAT; cat++){

                hls::vector<__attn_if_t,TP*CAP> vec_i;

                for(int tp=0; tp<TP; tp++){
                    for(int cap=0; cap<CAP; cap++){
                        vec_i[tp*CAP + cap] = x_ref[tt*TP + tp][cat*CAP + cap];
                    }
                }

                // write the same data for TEST_ROUND times
                i_stream.write(vec_i);

            }
        }
    }

    printf("i_stream size = %d\n", i_stream.size());

    // call top
    for(int test_round=0; test_round<TEST_ROUND; test_round++){
        top(i_stream, o_stream);
    }

    // read stream
    for(int test_round=0; test_round<TEST_ROUND; test_round++){
        for(int tt=0; tt<TT; tt++){
            for(int cat=0; cat<CAT; cat++){

                hls::vector<__attn_of_t,TP*CAP> vec_o = o_stream.read();

                for(int tp=0; tp<TP; tp++){
                    for(int cap=0; cap<CAP; cap++){
                        y_dut[tt*TP + tp][cat*CAP + cap] = vec_o[tp*CAP + cap];
                    }
                }

            }
        }
    }

    printf("o_stream size = %d\n", o_stream.size());

    // compare
    bool flag = true;
    for(int test_round=0; test_round<TEST_ROUND; test_round++){
        for(int t=0; t<T; t++){
            for(int c=0; c<C; c++){
                if(y_dut[t][c] != y_ref[t][c]) {
                    flag = false;
                    printf("at round %d, y_dut[%d][%d] is %d, y_ref[%d][%d] is %d\n", test_round, t, c, y_dut[t][c], t, c, y_ref[t][c]);
                }
            }
        }
    }

    if(flag)    printf("PASS!\n");
    else        printf("FAIL!\n");

    return 0;
}

