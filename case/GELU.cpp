#include "../src/common.h"
#include "../src/gelu.h"

// data type
typedef ap_int  <   12  >   __if_t;                 
typedef ap_int  <   9   >   __cursor_t; // it is shift result type
typedef ap_uint <   3   >   __of_t;

// hyperparameters
// table entries
const int T         = 196;
const int TP        = 1;
const int C         = 768;
const int CP        = 2;

const int ENTRIES   = 64;

const int CT        = C / CP;
const int TT        = T / TP;


// weights
const int scalars[] = {
    #include "./refs/mlp_1_geluq_scalars.txt"
};
const int table[] = {
    #include "./refs/mlp_1_geluq_table_m.txt"
};

// test refs
const int x_ref[T][C] = {
    #include "./refs/mlp_1_geluq_input.txt"
};
const int y_ref[T][C] = {
    #include "./refs/mlp_1_geluq_output.txt"
};


GeLU<
    __if_t,
    __cursor_t,
    __of_t,
    T,
    TP,
    C,
    CP,
    ENTRIES
> gelu_inst(
    scalars, 
    table
);

int y_dut[T][C];

void top(hls::stream<hls::vector<__if_t, TP*CP> >& i_stream, hls::stream<hls::vector<__of_t, TP*CP> >& o_stream){
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    gelu_inst.do_gelu(i_stream, o_stream);
}

int main(){

    hls::stream<hls::vector<__if_t, TP*CP> > i_stream;
    hls::stream<hls::vector<__of_t, TP*CP> > o_stream;

    // write stream
    for(int tt=0; tt<TT; tt++){
        for(int ct=0; ct<CT; ct++){ 

            hls::vector<__if_t,TP*CP> vec_i;

            for(int tp=0; tp<TP; tp++){
                for(int cp=0; cp<CP; cp++){
                    vec_i[tp*CP + cp] = x_ref[tt*TP + tp][ct*CP + cp];
                }
            }

            i_stream.write(vec_i);

        }
    }

    // call top
    top(i_stream, o_stream);

    // read stream
    for(int tt=0; tt<TT; tt++){
        for(int ct=0; ct<CT; ct++){

            hls::vector<__of_t,CP*TP> vec_o = o_stream.read();

            for(int tp=0; tp<TP; tp++){
                for(int cp=0; cp<CP; cp++){
                    y_dut[tt*TP + tp][ct*CP + cp] = vec_o[tp*CP + cp];
                }
            }

        }
    }

    // compare
    bool flag = true;
    for(int t=0; t<T; t++){
        for(int c=0; c<C; c++){
            if(y_dut[t][c] != y_ref[t][c]){
                flag = false;
                printf("At t: %d, c: %d, y_dut: %d, y_ref: %d\n", t, c, y_dut[t][c], y_ref[t][c]);
            }
        }
    }

    if(flag) printf("PASS!\n");
    else     printf("FAIL!\n");

}
