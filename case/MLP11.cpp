#include "../src/common.h"
#include "../src/mlp.h"

// MLP
const int T         = 196;
const int TP        = 2;
const int C         = 192;
const int CAP       = 1;
const int RESI_CP   = 2;
const int CH        = 768;
const int CHAP      = 2;

// global data type
typedef ap_int   <  13 >   __mlp_if_t;
typedef ap_int   <   3 >   __mlp_ln_t;
typedef ap_int   <  11 >   __mlp_m1_t;
typedef ap_uint  <   3 >   __mlp_ge_t;
typedef ap_int   <  11 >   __mlp_m2_t;
typedef ap_int   <  13 >   __mlp_of_t;

// layernorm


typedef ap_int   <  16 >   __ln_sum_t;
typedef ap_int   <  32 >   __ln_divc_t;
typedef ap_int   <   9 >   __ln_mu_t;
typedef ap_uint  <  25 >   __ln_var_t;
typedef ap_uint  <   7 >   __ln_cursor_t;
typedef ap_uint  <  12 >   __ln_rsqrt_t;
typedef ap_int   <  38 >   __ln_affine_t;
typedef ap_int   <   6 >   __ln_shift_t;

const int LN_ENTRIES_RSQRT      = 128;

// matmul 1

typedef ap_int  <   3 >   __m1_we_t;
typedef ap_int   <  11 >   __m1_bi_t;
typedef ap_int   <  11 >   __m1_mc_t;


const int M1_CIP                = 12;
const int M1_COP                = 24;
const int M1_ADPT_FIFO_DEPTH    = 32;
const int M1_WIND_FIFO_DEPTH    = 2;
const int M1_WGHT_FIFO_DEPTH    = 0;    // no such fifo
const int M1_MACS_FIFO_DEPTH    = 2;
const bool M1_USE_DSP           = false;

// gelu
typedef ap_int   <   9 >   __gelu_cursor_t;
const int GELU_ENTRIES          = 64;

// matmul 2
typedef ap_int  <   3 >   __m2_we_t;
typedef ap_int   <  13 >   __m2_bi_t;
typedef ap_int   <  13 >   __m2_mc_t;


const int M2_CIP                = 24;
const int M2_COP                = 12;
const int M2_ADPT_FIFO_DEPTH    = 32;
const int M2_WIND_FIFO_DEPTH    = 2;
const int M2_WGHT_FIFO_DEPTH    = 0;    // no such fifo
const int M2_MACS_FIFO_DEPTH    = 2;
const bool M2_USE_DSP           = false;

// static hyper parameters
const int TT    = T / TP;
const int CAT   = C / CAP;



// weights
const int mlp_scalars_init [] = {
    #include "./refs/mlp_11_scalars.txt"
};
const int mlp_lnq_scalars_init [] = {
    #include "./refs/mlp_11_lnq_scalars.txt"
};
const long long mlp_lnq_lnb_m_init [] = {
    #include "./refs/mlp_11_lnq_lnb_m.txt"
};
const int mlp_lnq_lnw_m_init [] = {
    #include "./refs/mlp_11_lnq_lnw_m.txt"
};
const int mlp_lnq_rsqrt_table_init [] = {
    #include "./refs/mlp_11_lnq_rsqrt_table_m.txt"
};
const int mlp_m1_weight_init [CH][C] = {
    #include "./refs/mlp_11_matmul1_weight.txt"
};
const int mlp_m1_bias_init [CH] = {
    #include "./refs/mlp_11_matmul1_bias.txt"
};
const int mlp_gelu_scalars_init [] = {
    #include "./refs/mlp_11_geluq_scalars.txt"
};
const int mlp_gelu_table_init [] = {
    #include "./refs/mlp_11_geluq_table_m.txt"
};
const int mlp_m2_weight_init [C][CH] = {
    // #include "./refs/mlp_11_Iw2.txt"
    #include "./refs/mlp_11_matmul2_weight.txt"
};
const int mlp_m2_bias_init [C] = {
    #include "./refs/mlp_11_matmul2_bias.txt"
};

// test refs
const int x_ref[T][C] = {
    #include "./refs/mlp_11_input.txt"
};
const int y_ref[T][C] = {
    #include "./refs/mlp_11_output.txt"
};

// internal refs
const int main_ref[] = {
    #include "./refs/mlp_11_input.txt"
};
const int lnq_ref[] = {
    #include "./refs/mlp_11_lnq_output.txt"
};
const int m1_ref[] = {
    #include "./refs/mlp_11_matmul1_output.txt"
};
const int gelu_ref[] = {
    #include "./refs/mlp_11_geluq_output.txt"
};
const int m2_ref[] = {
    #include "./refs/mlp_11_matmul2_output.txt"
};

MLP<
    T,
    TP,
    C,
    CAP,
    RESI_CP,
    CH,
    CHAP,

    __mlp_if_t,
    __mlp_ln_t,
    __mlp_m1_t,
    __mlp_ge_t,
    __mlp_m2_t,
    __mlp_of_t,

    __ln_sum_t,
    __ln_divc_t,
    __ln_mu_t,
    __ln_var_t,
    __ln_cursor_t,
    __ln_rsqrt_t,
    __ln_affine_t,
    __ln_shift_t,
    LN_ENTRIES_RSQRT,

    __m1_we_t,
    __m1_bi_t,
    __m1_mc_t,
    M1_CIP,
    M1_COP,
    M1_ADPT_FIFO_DEPTH,
    M1_WIND_FIFO_DEPTH,
    M1_WGHT_FIFO_DEPTH,
    M1_MACS_FIFO_DEPTH,
    M1_USE_DSP,

    __gelu_cursor_t,
    GELU_ENTRIES,

    __m2_we_t,
    __m2_bi_t,
    __m2_mc_t,
    M2_CIP,
    M2_COP,
    M2_ADPT_FIFO_DEPTH,
    M2_WIND_FIFO_DEPTH,
    M2_WGHT_FIFO_DEPTH,
    M2_MACS_FIFO_DEPTH,
    M2_USE_DSP
> mlp_inst(
    mlp_scalars_init,
    mlp_lnq_scalars_init,   mlp_lnq_lnw_m_init,     mlp_lnq_lnb_m_init,     mlp_lnq_rsqrt_table_init,
    mlp_m1_weight_init,     mlp_m1_bias_init,
    mlp_gelu_scalars_init,  mlp_gelu_table_init,
    mlp_m2_weight_init,     mlp_m2_bias_init
);

int y_dut[T][C];

void top(hls::stream<hls::vector<__mlp_if_t, TP*CAP> >& i_stream, hls::stream<hls::vector<__mlp_of_t, TP*CAP> >& o_stream){
    #pragma HLS dataflow
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    mlp_inst.do_mlp(i_stream, o_stream);
    // mlp_inst.do_mlp(i_stream, o_stream, main_ref, lnq_ref, m1_ref, gelu_ref, m2_ref);
}

int main(){

    // stream declaration
    hls::stream<hls::vector<__mlp_if_t, TP*CAP> > i_stream("i_stream");
    hls::stream<hls::vector<__mlp_of_t, TP*CAP> > o_stream("o_stream");

    const int TEST_ROUND = 6; // how many rounds. data are replicated

    // write stream
    for(int test_round=0; test_round<TEST_ROUND; test_round++){
        for(int tt=0; tt<TT; tt++){
            for(int cat=0; cat<CAT; cat++){

                hls::vector<__mlp_if_t,TP*CAP> vec_i;

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

                hls::vector<__mlp_of_t,TP*CAP> vec_o = o_stream.read();

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





