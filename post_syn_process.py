"""
This module is for post HLS-synthesis process, including:
1. collect resource report, and print the table. (print_resource_table)
2. collect IP files. (collect_ip)
3. backup verilog files. (backup_verilog)
4. backup log files. (backup_log)
5. inplace replace the fifo depth. This is used in previous convolutional networks. (inplace_replace)
6. to spinal. This is used in spinal simulation. (to_spinal_one_block, to_spinal_all)
7. launch spinal simulation. (launch_one_spinal_sim, launch_all_spinal_sim)
8. get spinal simulation latencies. (get_latencies)
9. calculate bram cost. (cal_block_bram_cost, cal_total_bram_cost)
"""
import glob
import shutil
import re
from math import ceil
import socket
import threading

from constants import *

# -------------------------------------------------------------------------------------
def get_resource_table(instances_root: str, instances_list=[]):
    if not instances_list:
        instances_list = os.listdir(instances_root)

    resource_types = ["SLICE", "LUT", "FF", "DSP", "BRAM", "URAM", "LATCH", "SRL"]
    result_dict = {}
    for instance in instances_list:
        log_path = os.path.join(instances_root, instance, "vitis_hls.log")
        try:
            log_content = open(log_path).read()
        except FileNotFoundError:
            print("FileNotFoundError: " + log_path)
            continue
        instance_dict = {}
        for resource_type in resource_types:
            instance_dict[resource_type] = re.findall(resource_type + r":\s+(\d+)", log_content)
        # if any not filled, don't add to result_dict
        if any([len(instance_dict[key]) == 0 for key in instance_dict]):
            continue
        result_dict[instance] = instance_dict
    return result_dict


# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def print_resource_table(instances_root: str):
    resource_types = ["SLICE", "LUT", "FF", "DSP", "BRAM", "URAM", "LATCH", "SRL"]
    result_dict = get_resource_table(instances_root)
    print()
    print(f"{'instance':25s}{''.join([f'{resource_type:10s}' for resource_type in resource_types])}\n")
    for instance in result_dict:
        print(f"{instance:25s}", end="")
        for resource_type in resource_types:
            print(f"{result_dict[instance][resource_type][0]:10s}", end="")
        print()
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def collect_ip(instances_root: str, target_dir: str):
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
    for zip_file in glob.glob(os.path.join(instances_root, "**/export_ip/*.zip"), recursive=True):
        print(f"Copying {zip_file} to {target_dir}...")
        shutil.copy(zip_file, target_dir)
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def backup_verilog(instances_root: str, instances_list=[]):
    if not instances_list:
        instances_list = os.listdir(instances_root)

    for instance in instances_list:
        vlog_dir = os.path.join(instances_root, instance, "work/solution/syn/verilog")
        vlog_files = [f for f in os.listdir(vlog_dir) if f.endswith(".v")]
        data_files = [f for f in os.listdir(vlog_dir) if f.endswith(".dat")]  # ROM

        print(f"Backing up {instance}...")
        print(f"vlog_dir: {vlog_dir}")
        print(f"vlog_files: {vlog_files}")
        print(f"data_files: {data_files}")

        backup_dir = os.path.join(instances_root, instance, "work/solution/syn/verilog_backup")

        if not os.path.exists(backup_dir):
            os.makedirs(backup_dir)
            for file in vlog_files + data_files:
                shutil.copyfile(os.path.join(vlog_dir, file), os.path.join(backup_dir, file))
        else:
            print(f"backup_dir {backup_dir} already exists, skip backup")
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def backup_log(instances_root: str, instances_list=[], overwrite=False):
    if not instances_list:
        instances_list = os.listdir(instances_root)

    for instance in instances_list:
        log_dir = os.path.join(instances_root, instance)
        log_file = "vitis_hls.log"
        backup_file = "golden.log"

        if not os.path.exists(os.path.join(log_dir, backup_file)) or overwrite:
            shutil.copyfile(os.path.join(log_dir, log_file), os.path.join(log_dir, backup_file))
        else:
            print(f"backup_file {backup_file} already exists, skip backup")
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def inplace_replace(instances_root: str, mode, instances_list):
    if not instances_list:
        instances_list = os.listdir(instances_root)

    assert mode in ["shallow", "deep", "optimal", "unique", "handcraft"]

    for instance in instances_list:
        # generate from backup, and put to the corresponding "verilog" folder
        src_dir = os.path.join(instances_root, instance, "work/solution/syn/verilog_backup/")
        tgt_dir = os.path.join(instances_root, instance, "work/solution/syn/verilog/")
        assert os.path.exists(src_dir)

        vlog_files = [f for f in os.listdir(src_dir) if f.endswith(".v")]
        for vlog_file in vlog_files:
            # only fifo files are related
            if "fifo" not in vlog_file:
                continue
            output_lines = []
            with open(src_dir + vlog_file) as f:
                input_lines = f.readlines()
            for input_line in input_lines:
                # use re
                if re.search(r"DEPTH\s*=", input_line):
                    orig_depth = input_line.split("=")[1].split(';')[0].strip()
                    orig_depth = orig_depth.split(")")[0]
                    orig_depth = int(orig_depth.split("'d")[-1])

                    if orig_depth + 1 not in UNIQUE_DEPTH_DICT_REV.keys():
                        print(f"WARN: {vlog_file} is not in UNIQUE_DEPTH_DICT_REV.keys(), skip inplace replace")
                        output_lines.append(input_line)
                        continue

                    # NOTE: This plus 1 behavior is rooted in HLS fifo
                    fifo_name = UNIQUE_DEPTH_DICT_REV[orig_depth + 1]

                    if mode in ["shallow", "deep"]:
                        if fifo_name in DONT_TOUCH_FIFO:
                            new_depth = orig_depth
                        else:
                            new_depth = SHALLOW_DEPTH if mode == "shallow" else DEEP_DEPTH
                    elif mode == "optimal":
                        new_depth = OPTIMAL_DEPTH_DICT[fifo_name]
                    elif mode == "unique":
                        new_depth = orig_depth
                    else:
                        raise NotImplementedError
                    # use re to find "DEPTH" + " " * ? + "="
                    input_line = re.sub(r"DEPTH\s*=\s*\d+", f"DEPTH = {new_depth}", input_line)

                output_lines.append(input_line)

            with open(os.path.join(tgt_dir, vlog_file), "w") as f:
                f.writelines(output_lines)
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def to_spinal_one_block(instances_root: str, block_id, depth_dict=None):
    """replace the verilog files in spinal project"""

    """
    Two special cases:
    -1: means patch embed
    24: means head
    """

    if block_id == -1:
        assert depth_dict is None
        block_type = "PATCH_EMBED"
        case_name = "PATCH_EMBED"
        instance_name = "proj_PATCH_EMBED"
    elif block_id == 24:
        assert depth_dict is None
        block_type = "HEAD"
        case_name = "HEAD"
        instance_name = "proj_HEAD"
    else:
        block_type = "ATTN" if block_id % 2 == 0 else "MLP"
        case_name = f"{block_type}{block_id // 2}"
        instance_name = f"proj_{case_name}"

    # generate from backup, and put to the corresponding "verilog" folder
    target_file = os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}/all.v")
    src_dir = os.path.join(instances_root, instance_name, "work/solution/syn/verilog_backup/")
    print(f"src_dir: {src_dir}")
    assert os.path.exists(src_dir)

    # use backup files to generate spinal files
    vlog_files = [f for f in os.listdir(src_dir) if f.endswith(".v")]
    data_files = [f for f in os.listdir(src_dir) if f.endswith(".dat")]  # ROM

    # verilator lint_off
    content = [
        "/* verilator lint_off PINMISSING */\n",
        "/* verilator lint_off CASEX */\n",
        "/* verilator lint_off CASEOVERLAP */\n",
    ]
    # process files
    for vlog_file in vlog_files:
        with open(src_dir + vlog_file) as f:
            input_lines = f.readlines()
        for input_line in input_lines:
            # no delay statement
            if input_line.strip().startswith("#0"):
                input_line = "//" + input_line
            # memory file path
            if "readmemh" in input_line:
                # should replace \ with /, otherwise it will be wrong in windows
                input_line = input_line.replace('readmemh("./', 'readmemh("' + os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}/").replace("\\", "/"))
            # rename top name
            if "top" in input_line:
                input_line = input_line.replace("top", case_name)
            # remove plusargs
            if "plusargs" in input_line:
                input_line = "//" + input_line + f'$display("This is {block_type} {block_id}.\\n");\n'
            # replace fifo depth
            if depth_dict is not None:
                # do depth replacement
                if re.search(r"DEPTH\s*=", input_line) and "top_fifo" in vlog_file:
                    # reverse, from depth to fifo name
                    orig_depth = input_line.split("=")[1].split(';')[0].strip()
                    # orig_depth = int(orig_depth.split("'d")[-1])
                    orig_depth = int(orig_depth.split(")")[0])
                    try:
                        fifo_name = UNIQUE_DEPTH_DICT_REV[orig_depth + 1]
                        new_depth = depth_dict[fifo_name]
                    except KeyError:
                        new_depth = orig_depth
                    # use re to find "DEPTH" + " " * ? + "="
                    input_line = re.sub(r"DEPTH\s*=\s*\d+", f"DEPTH       = {new_depth}", input_line)

            content.append(input_line)

    if not os.path.exists(os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}")):
        os.makedirs(os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}"))

    with open(target_file, "w") as f:
        f.writelines(content)

    # copy all .dat files
    for data_file in data_files:
        shutil.copyfile(
            os.path.join(src_dir, data_file),
            os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}", data_file.replace("top", case_name))
        )
        shutil.copyfile(
            os.path.join(src_dir, data_file),
            os.path.join(SPINAL_DIR, f"src/main/verilog/"           , data_file.replace("top", case_name))
        )
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def to_spinal_all_blocks(instances_root, depth_dicts=None):
    """replace the verilog files in spinal project"""
    for block_id in range(NUM_BLOCKS):
        to_spinal_one_block(instances_root, block_id, depth_dicts[block_id])
# -------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------
def to_spinal_blocks(instances_root, ids):
    """replace the verilog files in spinal project"""
    for block_id in ids:
        to_spinal_one_block(instances_root, block_id)
# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def to_spinal_others(instances_root: str, case_names):
    """copy the verilog file of linear"""
    for case_name in case_names:
        # case_name = "FC_SAXILITE"
        target_file = SPINAL_DIR + f"/src/main/verilog/{case_name}/all.v"
        src_dir = instances_root + f"proj_{case_name}/work/solution/syn/verilog/"
        assert os.path.exists(src_dir)

        # use verilog files to generate spinal files
        vlog_files = [f for f in os.listdir(src_dir) if f.endswith(".v")]
        data_files = [f for f in os.listdir(src_dir) if f.endswith(".dat")]  # ROM

        content = []  # one file
        content.append("/* verilator lint_off PINMISSING */\n")
        for vlog_file in vlog_files:
            with open(src_dir + vlog_file) as f:
                input_lines = f.readlines()
            for input_line in input_lines:
                if input_line.strip().startswith("#0"):
                    input_line = "//" + input_line
                if "readmemh" in input_line:
                    # input_line = input_line.replace('readmemh("./', 'readmemh("' + os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}/"))
                    # should replace \ with /, otherwise it will be wrong in windows
                    input_line = input_line.replace('readmemh("./', 'readmemh("' + os.path.join(SPINAL_DIR, f"src/main/verilog/{case_name}/").replace("\\", "/"))
                    print(input_line)
                if "top" in input_line:
                    input_line = input_line.replace("top", case_name)
                content.append(input_line)
        if not os.path.exists(SPINAL_DIR + f"/src/main/verilog/{case_name}"):
            os.makedirs(SPINAL_DIR + f"/src/main/verilog/{case_name}")
        with open(target_file, "w") as f:
            f.writelines(content)

        # copy all .dat files
        for data_file in data_files:
            shutil.copyfile(src_dir + data_file, SPINAL_DIR + f"/src/main/verilog/{case_name}/" + data_file.replace("top", case_name))


# -------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------
def _get_fifo_width(instances_root: str):
    fifo_width_dict = deepcopy(SHALLOW_DEPTH_DICT)
    for fifo_name in fifo_width_dict.keys():
        fifo_width_dict[fifo_name] = 0  # when not found, that means the FIFO is not set by unique settings. Default to 0

    instance = "proj_ATTN0"
    # use backup files to generate spinal files
    src_dir = os.path.join(instances_root, f"{instance}/work/solution/syn/verilog_backup/")
    assert os.path.exists(src_dir)
    vlog_files = [f for f in os.listdir(src_dir) if f.endswith(".v")]

    for vlog_file in vlog_files:
        if "fifo" not in vlog_file:
            continue  # cannot find fifo width
        with open(os.path.join(src_dir, vlog_file)) as f:
            input_lines = f.readlines()
        for line_number, input_line in enumerate(input_lines):
            if re.search(r"DEPTH\s*=", input_line):
                # reverse, from depth to fifo name
                orig_depth = input_line.split("=")[1].split(';')[0].strip()
                orig_depth = orig_depth.split(")")[0]
                orig_depth = int(orig_depth.split("'d")[-1])
                if orig_depth + 1 not in UNIQUE_DEPTH_DICT_REV.keys():
                    assert orig_depth == SHALLOW_DEPTH
                    continue
                # find the key
                fifo_name = UNIQUE_DEPTH_DICT_REV[orig_depth + 1]
                # find the data width, in the previous line
                prev_line = input_lines[line_number - 2]
                assert re.search(r"DATA_WIDTH\s*=", prev_line)
                data_width = int(prev_line.split("=")[1].split(',')[0].strip())
                fifo_width_dict[fifo_name] = data_width
    return fifo_width_dict
# -------------------------------------------------------------------------------------


try:
    WIDTH_DICT = _get_fifo_width("instances")  # 从backup中获取，不需要修改
    # from width dicts, delete DONT_TOUCH_FIFO
    RELATED_FIFOS = [fifo_name for fifo_name, fifo_width in WIDTH_DICT.items() if fifo_width != 0 and fifo_name not in DONT_TOUCH_FIFO]
except (AttributeError, AssertionError):
    # not finished
    WIDTH_DICT = None
    RELATED_FIFOS = None


# -------------------------------------------------------------------------------------
def launch_one_spinal_sim(number):
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect(('localhost', 9966))

    client_socket.send(number.to_bytes(4, byteorder='big'))  # 发送一个4字节的整数
    client_socket.shutdown(socket.SHUT_WR)  # 关闭写入端，表明数据已经发送完毕

    client_socket.recv(1024)  # 字符串
    client_socket.close()

    result = get_latency(number)
    # print(result)
    return result
# -------------------------------------------------------------------------------------




# -------------------------------------------------------------------------------------
def launch_all_spinal_sim(numbers=None):
    # 启动所有实例的仿真
    thread_pool = [threading.Thread(target=launch_one_spinal_sim, args=(block_id,)) for block_id in range(NUM_BLOCKS)]
    for thread in thread_pool:
        thread.start()
    for thread in thread_pool:
        thread.join()
# -------------------------------------------------------------------------------------




# -------------------------------------------------------------------------------------
def get_latencies():
    # read the result back
    latency_list = []
    for i in range(NUM_BLOCKS):
        latency_list.append(int(open(f"{SPINAL_DIR}/latency/{i}.txt").read()))
    return latency_list


# -------------------------------------------------------------------------------------
def get_latency(block_id):
    return int(open(f"{SPINAL_DIR}/latency/{block_id}.txt").read())
# -------------------------------------------------------------------------------------


BRAM_WIDTH = 36  # 半个BRAM，S2P模式下，
BRAM_DEPTH = 512  # S2P


# -------------------------------------------------------------------------------------
def cal_block_bram_cost(depth_dict):
    total_brams = 0
    for _name in depth_dict.keys():
        _depth = depth_dict[_name]
        _width = WIDTH_DICT[_name]

        if _depth == SHALLOW_DEPTH:
            continue
        elif _depth == MEDIUM_DEPTH:
            num_luts = (_depth * _width) / 64
            total_brams += num_luts * 64 / (BRAM_DEPTH * BRAM_WIDTH)
        else:
            total_brams += ceil(_depth / BRAM_DEPTH) * ceil(_width / BRAM_WIDTH)

    return total_brams


# -------------------------------------------------------------------------------------
def cal_total_bram_cost(depth_dict):
    # 计算代价
    total_brams = 0
    for block_id in depth_dict.keys():
        total_brams += cal_block_bram_cost(block_id, depth_dict[block_id])
    return total_brams
# -------------------------------------------------------------------------------------
