#ifndef __INT_UTILS_H__
#define __INT_UTILS_H__


template<typename _typename, typename _val_t>
_typename clamp(_typename val, _val_t min_val, _val_t max_val) {
    if (val < min_val) return min_val;
    if (val > max_val) return max_val;
    return val;
}

template<typename _typename>
_typename quantize_clamp(_typename val, int bits, bool is_signed) {
    int min_val, max_val;
    if (is_signed) {
        min_val = -(1 << (bits - 1));
        max_val = +(1 << (bits - 1)) - 1;
    } else {
        min_val = 0;
        max_val = (1 << bits) - 1;
    }
    return clamp(val, min_val, max_val);
}


#endif
