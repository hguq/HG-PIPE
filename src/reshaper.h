#ifndef __INT_RESHAPER_H__
#define __INT_RESHAPER_H__

#include "common.h"

using namespace std;


template<
    class __data_t,     // input feature map type
    int T,              // input feature map height
    int TIP,            // input feature map height parallel degree
    int TOP,            // output feature map height parallel degree
    int C,              // input feature map channel
    int CIP,            // input feature map channel parallel degree
    int COP            // output feature map channel parallel degree
> class Reshaper{
public:
    static_assert(T % TIP == 0, "T must be multiple of TIP");
    static_assert(T % TOP == 0, "T must be multiple of TOP");
    static_assert(C % CIP == 0, "C must be multiple of CIP");
    static_assert(C % COP == 0, "C must be multiple of COP");

    static constexpr int TIT = T / TIP;
    static constexpr int TOT = T / TOP;
    static constexpr int CIT = C / CIP;
    static constexpr int COT = C / COP;

    Reshaper() = default;

    static constexpr int TP = (TIP * TOP) / GCD(TIP, TOP); // LCM
    static constexpr int TT = T / TP;

    static constexpr int TP_TIP = TP / TIP;
    static constexpr int TP_TOP = TP / TOP;


    void unpack(hls::stream<hls::vector<__data_t, TIP*CIP>  > &i_stream,  hls::stream<__data_t> &o_stream){

        hls::vector<__data_t, TIP*CIP> vec_i;

        TIT_LOOP: for(int tit=0; tit<TIT; ++tit){
            CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                TIP_LOOP: for(int tip=0; tip<TIP; ++tip){
                    CIP_LOOP: for(int cip=0; cip<CIP; ++cip){
                        #pragma HLS pipeline II=1
                        
                        if(tip==0 && cip==0){
                            vec_i = i_stream.read();
                        }

                        o_stream.write(vec_i[tip*CIP + cip]);

                    }
                }
            }
        }
    }

    void reorder(hls::stream<__data_t> &i_stream, hls::stream<hls::vector<__data_t, TOP*COP> > &o_stream, bool TRANSPOSED){
        // declare a small buffer, which later will be implemented with LUTRAM
        // the buffer is not reshaped, it is a element-wise buffer
        __data_t buffer[TP][C];
        #pragma HLS bind_storage variable=buffer type=ram_2p impl=lutram


        hls::vector<__data_t, TOP*COP> vec_o;

        for(int tt=0; tt<TT; ++tt){
            // the two loops are executed sequentially, cannot be pipelined.
            // first part, read in
            for(int tp_tip=0; tp_tip<TP_TIP; ++tp_tip){
                for(int cit=0; cit<CIT; ++cit){
                    for(int tip=0; tip<TIP; ++tip){
                        for(int cip=0; cip<CIP; ++cip){
                            #pragma HLS pipeline II=1

                            buffer[tp_tip*TIP + tip][cit*CIP + cip] = i_stream.read();

                        }
                    }
                }
            }
            // second part, write out
            for(int tp_top=0; tp_top<TP_TOP; ++tp_top){
                for(int cot=0; cot<COT; ++cot){
                    for(int top=0; top<TOP; ++top){
                        for(int cop=0; cop<COP; ++cop){
                            #pragma HLS pipeline II=1

                            if(!TRANSPOSED){
                                // normal order
                                vec_o[top*COP + cop] = buffer[tp_top*TOP + top][cot*COP + cop];
                            } else {
                                // transpose order
                                vec_o[cop*TOP + top] = buffer[tp_top*TOP + top][cot*COP + cop];
                            }
                            
                            if(top == TOP-1 && cop == COP-1){
                                o_stream.write(vec_o);
                            }

                        }
                    }
                }
            }

        } // end of TT_LOOP

    }

    void do_reshape(hls::stream<hls::vector<__data_t, TIP*CIP>  > &i_stream,hls::stream<hls::vector<__data_t, TOP*COP>  > &o_stream, bool TRANSPOSE){
        #pragma HLS dataflow

        hls::stream<__data_t> unpacked_stream ("unpacked_stream");

        unpack  (i_stream,          unpacked_stream             );
        reorder (unpacked_stream,   o_stream        ,TRANSPOSE  );
    }

};

#endif