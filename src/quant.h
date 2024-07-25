#ifndef __INT_QUANT_H__
#define __INT_QUANT_H__

#include "common.h"
#include "utils.h"

template<
    class __if_t,       // input feature map data type
    class __cursor_t,   // lookup table cursor type
    class __of_t,       // output feature map data type
    int   T,            // input feature map sequence length
    int   TP,           // input feature map sequence parallel degree
    int   C,            // input feature map channel
    int   CP,           // input feature map channel parallel degree
    int   ENTRIES       // lookup table entries
> class Quant{
public:

    // static assertions
    static_assert(C % CP == 0, "C must be multiple of CP");

    // static hyper parameters
    static constexpr int CT = C / CP;
    static constexpr int TT = T / TP;

    // scalar weights
    int b;
    int s;
    int bound;

    // array weights
    __of_t table[ENTRIES];

    explicit Quant(
        const int scalars_init[],
        const int table_init[]
    ){
        // fill scalar
        b = scalars_init[0];
        s = scalars_init[1];
        bound = scalars_init[2];
        printf("b: %d, s: %d, bound: %d\n", b, s, bound);
        // fill table
        for(int i=0; i<ENTRIES; ++i){
            table[i] = table_init[i];
        }

    }

    void do_quant(hls::stream<hls::vector<__if_t, TP*CP> >& i_stream, hls::stream<hls::vector<__of_t, TP*CP> >& o_stream) const {

        #pragma HLS bind_storage variable=table type=rom_2p impl=lutram

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            CT_LOOP: for(int ct=0; ct<CT; ++ct){
                #pragma HLS pipeline II=1

                // read input
                hls::vector<__if_t, TP*CP> vec_i = i_stream.read();
                hls::vector<__of_t, TP*CP> vec_o;

                // calculate cursor and lookup
                for(int tp=0; tp<TP; ++tp){
                    #pragma HLS unroll
                    for(int cp=0; cp<CP; ++cp){
                        #pragma HLS unroll
                        __cursor_t cursor = (vec_i[tp*CP + cp] + b) >> s;
                        cursor = clamp(cursor, 0, bound);
                        vec_o[tp*CP + cp] = table[cursor];
                    }
                }

                // write output
                o_stream.write(vec_o);

            } // end of CT_LOOP
        } // end of TT_LOOP

    }

};

#endif