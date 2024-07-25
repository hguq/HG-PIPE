from post_syn_process import *

case_names = [
    "LAYERNORM_2X2", "LAYERNORM_2X1", "LAYERNORM_1X2",
    "SOFTMAX_2X2", "SOFTMAX_2X1", "SOFTMAX_1X2"
]

print_resource_table(os.path.join(ROOT_DIR, "instances"))