from post_syn_process import *
from pre_syn_process import *

# create the subprojects, if case_names include multiple cases, then multiple subprojects will be created
# each one corresponds to one cpp file in "case"


# case_names = [f"{t}0_{n}bit" for t in ("ATTN", "MLP") for n in range(3, 9)]
# case_names = [f"{t}{n}" for t in ("ATTN", "MLP") for n in range(12)] + ["HEAD"] + ["PATCH_EMBED"]
case_names = ["ATTN7", "ATTN8"]

INSTANCE_DIR = os.path.join(ROOT_DIR, "instances")

create_subprojects(INSTANCE_DIR, case_names=case_names, overwrite=True)

# create the tcl files for each subproject
create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True)
# create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True, do_csynth=True)
# create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True, do_csynth=True, do_cosim=True)
# create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True, do_csynth=True, do_cosim=True, do_syn=True)
# create_tcls(INSTANCE_DIR, case_names=case_names, do_csim=True, do_csynth=True, do_cosim=True, do_impl=True, phys_opt="all")


# launch the tcl files
run_instances(INSTANCE_DIR, case_names=case_names, version="2023.2")