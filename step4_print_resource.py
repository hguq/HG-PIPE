from post_syn_process import *

print_resource_table(os.path.join(ROOT_DIR, "instances"))


collect_ip(os.path.join(ROOT_DIR, "instances"), target_dir=os.path.join(ROOT_DIR, "ips"))

