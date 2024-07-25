# read one .bin file, it is all int64, conver it to numpy array
import numpy as np
import os

def bin2txt(bin_file, txt_file):
    with open(bin_file, "rb") as f:
        data = np.fromfile(f, dtype=np.int64).reshape(-1, 1)
    np.savetxt(txt_file, data, fmt="%d", newline=",")


src_dir = "binaries/batchsize1/"
tgt_dir = "case/"


for typ in ["refs"]:
    abs_src_file_list = [os.path.join(src_dir, typ, f) for f in os.listdir(os.path.join(src_dir, typ))]
    abs_tgt_file_list = [os.path.join(tgt_dir, typ, f.split(".")[0] + ".txt") for f in os.listdir(os.path.join(src_dir, typ))]
    print(abs_src_file_list)
    print(abs_tgt_file_list)

    os.makedirs(os.path.join(tgt_dir, typ), exist_ok=True)

    for src_file, tgt_file in zip(abs_src_file_list, abs_tgt_file_list):
        bin2txt(src_file, tgt_file)
    

