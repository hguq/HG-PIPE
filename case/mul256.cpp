#include "../src/common.h"

// attn global shapes
const int IW = 256;
const int OW = IW + IW;

typedef ap_int  <IW> i_t;
typedef ap_int  <OW> o_t;

void top(int N, hls::stream<i_t>& i_stream1, hls::stream<i_t>& i_stream2, hls::stream<o_t>& o_stream){
    #pragma HLS dataflow
    #pragma HLS interface ap_ctrl_chain port=return
    #pragma HLS interface axis          port=i_stream1
    #pragma HLS interface axis          port=i_stream2
    #pragma HLS interface axis          port=o_stream

    for(int n=0; n<N; ++n){
        #pragma HLS pipeline II=1

        i_t i1 = i_stream1.read();
        i_t i2 = i_stream2.read();

        o_t o = i1 * i2;
        #pragma HLS bind_op variable=o op=mul impl=dsp latency=6
        o_stream.write(o);
    }

}

int main(){

    i_t i1 = 0x01234;
    i_t i2 = 0x01234;
    o_t o  = 0x01234 * 0x01234;

    hls::stream<i_t> i_stream1;
    hls::stream<i_t> i_stream2;
    hls::stream<o_t> o_stream;

    i_stream1.write(i1);
    i_stream2.write(i2);

    top(1, i_stream1, i_stream2, o_stream);

    o_t o_out = o_stream.read();

    if (o_out != o){
        std::cout << "ERROR: " << o_out << " != " << o << std::endl;
        return 1;
    }

    return 0;

}

