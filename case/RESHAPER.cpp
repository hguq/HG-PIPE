#include "../src/common.h"
#include "../src/reshaper.h"

// data type
typedef ap_int  <   3   >   __if_t;                 

// hyperparameters
const int H         = 3;
const int T         = 196;
const int C         = 64;
const int TIP       = 2;
const int TOP       = 7;
const int CIP       = 4;
const int COP       = 2;

const int TIT       = T / TIP;
const int TOT       = T / TOP;
const int CIT       = C / CIP;
const int COT       = C / COP;

const int UNPK_FIFO_DEPTH = 2;

// test refs
const int x_ref[H][T][C] = {
    #include "./refs/attn_0_gen_r_matmul_weight.txt"
};
const int y_ref[H][T][C] = {
    #include "./refs/attn_0_gen_r_matmul_weight.txt"
};

Reshaper<
    __if_t,
    T,
    TIP,
    TOP,
    C,
    CIP,
    COP
> reshaper_inst;

int y_dut[H][T][C];

void top(hls::stream<hls::vector<__if_t, TIP*CIP> > &i_stream, hls::stream<hls::vector<__if_t, TOP*COP> > &o_stream){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    reshaper_inst.do_reshape(i_stream, o_stream, false);
}

int main(){

    // stream declaration
    hls::stream<hls::vector<__if_t, TIP*CIP> > i_stream("i_stream");
    hls::stream<hls::vector<__if_t, TOP*COP> > o_stream("o_stream");

    // write stream
    for(int h=0; h<H; ++h){
        for(int tit=0; tit<TIT; ++tit){
            for(int cit=0; cit<CIT; ++cit){

                hls::vector<__if_t, TIP*CIP> vec_i;

                for(int tip=0; tip<TIP; ++tip){
                    for(int cip=0; cip<CIP; ++cip){
                        vec_i[tip*CIP + cip] = x_ref[h][tit*TIP + tip][cit*CIP + cip];
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
        for(int tot=0; tot<TOT; ++tot){
            for(int cot=0; cot<COT; ++cot){

                hls::vector<__if_t, TOP*COP> vec_o = o_stream.read();

                for(int top=0; top<TOP; ++top){
                    for(int cop=0; cop<COP; ++cop){
                        y_dut[h][tot*TOP + top][cot*COP + cop] = vec_o[top*COP + cop];
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
