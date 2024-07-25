from post_syn_process import *
from pre_syn_process import *
import numpy as np

def to_signed(_s):
    if _s == "signed":
        return "ap_int "
    elif _s == "unsigned" :
        return "ap_uint"
    else:
        raise ValueError("Unknown sign type!")
    
def to_string(_i):
    return f"{_i: 3d}"
    

def generate_attn(type_dict, attn_id):
    """
    Use the template of Attention to generate the case.
    attn_id: the id of the attention case, from 0 to 11, total 12 cases.
    """

    ATTN_ID=str(attn_id)

    with open("./case/ATTN.cpp.template") as f:
        content = f.read()
    # substitute
    template = string.Template(content)
    content = template.substitute(
        N                               =   ATTN_ID,

        # attn global tyeps
        __attn_if_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.input"][0]),
        __attn_if_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.input"][1]),

        __attn_lnq_t_type               =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.output"][0]),
        __attn_lnq_t_width              =   to_string(type_dict[f"attn{ATTN_ID}.lnq.output"][1]),

        __attn_q_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.q"][0]),
        __attn_q_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.q"][1]),

        __attn_k_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.k"][0]),
        __attn_k_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.k"][1]),

        __attn_v_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.v"][0]),
        __attn_v_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.v"][1]),

        __attn_r_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.r"][0]),
        __attn_r_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.r"][1]),

        __attn_a_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.a"][0]),
        __attn_a_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.a"][1]),

        __attn_o_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.proj"][0]),
        __attn_o_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.proj"][1]),

        __attn_qq_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.qq.output"][0]),
        __attn_qq_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.qq.output"][1]),

        __attn_kq_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.kq.output"][0]),
        __attn_kq_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.kq.output"][1]),

        __attn_vq_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.vq.output"][0]),
        __attn_vq_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.vq.output"][1]),

        __attn_rq_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.output"][0]),
        __attn_rq_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.output"][1]),

        __attn_aq_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.aq.output"][0]),
        __attn_aq_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.aq.output"][1]),

        __attn_of_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.output"][0]),
        __attn_of_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.output"][1]),

        __ln_sum_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.sum"][0]), 
        __ln_sum_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.lnq.sum"][1]),

        __ln_divc_t_type                =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.divc"][0]), 
        __ln_divc_t_width               =   to_string(type_dict[f"attn{ATTN_ID}.lnq.divc"][1]),

        __ln_mu_t_type                  =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.mu"][0]),
        __ln_mu_t_width                 =   to_string(type_dict[f"attn{ATTN_ID}.lnq.mu"][1]),

        __ln_var_t_type                 =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.var"][0]),
        __ln_var_t_width                =   to_string(type_dict[f"attn{ATTN_ID}.lnq.var"][1]),

        __ln_cursor_t_type              =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.cursor"][0]), 
        __ln_cursor_t_width             =   to_string(type_dict[f"attn{ATTN_ID}.lnq.cursor"][1]),

        __ln_rsqrt_t_type               =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.rsqrt"][0]), 
        __ln_rsqrt_t_width              =   to_string(type_dict[f"attn{ATTN_ID}.lnq.rsqrt"][1]),

        __ln_affine_t_type              =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.affine"][0]),
        __ln_affine_t_width             =   to_string(type_dict[f"attn{ATTN_ID}.lnq.affine"][1]),

        __ln_shift_t_type               =   to_signed(type_dict[f"attn{ATTN_ID}.lnq.shift"][0]),
        __ln_shift_t_width              =   to_string(type_dict[f"attn{ATTN_ID}.lnq.shift"][1]),

        __attn_qq_cursor_t_type         =   to_signed(type_dict[f"attn{ATTN_ID}.qq.cursor"][0]),
        __attn_qq_cursor_t_width        =   to_string(type_dict[f"attn{ATTN_ID}.qq.cursor"][1]),

        __attn_kq_cursor_t_type         =   to_signed(type_dict[f"attn{ATTN_ID}.kq.cursor"][0]),
        __attn_kq_cursor_t_width        =   to_string(type_dict[f"attn{ATTN_ID}.kq.cursor"][1]),

        __attn_vq_cursor_t_type         =   to_signed(type_dict[f"attn{ATTN_ID}.vq.cursor"][0]),
        __attn_vq_cursor_t_width        =   to_string(type_dict[f"attn{ATTN_ID}.vq.cursor"][1]),

        __attn_aq_cursor_t_type         =   to_signed(type_dict[f"attn{ATTN_ID}.aq.cursor"][0]),
        __attn_aq_cursor_t_width        =   to_string(type_dict[f"attn{ATTN_ID}.aq.cursor"][1]),

        __softmax_minus_t_type          =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.minus_max"][0]), 
        __softmax_minus_t_width         =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.minus_max"][1]),

        __softmax_cursor1_t_type        =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.cursor1"][0]), 
        __softmax_cursor1_t_width       =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.cursor1"][1]),

        __softmax_exp_t_type            =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.exp"][0]),
        __softmax_exp_t_width           =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.exp"][1]),

        __softmax_acc_t_type            =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.acc"][0]),
        __softmax_acc_t_width           =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.acc"][1]),

        __softmax_recip_t_type          =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.recip"][0]),
        __softmax_recip_t_width         =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.recip"][1]),

        __softmax_cursor2_one_t_type    =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.cursor2_one"][0]), 
        __softmax_cursor2_one_t_width   =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.cursor2_one"][1]),

        __softmax_cursor2_two_t_type    =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.cursor2_two"][0]), 
        __softmax_cursor2_two_t_width   =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.cursor2_two"][1]),

        __softmax_affine_t_type         =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.affine"][0]),
        __softmax_affine_t_width        =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.affine"][1]),

        __softmax_cursor3_t_type        =   to_signed(type_dict[f"attn{ATTN_ID}.softmaxq.cursor3"][0]), 
        __softmax_cursor3_t_width       =   to_string(type_dict[f"attn{ATTN_ID}.softmaxq.cursor3"][1]),
    )
    # write
    with open(f"./case/ATTN{ATTN_ID}.cpp", "w") as f:
        f.write(content)


def generate_mlp(type_dict, mlp_id):
    """
    Use the template of MLP to generate the case.
    mlp_id: the id of the mlp case, from 0 to 2, total 3 cases.
    """

    MLP_ID=str(mlp_id)

    with open("./case/MLP.cpp.template") as f:
        content = f.read()
    # substitute
    template = string.Template(content)
    content = template.substitute(
        N                               =   MLP_ID,

            #global data type
        __mlp_if_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.input"][0]),
        __mlp_if_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.input"][1]),

        __mlp_ln_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.output"][0]), 
        __mlp_ln_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.lnq.output"][1]),

        __mlp_m1_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.matmul1"][0]), 
        __mlp_m1_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.matmul1"][1]),

        __mlp_ge_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.geluq.output"][0]), 
        __mlp_ge_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.geluq.output"][1]),

        __mlp_m2_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.matmul2"][0]),
        __mlp_m2_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.matmul2"][1]),

        __mlp_of_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.output"][0]),
        __mlp_of_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.output"][1]),

        #layernorm
        __ln_sum_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.sum"][0]), 
        __ln_sum_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.lnq.sum"][1]),

        __ln_divc_t_type        =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.divc"][0]), 
        __ln_divc_t_width       =   to_string(type_dict[f"mlp{MLP_ID}.lnq.divc"][1]),

        __ln_mu_t_type          =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.mu"][0]),
        __ln_mu_t_width         =   to_string(type_dict[f"mlp{MLP_ID}.lnq.mu"][1]),

        __ln_var_t_type         =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.var"][0]),
        __ln_var_t_width        =   to_string(type_dict[f"mlp{MLP_ID}.lnq.var"][1]),

        __ln_cursor_t_type      =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.cursor"][0]), 
        __ln_cursor_t_width     =   to_string(type_dict[f"mlp{MLP_ID}.lnq.cursor"][1]),

        __ln_rsqrt_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.rsqrt"][0]), 
        __ln_rsqrt_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.lnq.rsqrt"][1]),

        __ln_affine_t_type      =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.affine"][0]),
        __ln_affine_t_width     =   to_string(type_dict[f"mlp{MLP_ID}.lnq.affine"][1]),

        __ln_shift_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.lnq.shift"][0]),
        __ln_shift_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.lnq.shift"][1]),

        #matmul 1
        __m1_we_t_type       =   "ap_int", 
        __m1_we_t_width      =   to_string(3),

        __m1_bi_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.matmul1"][0]),
        __m1_bi_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.matmul1"][1]),

        __m1_mc_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.matmul1"][0]),
        __m1_mc_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.matmul1"][1]),

        #gelu
        __gelu_cursor_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.geluq.cursor"][0]),
        __gelu_cursor_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.geluq.cursor"][1]),

        #matmul2
        __m2_we_t_type       =   "ap_int", 
        __m2_we_t_width      =   to_string(3),

        __m2_bi_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.output"][0]),
        __m2_bi_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.output"][1]),

        __m2_mc_t_type       =   to_signed(type_dict[f"mlp{MLP_ID}.output"][0]),
        __m2_mc_t_width      =   to_string(type_dict[f"mlp{MLP_ID}.output"][1])
    )

    # write
    with open(f"./case/MLP{MLP_ID}.cpp", "w") as f:
        f.write(content)


if __name__ == "__main__":
    loaded_type_dict = np.load("./binaries/batchsize1/behavior_type_dict.npy", allow_pickle=True).item()
    for attn_id in range(12):
        generate_attn(loaded_type_dict, attn_id)
    for mlp_id in range(12):
        generate_mlp(loaded_type_dict, mlp_id)