#ifndef __INT_HEAD_SPLIT_H__
#define __INT_HEAD_SPLIT_H__

#include "common.h"

using namespace std;

template<
    class __data_t,     // input feature map type
    int H,              // number of heads
    int T,              // input feature map height
    int TP,             // input feature map height parallel degree
    int C,              // input feature map channel
    int CP
> class HeadSplit{
public:
    static_assert(T % TP == 0, "T must be multiple of TP");
    static_assert(C % CP == 0, "C must be multiple of CP");

    static constexpr int TT  = T  / TP;
    static constexpr int CT  = C  / CP;

    static constexpr int CH  = C  / H;
    static constexpr int CHT = CH / CP;

    HeadSplit() = default;

    void do_split(
        hls::stream<hls::vector<__data_t, TP*CP> > &i_stream, 
        hls::stream<hls::vector<__data_t, TP*CP> > &o_stream1,
        hls::stream<hls::vector<__data_t, TP*CP> > &o_stream2,
        hls::stream<hls::vector<__data_t, TP*CP> > &o_stream3
    ){

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            H_LOOP: for(int h=0; h<H; ++h){
                CHT_LOOP: for(int cht=0; cht<CHT; ++cht){
                    #pragma HLS pipeline II=1

                    hls::vector<__data_t, TP*CP> vec_i = i_stream.read();

                    if(h == 0){
                        o_stream1.write(vec_i);
                    }else if(h == 1){
                        o_stream2.write(vec_i);
                    }else if(h == 2){
                        o_stream3.write(vec_i);
                    }
                
                }
            }
        }
    }

    void do_merge(
        hls::stream<hls::vector<__data_t, TP*CP> > &i_stream1,
        hls::stream<hls::vector<__data_t, TP*CP> > &i_stream2,
        hls::stream<hls::vector<__data_t, TP*CP> > &i_stream3,
        hls::stream<hls::vector<__data_t, TP*CP> > &o_stream
    ){

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            H_LOOP: for(int h=0; h<H; ++h){
                CHT_LOOP: for(int cht=0; cht<CHT; ++cht){
                    #pragma HLS pipeline II=1

                    hls::vector<__data_t, TP*CP> vec_o;

                    if(h == 0){
                        vec_o = i_stream1.read();
                    }else if(h == 1){
                        vec_o = i_stream2.read();
                    }else if(h == 2){
                        vec_o = i_stream3.read();
                    }

                    o_stream.write(vec_o);
                
                }
            }
        }
    }

};

#endif