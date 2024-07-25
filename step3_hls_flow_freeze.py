from post_syn_process import *
from pre_syn_process import *

case_names = ["ATTN0"]


INSTANCE_DIR = os.path.join(ROOT_DIR, "instances_freeze")

create_subprojects(INSTANCE_DIR, case_names=case_names, overwrite=True)
create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True, do_csynth=True, do_cosim=True, do_syn=True)
run_instances(INSTANCE_DIR, case_names=case_names, version="2023.2")