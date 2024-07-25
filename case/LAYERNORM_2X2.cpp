#include "../src/common.h"
#include "../src/layernorm.h"
#include "math.h"

// define the data type
typedef ap_int  <   13  >   __if_t;
typedef ap_int  <   17  >   __sum_t;
typedef ap_int  <   32  >   __divc_t;
typedef ap_int  <   9   >   __mu_t;
typedef ap_uint <   27  >   __var_t;
typedef ap_uint <   7   >   __cursor_t;
typedef ap_uint <   12  >   __rsqrt_t;
typedef ap_int  <   38  >   __affine_t;
typedef ap_int  <   5   >   __shift_t;
typedef ap_int  <   3   >   __of_t;

// shape hyperparameters
// table entries
const int ENTRIES_RSQRT         = 128;
// layer shape
const int T                     = 196;
const int TP                    = 2;
const int C                     = 192;
const int CP                    = 2;

const int TT                    = T / TP;
const int CT                    = C / CP;

// weights
const int scalars[] = {
    #include "./refs/attn_1_lnq_scalars.txt"
};
const int rsqrt_table[] = {
    #include "./refs/attn_1_lnq_rsqrt_table_m.txt"
};
const long long lnb_m[] = {
    #include "./refs/attn_1_lnq_lnb_m.txt"
};
const int lnw_m[] = {
    #include "./refs/attn_1_lnq_lnw_m.txt"
};

// test refs
const int x_ref[T][C] = {
    #include "./refs/attn_1_lnq_input.txt"
};
const int y_ref[T][C] = {
    #include "./refs/attn_1_lnq_output.txt"
};

// test parameters
const int TEST_ROUND = 1;

// instantiate the class globally
Layernorm<
    __if_t,
    __sum_t,
    __divc_t,
    __mu_t,
    __var_t,
    __cursor_t,
    __rsqrt_t,
    __affine_t,
    __shift_t,
    __of_t,
    ENTRIES_RSQRT,
    T,                          
    TP,                         
    C,                          
    CP
>LayerNorm(
    scalars,
    lnw_m,
    lnb_m,
    rsqrt_table
);

int y_dut[TEST_ROUND][T][C];

void top(hls::stream<hls::vector<__if_t, CP*TP> >& i_stream, hls::stream<hls::vector<__of_t, CP*TP> >& o_stream){
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    LayerNorm.do_layernorm(i_stream,o_stream);
}


int main(){

    // stream declaration
    hls::stream<hls::vector<__if_t, CP*TP> > i_stream("i_stream");
    hls::stream<hls::vector<__of_t, CP*TP> > o_stream("o_stream");

    for(int i=0; i<TEST_ROUND; i++){
        for(int tt=0; tt<TT; tt++){
            for(int ct=0; ct<CT; ct++){

                hls::vector<__if_t,CP*TP> vec_i;

                for(int tp=0; tp<TP; tp++){
                    for(int cp=0; cp<CP; cp++){
                        vec_i[tp*CP + cp] = x_ref[tt*TP + tp][ct*CP + cp];
                    }
                }

                i_stream.write(vec_i);

            }
        }
    }

    // call the top function
    top(i_stream, o_stream);

    // read stream
    for(int i=0; i<TEST_ROUND; i++){
        for(int tt=0; tt<TT; tt++){
            for(int ct=0; ct<CT; ct++){

                hls::vector<__of_t,CP*TP> vec_o = o_stream.read();

                for(int tp=0; tp<TP; tp++){
                    for(int cp=0; cp<CP; cp++){
                        y_dut[i][tt*TP + tp][ct*CP + cp] = vec_o[tp*CP + cp];
                    }
                }

            }
        }
    }

    // compare
    bool flag = 1;
    for(int i=0; i<TEST_ROUND; i++){
        for(int t=0; t<T; t++){
            for(int c=0; c<C; c++){
                if(y_dut[i][t][c] != y_ref[t][c]) {
                    flag = 1;
                    printf("test %d mismatch : y_dut[%d][%d] is %d,y_ref[%d][%d] is %d\n",i,t,c,y_dut[i][t][c],t,c,y_ref[t][c]);
                }
                else if(y_dut[i][t][c] == y_ref[t][c]){
                    //printf("test %d match : y_dut[%d][%d]  %d == y_ref[%d][%d]  %d\n",i,t,c,y_dut[i][t][c],t,c,y_ref[i][t][c]);
                }
            }
        }
    }

    if(flag){
        printf("PASS!\n");
        return 0;
    } else {
        printf("FAIL!\n");
        return -1;
    }

}