#include "../src/common.h" 
#include "../src/patch_embed.h" 


typedef     ap_int<8>                   __if_t;
typedef     ap_int<8>                   __we_t;
typedef     ap_int<21>                  __bi_t;
typedef     ap_int<21>                  __ml_t;
typedef     ap_int<13>                  __of_t;


const int   T                  = 196;     // the trips of output channel loop
const int   TP                 = 2;     // the trips of output channel loop
const int   CI                 = 768;           // input channels
const int   CIP                = 16;             // input channel parallelism
const int   CIAP               = 2;             // adapter parallelism for input channel
const int   CO                 = 192;
const int   COP                = 16;
const int   COAP               = 1;
const bool  USE_DSP            = true;

const int   TT                 = T / TP;
const int   CIAT               = CI / CIAP;
const int   COAT               = CO / COAP;

const int scalars_init [] = {
    #include "./refs/patch_embed_scalars.txt"
};

const int weight_init [CO][CI] = {
    #include "./refs/patch_embed_matmul_weight.txt"
};

const int bias_init   [T][CO] = {
    #include "./refs/patch_embed_matmul_bias.txt"
};

const int cls_init [CO] = {
    #include "./refs/patch_embed_cls.txt"
};


PatchEmbed<
    __if_t, 
    __we_t, 
    __bi_t, 
    __ml_t, 
    __of_t, 
    T, 
    TP, 
    CI, 
    CIP, 
    CIAP, 
    CO, 
    COP, 
    COAP, 
    USE_DSP
> PATCH_EMBED_INST(
    scalars_init,
    weight_init,
    bias_init,
    cls_init
);

void top(hls::stream<hls::vector<__if_t, TP*CIAP> > &i_stream, hls::stream<hls::vector<__of_t, TP*COAP> > &o_stream){
    #pragma HLS dataflow
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream
    #pragma HLS interface axis          port=o_stream
    
    PATCH_EMBED_INST.do_patch_embed(i_stream, o_stream);
}

#ifndef __SYNTHESIS__

const int x_ref [T][CI] = {
    #include "./refs/patch_embed_input.txt"
};

const int y_ref [T][CO] = {
    #include "./refs/patch_embed_output.txt"
};

int y_dut[T][CO];

int main(){

    const int TEST_ROUNDS = 6;

    hls::stream<hls::vector<__if_t, TP*CIAP> > i_stream;
    hls::stream<hls::vector<__of_t, TP*COAP> > o_stream;

    // not enough data, repeat it
    for(int n=0; n<TEST_ROUNDS; ++n){
        for(int tt=0; tt<TT; ++tt){
            for(int ciat=0; ciat<CIAT; ++ciat){
                hls::vector<__if_t, TP*CIAP> vec_i;
                for(int tp=0; tp<TP; ++tp){
                    for(int ciap=0; ciap<CIAP; ++ciap){
                        if(tt == 0 && tp == 0){
                            // first token
                            vec_i[tp*CIAP + ciap] = 0; // random init to 0

                        } else {
                            // on token dimension, has a 1 offset
                            vec_i[tp*CIAP + ciap] = x_ref[tt*TP + tp][ciat*CIAP + ciap];
                        }
                    }
                }
                i_stream.write(vec_i);
            }
        }
    }

    // call top
    for(int n=0; n<TEST_ROUNDS; ++n){
        top(i_stream, o_stream);
    }

    bool flag=true;

    // read output
    for(int n=0; n<TEST_ROUNDS; ++n){
        for(int tt=0; tt<TT; ++tt){
            for(int coat=0; coat<COAT; ++coat){
                hls::vector<__of_t, TP*COAP> vec_o = o_stream.read();
                for(int tp=0; tp<TP; ++tp){
                    for(int coap=0; coap<COAP; ++coap){
                        y_dut[tt*TP + tp][coat*COAP + coap] = vec_o[tp*COAP + coap];
                    }
                }
            }
        }
    }

    // compare
    for(int tt=0; tt<TT; ++tt){
        for(int co=0; co<CO; ++co){
            if(y_dut[tt][co] != y_ref[tt][co]){
                flag = false;
                printf("y_dut[%d][%d] = %d, y_ref[%d][%d] = %d\n", tt, co, y_dut[tt][co], tt, co, y_ref[tt][co]);
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