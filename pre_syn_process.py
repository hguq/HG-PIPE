import os
import shutil
import threading
from time import time, sleep
from copy import deepcopy
import string

from constants import *


def create_subprojects(instances_root: str, case_names, overwrite=False):
    # if instances_root does not exist, create it
    if not os.path.exists(instances_root):
        os.makedirs(instances_root)

    # create subprojects
    for case_name in case_names:
        proj_name = "proj_" + case_name
        case_src = os.path.join(ROOT_DIR, 'case')
        src_src = os.path.join(ROOT_DIR, 'src')
        case_dest = os.path.join(instances_root, proj_name, 'case')
        src_dest = os.path.join(instances_root, proj_name, 'src')

        # if subproject exists, delete it
        if os.path.exists(case_dest):
            shutil.rmtree(case_dest)
        if os.path.exists(src_dest):
            shutil.rmtree(src_dest)

        shutil.copytree(case_src, case_dest, ignore=shutil.ignore_patterns('*.bin'), dirs_exist_ok=overwrite)
        shutil.copytree(src_src, src_dest, dirs_exist_ok=overwrite)


def remove_tcls(instances_root: str, case_names):
    for case_name in case_names:
        proj_name = "proj_" + case_name
        tcl_path = os.path.join(instances_root, proj_name, "run.tcl")
        os.remove(tcl_path)


def create_tcls(instances_root: str, case_names, do_csim=False, do_csynth=False, do_cosim=False, do_export=False, do_syn=False, do_impl=False, phys_opt="none"):
    def bool2tcl(_bool):
        return "1" if _bool else "0"

    for case_name in case_names:
        # 读取template
        template_path = os.path.join(ROOT_DIR, "template.tcl")
        with open(template_path) as f:
            content = f.read()

        # 替换
        template = string.Template(content)
        content = template.substitute(
            case_name=case_name,
            do_csim=bool2tcl(do_csim),
            do_csynth=bool2tcl(do_csynth),
            do_cosim=bool2tcl(do_cosim),
            do_export=bool2tcl(do_export),
            do_syn=bool2tcl(do_syn),
            do_impl=bool2tcl(do_impl),
            phys_opt=phys_opt
        )

        # 写入
        tcl_file_path = os.path.join(instances_root, f"proj_{case_name}", "run.tcl")
        with open(tcl_file_path, "w") as f:
            f.write(content)


def run_instances(instances_root: str, case_names, version="2023.2"):
    def thread_func(case_name):
        start_time = time()
        proj_name = "proj_" + case_name
        case_dir = os.path.join(instances_root, proj_name)
        os.chdir(case_dir)
        print(f"{case_name} is running")

        vitis_home = os.path.join("C:/programs/xilinx", version.replace('.', '_'), "Vitis_HLS", version, "bin")

        if version=="2020.1":
            vitis_home = os.path.join("C:/programs/xilinx", version.replace('.', '_'), "Vitis", version, "bin")

        vitis_hls_cmd = os.path.join(vitis_home, "vitis_hls -f run.tcl")

        os.system(vitis_hls_cmd)

        end_time = time()
        print(f"{case_name} is done, time: {end_time - start_time}")

    max_threads = 16
    case_queue = deepcopy(case_names)
    thread_pool = []

    try:
        while len(case_queue) > 0:
            if threading.active_count() < max_threads:
                case_name = case_queue.pop()
                thread = threading.Thread(target=thread_func, args=(case_name,))
                thread.start()
                thread_pool.append(thread)

            for t in thread_pool:
                if not t.is_alive():
                    thread_pool.remove(t)

            sleep(0.1)

        for thread in thread_pool:
            thread.join()

    except Exception as e:
        print(e)
