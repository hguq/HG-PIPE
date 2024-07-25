#ifndef __INT_WRAPPER_H__
#define __INT_WRAPPER_H__

#include "common.h"


template<
    class   __data_t,                     // input feature map type
    int     H,                          // input  feature map height
    int     HP,                         // input  feature map height  parallel degree
    int     W,                          // input  feature map width
    int     WP,                         // input  feature map width   parallel degree
    int     C,                         // input  feature map channel
    int     CP>                        // input  feature map channel parallel degree
class Wrapper{
public:

    typedef hls::axis<hls::vector<__data_t, CP*HP*WP>, 0, 0, 0> axis_t;

    static_assert(H % HP == 0, "H % HP != 0");
    static_assert(W % WP == 0, "W % WP != 0");
    static_assert(C % CP == 0, "C % CP != 0");

    static constexpr int HT = H / HP;
    static constexpr int WT = W / WP;
    static constexpr int CT = C / CP;

    void do_wrap(case_index_t N, hls::stream<hls::vector<__data_t, CP*HP*WP> > &i_stream, hls::stream<axis_t> &o_stream) const{

        N_LOOP: for(int n=0; n<N; ++n){
            #pragma HLS loop_tripcount min=1 max=10

            HT_LOOP: for(int ht=0; ht<HT; ++ht){
                WT_LOOP: for(int wt=0; wt<WT; ++wt){
                    CT_LOOP: for(int ct=0; ct<CT; ++ct){
                        #pragma HLS pipeline II=1

                        hls::vector<__data_t, CP*HP*WP> vec_i = i_stream.read();
                        axis_t axis_o;

                        axis_o.data = vec_i;
                        axis_o.keep = -1; // all valid
                        axis_o.strb = -1; // all valid
                        axis_o.last = n == N-1 && ht == HT-1 && wt == WT-1 && ct == CT-1;

                        o_stream.write(axis_o);
                    }
                }
            }
        }

    }

};


#endif
