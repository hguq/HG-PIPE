#ifndef __INT_MATMUL_H__
#define __INT_MATMUL_H__

#include "common.h"

template<
    class   __if_t,                     // input feature map type
    class   __we_t,                     // weight type
    class   __bi_t,
    class   __mc_t,                     // mac type
    int     T,                          // input  feature map sequence length
    int     TP,                         // input  feature map sequence parallel degree
    int     CI,                         // input  feature map channel
    int     CIP,                        // input  feature map channel parallel degree
    int     CIAP,
    int     CO,                         // output feature map channel
    int     COP,                        // output feature map channel parallel degree
    int     COAP,
    int     ADPT_FIFO_DEPTH,            // adapter fifo depth
    int     WIND_FIFO_DEPTH,            // cache window fifo depth
    int     WGHT_FIFO_DEPTH,            // cache weight fifo depth
    int     MACS_FIFO_DEPTH,            // mac fifo depth
    int     WEIGHT_RAM_STYLE,           // weight ram style
    bool    USE_DSP                     // use DSP or not
>
class Matmul{
public:
    static_assert(CI % CIP == 0, "CI must be multiple of CIP");
    static_assert(CO % COP == 0, "CO must be multiple of COP");

    static constexpr int CIT = CI / CIP;
    static constexpr int COT = CO / COP;
    static constexpr int TT  = T  / TP;

    __we_t weight_arr   [CO][CI];
    __bi_t bias_arr     [CO];

    Matmul() = default; // for dynamic matmul, no weight init

    template<class __weight_init_t, class __bias_init_t>
    Matmul(const __weight_init_t weight_init[CO][CI], const __bias_init_t bias_init[CO]){

        // weight init, non-transposed init
        for(int co=0; co<CO; ++co){
            for(int ci=0; ci<CI; ++ci){
                weight_arr[co][ci] = weight_init[co][ci];
            }
        }

        // bias init
        for(int co=0; co<CO; ++co){
            bias_arr[co] = bias_init[co];
        }

    }

    void matmul_step1_cache_window(hls::stream<hls::vector<__if_t, TP*CIP> >& i_stream, hls::stream<hls::vector<__if_t, TP*CIP> >& o_stream) const {

        __if_t wb[TP][CI];
        #pragma HLS array_reshape   variable=wb dim=1       complete
        #pragma HLS array_reshape   variable=wb dim=2       cyclic factor=CIP
        #pragma HLS bind_storage    variable=wb type=ram_1p impl=LUTRAM

        TT_LOOP: for(int tt=0; tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    hls::vector<__if_t, TP*CIP> vec_o;

                    if(cot == 0){
                        // first pass, store input feature map to window buffer
                        vec_o = i_stream.read();
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll
                                wb[tp][cit*CIP + cip] = vec_o[tp*CIP + cip];
                            }
                        }
                    } else {
                        // not first pass, read from window buffer
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll
                                vec_o[tp*CIP + cip] = wb[tp][cit*CIP + cip];
                            }
                        }
                    }

                    o_stream.write(vec_o);

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TPT_LOOP

    }

    void matmul_step2_mac(hls::stream<hls::vector<__if_t, TP*CIP> >&i_stream, hls::stream<hls::vector<__mc_t, TP*COP> >& o_stream) const {

        #pragma HLS array_reshape variable=weight_arr   cyclic factor=COP dim=1
        #pragma HLS array_reshape variable=weight_arr   cyclic factor=CIP dim=2

        if(WEIGHT_RAM_STYLE == BRAM_STYLE){
            #pragma HLS bind_storage variable=weight_arr    type=rom_1p impl=BRAM
        } else if(WEIGHT_RAM_STYLE == URAM_STYLE){
            // static_assert(false, "URAM not supported for weight");
        } else if(WEIGHT_RAM_STYLE == LRAM_STYLE){
            #pragma HLS bind_storage variable=weight_arr    type=rom_1p impl=LUTRAM
        } else {
            // static_assert(false, "unknown weight ram style");
        }

        #pragma HLS array_reshape   variable=bias_arr   cyclic factor=COP dim=1
        #pragma HLS bind_storage    variable=bias_arr   type=rom_1p impl=LUTRAM

        hls::vector<__mc_t, TP*COP> vec_o;

        TT_LOOP: for(int tt=0;tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    // initialize output vector if first trip
                    if(cit == 0){
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                vec_o[tp*COP + cop] = bias_arr[cot*COP + cop];
                            }
                        }
                    }

                    // each time read from input stream
                    hls::vector<__if_t, TP*CIP> vec_i = i_stream.read();

                    TP_LOOP: for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        COP_LOOP: for(int cop=0; cop<COP; ++cop){
                            #pragma HLS unroll
                            CIP_LOOP: for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll

                                if(USE_DSP){
                                    auto mul_res = vec_i[tp*CIP + cip] * weight_arr[cot*COP + cop][cit*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=dsp
                                    vec_o[tp*COP + cop] += mul_res;
                                } else {
                                    auto mul_res = vec_i[tp*CIP + cip] * weight_arr[cot*COP + cop][cit*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=fabric
                                    vec_o[tp*COP + cop] += mul_res;
                                }

                            } // end of CIP_LOOP
                        } // end of COP_LOOP
                    } // end of TP_LOOP

                    // write to output stream if last trip
                    if(cit == CIT-1){
                        o_stream.write(vec_o);
                    }

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TT_LOOP

    }

    void do_matmul(hls::stream<hls::vector<__if_t, TP*CIAP> > &i_stream, hls::stream<hls::vector<__mc_t, TP*COAP> > &o_stream) const {
        #pragma HLS dataflow

        // adapter
        Adapter<__if_t, T, TP, CI, CIAP, CIP> adapter_i;
        Adapter<__mc_t, T, TP, CO, COP, COAP> adapter_o;

        // internal stream
        hls::stream<hls::vector<__if_t, TP*CIP> >   adpt_sm             ("adpt_sm"             );
        hls::stream<hls::vector<__if_t, TP*CIP> >   cache_window_sm     ("cache_window_sm"     );
        hls::stream<hls::vector<__mc_t, TP*COP> >   mac_sm              ("mac_sm"              );

        #pragma HLS stream variable=adpt_sm             depth=ADPT_FIFO_DEPTH
        #pragma HLS stream variable=cache_window_sm     depth=WIND_FIFO_DEPTH
        #pragma HLS stream variable=mac_sm              depth=MACS_FIFO_DEPTH

        adapter_i.do_adapt          (   i_stream,           adpt_sm             );
        matmul_step1_cache_window   (   adpt_sm,            cache_window_sm     );
        matmul_step2_mac            (   cache_window_sm,    mac_sm              );
        adapter_o.do_adapt          (   mac_sm,             o_stream            );

    }

    // ----------------------------------------------------------------------------------------------------------------------------------
    // dynamic matmul, the weight is streamed in
    // one branch:  input cache and fetch
    // one branch:  weight cache and fetch
    // merge:       mac
    // the function "matmul_step1_cache_window" can be reused
    // need to add another function "matmul_step1_cache_weight"
    // and should overload another implementation of "do_matmul", it has 2 input streams

    // the weight cache can apply partial write
    void matmul_step1_cache_weight(hls::stream<hls::vector<__we_t, COP*CIP> > &i_stream, hls::stream<hls::vector<__we_t, COP*CIP> > &o_stream) {

        __we_t dynamic_weight_arr[CO][CI];
        #pragma HLS array_reshape   variable=dynamic_weight_arr dim=1   cyclic factor=COP
        #pragma HLS array_reshape   variable=dynamic_weight_arr dim=2   cyclic factor=CIP

        if(WEIGHT_RAM_STYLE == BRAM_STYLE){
            #pragma HLS bind_storage variable=dynamic_weight_arr    type=ram_1p impl=BRAM
        } else if(WEIGHT_RAM_STYLE == URAM_STYLE){
            // static_assert(false, "URAM not supported for weight");
        } else if(WEIGHT_RAM_STYLE == LRAM_STYLE){
            #pragma HLS bind_storage variable=dynamic_weight_arr    type=ram_1p impl=LUTRAM
        } else {
            // static_assert(false, "unknown weight ram style");
        }

        // no bias

        // first loop body, only store
        COT_LOOP: for(int cot=0; cot<COT; ++cot){
            CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                #pragma HLS pipeline II=1

                hls::vector<__we_t, COP*CIP> vec_i = i_stream.read();

                for(int cop=0; cop<COP; ++cop){
                    #pragma HLS unroll
                    for(int cip=0; cip<CIP; ++cip){
                        #pragma HLS unroll
                        dynamic_weight_arr[cot*COP + cop][cit*CIP + cip] = vec_i[cop*CIP + cip];
                    }
                }

            }
        }

        // second loop body
        TT_LOOP_2: for(int tt=0; tt<TT; ++tt){
            COT_LOOP_2: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP_2: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    hls::vector<__we_t, COP*CIP> vec_o;

                    // not first pass, read from window buffer
                    for(int cop=0; cop<COP; ++cop){
                        #pragma HLS unroll
                        for(int cip=0; cip<CIP; ++cip){
                            #pragma HLS unroll
                            vec_o[cop*CIP + cip] = dynamic_weight_arr[cot*COP + cop][cit*CIP + cip];
                        }
                    }

                    o_stream.write(vec_o);

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TT_LOOP


    }

    void matmul_step1_cache_weight_transposed(hls::stream<hls::vector<__we_t, COP*CIP> > &i_stream, hls::stream<hls::vector<__we_t, COP*CIP> > &o_stream) {
        // the store and write is separated, and the input stream is transposed, i.e., exchanged loop order and tile direction

        __we_t dynamic_weight_arr[CO][CI];
        #pragma HLS array_reshape   variable=dynamic_weight_arr dim=1   cyclic factor=COP
        #pragma HLS array_reshape   variable=dynamic_weight_arr dim=2   cyclic factor=CIP

        if(WEIGHT_RAM_STYLE == BRAM_STYLE){
            #pragma HLS bind_storage variable=dynamic_weight_arr    type=ram_1p impl=BRAM
        } else if(WEIGHT_RAM_STYLE == URAM_STYLE){
            // static_assert(false, "URAM not supported for weight");
        } else if(WEIGHT_RAM_STYLE == LRAM_STYLE){
            #pragma HLS bind_storage variable=dynamic_weight_arr    type=ram_1p impl=LUTRAM
        } else {
            // static_assert(false, "unknown weight ram style");
        }

        // no bias

        // first loop body, only transposed store
        CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                #pragma HLS pipeline II=1

                hls::vector<__we_t, COP*CIP> vec_i = i_stream.read();

                for(int cop=0; cop<COP; ++cop){
                    #pragma HLS unroll
                    for(int cip=0; cip<CIP; ++cip){
                        #pragma HLS unroll
                        dynamic_weight_arr[cot*COP + cop][cit*CIP + cip] = vec_i[cop*CIP + cip];
                    }
                }

            }
        }

        // second loop body
        TT_LOOP_2: for(int tt=0; tt<TT; ++tt){
            COT_LOOP_2: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP_2: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    hls::vector<__we_t, COP*CIP> vec_o;

                    // not first pass, read from window buffer
                    for(int cop=0; cop<COP; ++cop){
                        #pragma HLS unroll
                        for(int cip=0; cip<CIP; ++cip){
                            #pragma HLS unroll
                            vec_o[cop*CIP + cip] = dynamic_weight_arr[cot*COP + cop][cit*CIP + cip];
                        }
                    }

                    o_stream.write(vec_o);

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TT_LOOP

    }

    void matmul_step2_mac(
        hls::stream<hls::vector<__if_t,  TP*CIP> >& i_stream, 
        hls::stream<hls::vector<__we_t, COP*CIP> >& w_stream,
        hls::stream<hls::vector<__mc_t,  TP*COP> >& o_stream
    ) {

        hls::vector<__mc_t, TP*COP> vec_o;

        TT_LOOP: for(int tt=0;tt<TT; ++tt){
            COT_LOOP: for(int cot=0; cot<COT; ++cot){
                CIT_LOOP: for(int cit=0; cit<CIT; ++cit){
                    #pragma HLS pipeline II=1

                    // initialize output vector if first trip
                    if(cit == 0){
                        for(int tp=0; tp<TP; ++tp){
                            #pragma HLS unroll
                            for(int cop=0; cop<COP; ++cop){
                                #pragma HLS unroll
                                vec_o[tp*COP + cop] = 0;
                            }
                        }
                    }

                    // each time read from input stream
                    hls::vector<__if_t,  TP*CIP> vec_i = i_stream.read();
                    hls::vector<__we_t, COP*CIP> vec_w = w_stream.read();

                    TP_LOOP: for(int tp=0; tp<TP; ++tp){
                        #pragma HLS unroll
                        COP_LOOP: for(int cop=0; cop<COP; ++cop){
                            #pragma HLS unroll
                            CIP_LOOP: for(int cip=0; cip<CIP; ++cip){
                                #pragma HLS unroll

                                if(USE_DSP){
                                    auto mul_res = vec_i[tp*CIP + cip] * vec_w[cop*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=dsp
                                    vec_o[tp*COP + cop] += mul_res;
                                } else {
                                    auto mul_res = vec_i[tp*CIP + cip] * vec_w[cop*CIP + cip];
                                    #pragma HLS bind_op variable=mul_res op=mul impl=fabric
                                    vec_o[tp*COP + cop] += mul_res;
                                }

                            } // end of CIP_LOOP
                        } // end of COP_LOOP
                    } // end of TP_LOOP

                    // write to output stream if last trip
                    if(cit == CIT-1){
                        o_stream.write(vec_o);
                    }

                } // end of CIT_LOOP
            } // end of COT_LOOP
        } // end of TT_LOOP
    
    }


    void do_matmul(
        hls::stream<hls::vector<__if_t, TP*CIAP> > &i_stream, 
        hls::stream<hls::vector<__we_t, COP*CIP> > &w_stream,
        hls::stream<hls::vector<__mc_t, TP*COAP> > &o_stream,
        bool TRANSPOSED
    ) {
        #pragma HLS dataflow

        // adapter
        Adapter<__if_t, T, TP, CI, CIAP, CIP> adapter_i;
        Adapter<__mc_t, T, TP, CO, COP, COAP> adapter_o;

        // internal stream
        hls::stream<hls::vector<__if_t,  TP*CIP> >   adpt_sm             ("adpt_sm"             );
        hls::stream<hls::vector<__if_t,  TP*CIP> >   cache_window_sm     ("cache_window_sm"     );
        hls::stream<hls::vector<__we_t, COP*CIP> >   weight_sm           ("weight_sm"           );
        hls::stream<hls::vector<__mc_t,  TP*COP> >   mac_sm              ("mac_sm"              );

        #pragma HLS stream variable=adpt_sm             depth=ADPT_FIFO_DEPTH
        #pragma HLS stream variable=cache_window_sm     depth=WIND_FIFO_DEPTH
        #pragma HLS stream variable=weight_sm           depth=WGHT_FIFO_DEPTH
        #pragma HLS stream variable=mac_sm              depth=MACS_FIFO_DEPTH

        adapter_i.do_adapt          (   i_stream,           adpt_sm                                 );
        matmul_step1_cache_window   (   adpt_sm,            cache_window_sm                         );
        if (TRANSPOSED){
            matmul_step1_cache_weight_transposed    (w_stream, weight_sm);
        } else {
            matmul_step1_cache_weight               (w_stream, weight_sm);
        }
        matmul_step2_mac            (   cache_window_sm,    weight_sm,          mac_sm              );
        adapter_o.do_adapt          (   mac_sm,             o_stream                                );
    }

};

#endif