#include "../src/common.h" 
#include "../src/head.h" 

const int   T           = 196;       // the trips of output channel loop
const int   TP          = 2;         // the trips of output channel loop
const int   CI          = 192;           // input channels
const int   CIAP        = 1;             // adapter parallelism for input channel
const int   CO          = 1000;
const int   COAP        = 1;

typedef     ap_int<13>  __if_t;
typedef     ap_int<8>   __ln_t;
typedef     ap_int<8>   __we_t;
typedef     ap_int<19>  __bi_t;
typedef     ap_int<19>  __mc_t;

typedef     ap_uint<15> __ln_sum_t;
typedef     ap_uint<30> __ln_divc_t;
typedef     ap_uint<7>  __ln_mu_t;
typedef     ap_uint<24> __ln_var_t;
typedef     ap_uint<6>  __ln_cursor_t;
typedef     ap_uint<11> __ln_rsqrt_t;
typedef     ap_int<36>  __ln_affine_t;
typedef     ap_int<9>   __ln_shift_t;

const int   CIP                 = 1;             // input channel parallelism
const int   COP                 = 4;
const int   ADPT_FIFO_DEPTH     = 2;
const int   WIND_FIFO_DEPTH     = 2;
const int   WGHT_FIFO_DEPTH     = 2;
const int   MACS_FIFO_DEPTH     = 2;
const bool  USE_DSP             = false;

const int LN_ENTRIES_RSQRT      = 128;

const int   CIAT               = CI / CIAP;     // the trips of input channel loop
const int   COAT               = CO / COAP;     // the trips of output channel loop

static constexpr int TT     = T  / TP;
static constexpr int CIT    = CI / CIP;
static constexpr int COT    = CO / COP;

const int ln_scalars_init [] = {
    #include "./refs/head_lnq_scalars.txt"
};

const int ln_lnw_init [CI] = {
    #include "./refs/head_lnq_lnw_m.txt"
};

const int64_t ln_lnb_init [CI] = {
    #include "./refs/head_lnq_lnb_m.txt"
};

const int ln_rsqrt_table_init [LN_ENTRIES_RSQRT] = {
    #include "./refs/head_lnq_rsqrt_table_m.txt"
};

const int weight_init [CO][CI] = {
    #include "./refs/head_matmul_weight.txt"
};

const int bias_init [CO] = {
    #include "./refs/head_matmul_bias.txt"
};


Head<
    T,
    TP,
    CI,
    CIAP,
    CO,
    COAP,

    __if_t,
    __ln_t,
    __we_t,
    __bi_t,
    __mc_t,

    __ln_sum_t,
    __ln_divc_t,
    __ln_mu_t,
    __ln_var_t,
    __ln_cursor_t,
    __ln_rsqrt_t,
    __ln_affine_t,
    __ln_shift_t,
    LN_ENTRIES_RSQRT,

    CIP,
    COP,
    ADPT_FIFO_DEPTH,
    WIND_FIFO_DEPTH,
    WGHT_FIFO_DEPTH,
    MACS_FIFO_DEPTH,
    USE_DSP
> HEAD_INST(
    ln_scalars_init,
    ln_lnw_init,
    ln_lnb_init,
    ln_rsqrt_table_init,
    weight_init,
    bias_init
);


void top(hls::stream<hls::vector<__if_t, TP*CIAP> > &i_stream, hls::stream<hls::vector<__mc_t, COAP> > &o_stream){
    #pragma HLS dataflow
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream
    
    HEAD_INST.do_head(i_stream, o_stream);
}

#ifndef __SYNTHESIS__

const int x_ref [T][CI] = {
    #include "./refs/head_input.txt"
};

const int y_ref [CO] = {
    #include "./refs/head_output.txt"
};

const int TEST_ROUNDS = 6;

int y_dut[TEST_ROUNDS][CO];

int main(){
    hls::stream<hls::vector<__if_t, TP*CIAP> > i_stream("i_stream");
    hls::stream<hls::vector<__mc_t,    COAP> > o_stream("o_stream");
    

    // prepare input
    for(int n=0; n<TEST_ROUNDS; ++n){
        for(int tt=0; tt<TT; ++tt){
            for(int ciat=0; ciat<CIAT; ++ciat){
                hls::vector<__if_t, TP*CIAP> vec_i;
                for(int tp=0; tp<TP; ++tp){
                    for(int ciap=0; ciap<CIAP; ++ciap){
                        vec_i[tp*CIAP + ciap] = x_ref[tt*TP + tp][ciat*CIAP + ciap];
                    }
                }
                i_stream.write(vec_i);
            }
        }
    }

    // do head
    for(int n=0; n<TEST_ROUNDS; ++n){
        top(i_stream, o_stream);
    }

    // read out
    for(int n=0; n<TEST_ROUNDS; ++n){
        for(int coat=0; coat<COAT; ++coat){
            hls::vector<__mc_t, COAP> vec_o = o_stream.read();
            for(int coap=0; coap<COAP; ++coap){
                y_dut[n][coat*COAP + coap] = vec_o[coap];
            }
        }
    }

    // compare
    bool flag=true;
    for(int n=0; n<TEST_ROUNDS; ++n){
        for(int co=0; co<CO; ++co){
            if(y_dut[n][co] != y_ref[co]){
                flag = false;
                printf("y_dut[%d]: %d, y_ref[%d]: %d\n", co, y_dut[co], co, y_ref[co]);
            }
        }
    }

    if(flag){
        printf("PASS\n");
    } else {
        printf("FAIL\n");
    }

}

#endif





