#ifndef __INT_COMMON_H__
#define __INT_COMMON_H__

// standard library
#include <cassert>
#include <ctime>
#include <iostream>
#include <cstdint>

// hls library
#include <ap_int.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_vector.h>

// user defined library
#include "adapter.h"

using namespace std;

const unsigned int SYSTEM_WIDTH = 64;
typedef ap_int<SYSTEM_WIDTH> system_t;

// fc related definition
typedef ap_uint<10>         class_index_t; // indexing class
typedef ap_uint<18>         case_index_t;

typedef ap_axiu<SYSTEM_WIDTH, 0, 0, 0> axis_t;

constexpr int log2ce(int n){
    return (n <= 1) ? 0 : 1 + log2ce(n / 2);
}

constexpr const int BRAM_STYLE = 0;
constexpr const int URAM_STYLE = 1;
constexpr const int LRAM_STYLE = 2;

// A prime number, for auto template completion
constexpr const int NONE_CP = 47;


#endif