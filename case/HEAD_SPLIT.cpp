#include "../src/common.h"
#include "../src/head_split.h"

// data type
typedef ap_int  <   3   >   __if_t;                 

// hyperparameters
const int H         = 3;
const int T         = 196;
const int TP        = 2;
const int C         = 192;
const int CP        = 4;

const int CH        = C  / H;

const int TT        = T  / TP;
const int CT        = C  / CP;
const int CHT       = CH / CP;

// test refs
const int x_ref[T][C] = {
    #include "./refs/attn_0_kq_output.txt"
};
const int y_ref[H][CH][T] = {
    #include "./refs/attn_0_gen_r_matmul_weight.txt"
};

HeadSplit<
    __if_t,
    H,
    T,
    TP,
    C,
    CP
> head_split_ints;

int y_dut[H][T][CH];

void top(
    hls::stream<hls::vector<__if_t, TP*CP> > &i_stream,
    hls::stream<hls::vector<__if_t, TP*CP> > &o_stream1,
    hls::stream<hls::vector<__if_t, TP*CP> > &o_stream2,
    hls::stream<hls::vector<__if_t, TP*CP> > &o_stream3
){
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream1
    #pragma HLS interface axis          port=o_stream2
    #pragma HLS interface axis          port=o_stream3

    head_split_ints.do_split(
        i_stream,
        o_stream1,
        o_stream2,
        o_stream3
    );
}

int main(){

    // stream declaration
    hls::stream<hls::vector<__if_t, TP*CP> > i_stream("i_stream");
    hls::stream<hls::vector<__if_t, TP*CP> > o_stream1("o_stream1");
    hls::stream<hls::vector<__if_t, TP*CP> > o_stream2("o_stream2");
    hls::stream<hls::vector<__if_t, TP*CP> > o_stream3("o_stream3");

    // write stream
    for(int tt=0; tt<TT; ++tt){
        for(int ct=0; ct<CT; ++ct){

            hls::vector<__if_t, TP*CP> vec_i;

            for(int tp=0; tp<TP; ++tp){
                for(int cp=0; cp<CP; ++cp){
                    vec_i[tp*CP + cp] = x_ref[tt*TP + tp][ct*CP + cp];
                }
            }

            i_stream.write(vec_i);

        }
    }

    // call top
    top(
        i_stream,
        o_stream1,
        o_stream2,
        o_stream3
    );

    // read stream
    for(int h=0; h<H; ++h){
        for(int tt=0; tt<TT; ++tt){
            for(int cht=0; cht<CHT; ++cht){

                hls::vector<__if_t, TP*CP> vec_o;

                if(h == 0){
                    vec_o = o_stream1.read();
                }else if(h == 1){
                    vec_o = o_stream2.read();
                }else if(h == 2){
                    vec_o = o_stream3.read();
                }

                for(int tp=0; tp<TP; ++tp){
                    for(int cp=0; cp<CP; ++cp){
                        y_dut[h][tt*TP + tp][cht*CP + cp] = vec_o[tp*CP + cp];
                    }
                }

            }
        }
    }


    // compare
    bool flag = true;
    for(int h=0; h<H; ++h){
        for(int t=0; t<T; ++t){
            for(int ch=0; ch<CH; ++ch){

                if(y_dut[h][t][ch] != y_ref[h][ch][t]){
                    printf("y_dut[%d][%d][%d] = %d, y_ref[%d][%d][%d] = %d\n", h, t, ch, y_dut[h][t][ch], h, ch, t, y_ref[h][ch][t]);
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
