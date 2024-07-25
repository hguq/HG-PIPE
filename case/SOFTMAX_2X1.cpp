#include "../src/common.h"
#include "../src/softmax.h"
#include "math.h"


// data type
typedef ap_int  <   10  >   __if_t;                 // input feature map data type
typedef ap_int  <   11  >   __minus_t;              // second pass, x-xmax type
typedef ap_uint <   6   >   __cursor1_t;            // lookup table 1 cursor type, after shift
typedef ap_uint <   16  >   __exp_t;                // lookup table 1 exp type
typedef ap_uint <   23  >   __acc_t;                // sum(exp x- xmax)
typedef ap_uint <   8   >   __recip_t;
typedef ap_uint <   9   >   __cursor2_one_t;        // table 1
typedef ap_int  <   6   >   __cursor2_two_t;        // table 2
typedef ap_uint <   23  >   __affine_t;             // affine
typedef ap_uint <   7   >   __cursor3_t;            // max{cursor3_one, cursor3_two}
typedef ap_uint <   3   >   __of_t;


// hyperparameters
// table entries
const int ENTRIES_EXP       = 32;                   // number of entries for exp table
const int ENTRIES_RECIP     = 64;                   // number of entries for recip table
// layer shape
const int T                 = 196;
const int TP                = 2;
const int CP                = 1;

const int TT                = T / TP;
const int CT                = T / CP;

// weights
const int scalars[] = {
    #include "./refs/attn_0_softmaxq_scalars.txt"
};
const int exp_table[] = {
    #include "./refs/attn_0_softmaxq_exp_opp_table_m.txt"
};
const int recip_table_one[] = {
    #include "./refs/attn_0_softmaxq_recip_scaled_table_m_one.txt"
};
const int recip_table_two[] = {
    #include "./refs/attn_0_softmaxq_recip_scaled_table_m_two.txt"
};

// test refs
const int H = 3;
const int in_ref[H][T][T] = {
    #include "./refs/attn_0_softmaxq_input.txt"
};
const int y_ref[H][T][T] = {
    #include "./refs/attn_0_softmaxq_output.txt"
};

// test parameters
const int   TEST_ROUND = 1;

Softmax<
    __if_t,
    __minus_t,
    __cursor1_t,
    __exp_t,
    __acc_t,
    __recip_t,
    __cursor2_one_t,
    __cursor2_two_t,
    __affine_t,
    __cursor3_t,
    __of_t,
    ENTRIES_EXP,
    ENTRIES_RECIP,
    T,
    TP,
    T,//C
    CP
> softmax_inst(
    scalars,
    exp_table,
    recip_table_one,
    recip_table_two
);


int y_dut[H][T][T];

void top(hls::stream<hls::vector<__if_t, TP*CP> >& i_stream, hls::stream<hls::vector<__of_t, TP*CP> >& o_stream){
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream

    softmax_inst.do_softmax(i_stream,o_stream);
}


int main(){

    // stream declaration
    hls::stream<hls::vector<__if_t, TP*CP> > i_stream("i_stream");
    hls::stream<hls::vector<__of_t, TP*CP> > o_stream("o_stream");

    bool flag = 1;
    for(int h=0; h<H; h++){

        // write stream
        for(int tt=0; tt<TT; tt++){
            for(int ct=0; ct<CT; ct++){ 

                hls::vector<__if_t,TP*CP> vec_i;

                for(int tp=0; tp<TP; tp++){
                    for(int cp=0; cp<CP; cp++){
                        vec_i[tp*CP + cp] = in_ref[h][tt*TP + tp][ct*CP + cp];
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
                        y_dut[h][tt*TP + tp][ct*CP + cp] = vec_o[tp*CP + cp];
                    }
                }

            }
        }
 
        // compare
        for(int ct=0; ct<T; ct++){
            for(int tt=0; tt<T; tt++){

                if(y_dut[h][tt][ct] != y_ref[h][tt][ct]) {
                    flag = 0;
                    printf("test mismatch : y_dut[%d][%d][%d] is %d,y_ref[%d][%d][%d] is %d\n",h,tt,ct,y_dut[h][tt][ct],h,tt,ct,y_ref[h][tt][ct]);
                }
                else {
                    // printf("test %d match : y_dut[%d][%d]  %d == y_ref[%d][%d]  %d\n",i,t,c,y_dut[i][t][c],t,c,y_ref[i][t][c]);
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