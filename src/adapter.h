#ifndef __INT_ADAPTER_H__
#define __INT_ADAPTER_H__

#include "common.h"

using namespace std;

constexpr int GCD(int a, int b) {
    return b == 0 ? a : GCD(b, a % b);
}

template<
    class __data_t,     // input feature map type
    int T,              // input feature map height
    int TP,             // input feature map height parallel degree
    int C,              // input feature map channel
    int CIP,            // input feature map channel parallel degree
    int COP>            // output feature map channel parallel degree
class Adapter{
public:
    static_assert(T % TP  == 0, "T must be multiple of TP");
    static_assert(C % CIP == 0, "C must be multiple of CIP");
    static_assert(C % COP == 0, "C must be multiple of COP");

    static constexpr int TT = T  / TP;
    static constexpr int CIT = C / CIP;
    static constexpr int COT = C / COP;

    static constexpr int UNPK_TRIP = CIP / COP;
    static constexpr int PACK_TRIP = COP / CIP;

    static constexpr int CP = (CIP * COP) / GCD(CIP, COP); // LCM
    static constexpr int CT = C / CP;

    static constexpr int CP_COP = CP / COP;
    static constexpr int CP_CIP = CP / CIP;

    Adapter(){}

    static void unpk(hls::stream<hls::vector<__data_t, TP*CIP> > &i_stream, hls::stream<hls::vector<__data_t, TP*COP> > &o_stream) {
        #pragma HLS inline

        hls::vector<__data_t, TP*CIP> vec_i;

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                UNPK_LOOP: for(int t=0; t<UNPK_TRIP; ++t){
                    #pragma HLS pipeline II=1

                    if(t == 0)  vec_i = i_stream.read();

                    hls::vector<__data_t, TP*COP> vec_o(0);
                   
                    TP_LOOP: for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        CIP_LOOP: for(int cip=0; cip<CIP; ++cip){
                            #pragma HLS unroll

                            // assign vec_o
                            if(cip < COP)       vec_o[tp*COP +cip] = vec_i[tp*CIP +cip];
                            // assign vec_i
                            if(cip + COP < CIP) vec_i[tp*CIP +cip] = vec_i[tp*CIP + (cip+COP)];
                            else                vec_i[tp*CIP +cip] = 0;
  
                        }
                    }

                    o_stream.write(vec_o);

                } // end of UNPK_LOOP
            } // end of CIT_LOOP
        } // end of TT_LOOP
    }

    static void pack(hls::stream<hls::vector<__data_t, TP*CIP> > &i_stream, hls::stream<hls::vector<__data_t, TP*COP> > &o_stream) {
        #pragma HLS inline

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){

                hls::vector<__data_t, TP*COP> vec_o;

                PACK_LOOP: for(int t=0; t<PACK_TRIP; ++t){
                    #pragma HLS pipeline II=1

                    hls::vector<__data_t, TP*CIP> vec_i = i_stream.read();
                    
                    TP_LOOP: for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        COP_LOOP: for(int cop=0; cop<COP; ++cop){  
                            #pragma HLS unroll
                            if(cop + CIP < COP)     vec_o[tp*COP + cop] = vec_o[tp*COP + (cop+CIP)];
                            else                    vec_o[tp*COP + cop] = vec_i[tp*CIP + (cop+CIP-COP)];
                        
                        }
                    }

                } // end of PACK_LOOP

                o_stream.write(vec_o);

            } // end of COT_LOOP
        } // end of TT_LOOP
    }

    void non_divisible(hls::stream<hls::vector<__data_t, TP*CIP> > &i_stream, hls::stream<hls::vector<__data_t, TP*COP> > &o_stream) const{
        #pragma HLS dataflow

        hls::stream<hls::vector<__data_t, TP*CP> >  packed_stream("packed_stream");

        Adapter<__data_t, T, TP, C, CIP, CP>::pack  (i_stream,  packed_stream);
        Adapter<__data_t, T, TP, C, CP, COP>::unpk  (packed_stream, o_stream);
    }


    void do_adapt(hls::stream<hls::vector<__data_t, TP*CIP> > &i_stream, hls::stream<hls::vector<__data_t, TP*COP> > &o_stream) const{
        
        if(CIP % COP == 0 or COP % CIP == 0){
            // divisible implementation
            if(CIP > COP)   unpk(i_stream, o_stream);
            else            pack(i_stream, o_stream);
        } else {
            // non-divisible implementation
            non_divisible(i_stream, o_stream);
        }

    }

};

#endif