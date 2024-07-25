#include "../src/common.h"
#include "../src/adapter.h"

// data type
typedef ap_int  <   3   >   __if_t;                 

// hyperparameters
const int H         = 3;
const int T         = 196;
const int C         = 64;
const int TP        = 2;
const int CIP       = 4;
const int COP       = 2;

const int TT        = T  / TP;
const int CIT       = C / CIP;
const int COT       = C / COP;

// test refs
const int x_ref[H][T][C] = {
    #include "./refs/attn_0_gen_r_matmul_weight.txt"
};
const int y_ref[H][T][C] = {
    #include "./refs/attn_0_gen_r_matmul_weight.txt"
};

Adapter<
    __if_t,
    T,
    TP,
    C,
    CIP,
    COP
> adapter_inst;

int y_dut[H][T][C];

void top(hls::stream<hls::vector<__if_t, TP*CIP> > &i_stream, hls::stream<hls::vector<__if_t, TP*COP> > &o_stream){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    adapter_inst.do_adapt(i_stream, o_stream);
}

int main(){

    // stream declaration
    hls::stream<hls::vector<__if_t, TP*CIP> > i_stream("i_stream");
    hls::stream<hls::vector<__if_t, TP*COP> > o_stream("o_stream");

    // write stream
    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            for(int cit=0; cit<CIT; ++cit){

                hls::vector<__if_t, TP*CIP> vec_i;

                for(int tp=0; tp<TP; ++tp){
                    for(int cip=0; cip<CIP; ++cip){
                        vec_i[tp*CIP + cip] = x_ref[h][tt*TP + tp][cit*CIP + cip];
                    }
                }

                i_stream.write(vec_i);

            }
        }
    }

    // call top
    for(int h=0; h<H; ++h){
        top(i_stream, o_stream);
    }

    // read stream
    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            for(int cot=0; cot<COT; ++cot){

                hls::vector<__if_t, TP*COP> vec_o = o_stream.read();

                for(int top=0; top<TP; ++top){
                    for(int cop=0; cop<COP; ++cop){
                        y_dut[h][tt*TP + top][cot*COP + cop] = vec_o[top*COP + cop];
                    }
                }

            }
        }
    }

    // compare
    bool flag = true;
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int c=0; c<C; ++c){
                if(y_ref[h][t][c] != y_dut[h][t][c]){
                    printf("Wrong!");
                    flag = false;
                }
            }
        }
    }

    if(flag){
        printf("PASS!\n");
    } else {
        printf("FAIL!\n");
    }

}
