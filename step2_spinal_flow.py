from pre_syn_process import *
from post_syn_process import *
import os

INSTANCE_DIR = os.path.join(ROOT_DIR, "instances")

case_list = [
    "PATCH_EMBED",
    *[f"ATTN{attn_id}" for attn_id in range(12)],
    *[f"MLP{mlp_id}" for mlp_id in range(12)],
    "HEAD"
]
instances_list = ["proj_" + case_name for case_name in case_list]

backup_verilog(INSTANCE_DIR, instances_list=instances_list)
backup_log(INSTANCE_DIR, instances_list=instances_list)

to_spinal_blocks(INSTANCE_DIR, ids=list(range(-1, 25)))

# launch_one_spinal_sim(0)
# launch_one_spinal_sim(1)
# print(f"Latency is {get_latency(0)}")
# print(f"Latency is {get_latency(1)}")

# inplace_replace(os.path.join(ROOT_DIR, "instances"), mode="optimal", instances_list=["proj_ATTN0"])
