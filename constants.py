from copy import deepcopy
import os
import colorama

# current dir
ROOT_DIR = os.getcwd()

# some global settings
SPINAL_DIR = os.path.join(ROOT_DIR, "SPINAL")

# number of blocks
NUM_BLOCKS = 24  # 24 blocks in DeiT-Tiny, 12 Attention blocks and 12 MLP blocks

# three options
URAM_DEPTH = 4096
URAM2_DEPTH = URAM_DEPTH * 2
URAM4_DEPTH = URAM_DEPTH * 4
DEEP_DEPTH = 512
MEDIUM_DEPTH = 64
SHALLOW_DEPTH = 2

# map depth to colorama
DEPTH_COLOR_DICT = {
    URAM4_DEPTH: colorama.Fore.BLACK,
    URAM2_DEPTH: colorama.Fore.BLACK,
    URAM_DEPTH: colorama.Fore.CYAN,
    DEEP_DEPTH: colorama.Fore.RED,
    MEDIUM_DEPTH: colorama.Fore.YELLOW,
    SHALLOW_DEPTH: colorama.Fore.GREEN
}

DEPTH_COLLECTION = [URAM2_DEPTH, DEEP_DEPTH, MEDIUM_DEPTH, SHALLOW_DEPTH]
# DEPTH_COLLECTION = [URAM2_DEPTH, SHALLOW_DEPTH]

FIFO_NAMES = [
    "Q_ADPT",
    "Q_WIND",
    "Q_WGHT",
    "Q_MACS",

    "K_ADPT",
    "K_WIND",
    "K_WGHT",
    "K_MACS",

    "V_ADPT",
    "V_WIND",
    "V_WGHT",
    "V_MACS",

    "QK_MATMUL_ADPT",
    "QK_MATMUL_WIND",
    "QK_MATMUL_WGHT",
    "QK_MATMUL_MACS",

    "RV_MATMUL_ADPT",
    "RV_MATMUL_WIND",
    "RV_MATMUL_WGHT",
    "RV_MATMUL_MACS",

    "O_MATMUL_ADPT",
    "O_MATMUL_WIND",
    "O_MATMUL_WGHT",
    "O_MATMUL_MACS",

    "MAIN",
    "RESI_I",
    "RESI",
    "RESI_O",
    "LNQ",
    "LNQ_CP",
    "Q",
    "K",
    "V",
    "QQ",
    "KQ",
    "VQ",
    "QQ_HEAD",
    "KQ_HEAD",
    "VQ_HEAD",
    "R_HEAD",
    "RQ_HEAD",
    "KQ_RESHAPE_HEAD",
    "VQ_TRANSPOSE_HEAD",
    "A_HEAD",
    "A",
    "AQ",
    "O"
]

# unique depth
UNIQUE_DEPTH_DICT = {fifo_name: 16000 + ind for ind, fifo_name in enumerate(FIFO_NAMES)}
UNIQUE_DEPTH_DICT_REV = {v: k for k, v in UNIQUE_DEPTH_DICT.items()}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# the default setting: only residual deep, others shallow
# the "DONT_TOUCH" is listed here
DEFAULT_DEPTH_DICT = dict()
DEFAULT_DEPTH_DICT["Q_ADPT"]                = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["Q_WIND"]                = SHALLOW_DEPTH
# DEFAULT_DEPTH_DICT["Q_WGHT"]              = SHALLOW_DEPTH # no such fifo
DEFAULT_DEPTH_DICT["Q_MACS"]                = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["K_ADPT"]                = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["K_WIND"]                = SHALLOW_DEPTH
# DEFAULT_DEPTH_DICT["K_WGHT"]              = SHALLOW_DEPTH # no such fifo
DEFAULT_DEPTH_DICT["K_MACS"]                = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["V_ADPT"]                = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["V_WIND"]                = SHALLOW_DEPTH
# DEFAULT_DEPTH_DICT["V_WGHT"]              = SHALLOW_DEPTH # no such fifo
DEFAULT_DEPTH_DICT["V_MACS"]                = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["QK_MATMUL_ADPT"]        = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["QK_MATMUL_WIND"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["QK_MATMUL_WGHT"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["QK_MATMUL_MACS"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["RV_MATMUL_ADPT"]        = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["RV_MATMUL_WIND"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["RV_MATMUL_WGHT"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["RV_MATMUL_MACS"]        = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["O_MATMUL_ADPT"]         = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["O_MATMUL_WIND"]         = SHALLOW_DEPTH
# DEFAULT_DEPTH_DICT["O_MATMUL_WGHT"]       = SHALLOW_DEPTH # no such fifo
DEFAULT_DEPTH_DICT["O_MATMUL_MACS"]         = SHALLOW_DEPTH

DEFAULT_DEPTH_DICT["MAIN"]                  = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["RESI_I"]                = DEEP_DEPTH
DEFAULT_DEPTH_DICT["RESI"]                  = URAM2_DEPTH + URAM_DEPTH
DEFAULT_DEPTH_DICT["RESI_O"]                = DEEP_DEPTH
DEFAULT_DEPTH_DICT["LNQ"]                   = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["LNQ_CP"]                = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["Q"]                     = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["K"]                     = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["V"]                     = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["QQ"]                    = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["KQ"]                    = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["VQ"]                    = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["QQ_HEAD"]               = URAM2_DEPTH
DEFAULT_DEPTH_DICT["KQ_HEAD"]               = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["VQ_HEAD"]               = MEDIUM_DEPTH
# DEFAULT_DEPTH_DICT["R_HEAD"]              = DEEP_DEPTH    # searched result
# DEFAULT_DEPTH_DICT["RQ_HEAD"]             = DEEP_DEPTH
# DEFAULT_DEPTH_DICT["KQ_RESHAPE_HEAD"]     = DEEP_DEPTH
DEFAULT_DEPTH_DICT["VQ_TRANSPOSE_HEAD"]     = DEEP_DEPTH
DEFAULT_DEPTH_DICT["A_HEAD"]                = MEDIUM_DEPTH
DEFAULT_DEPTH_DICT["A"]                     = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["AQ"]                    = SHALLOW_DEPTH
DEFAULT_DEPTH_DICT["O"]                     = SHALLOW_DEPTH

# NOTE: the entries that are not commented will be searched

# check, each key must be in UNIQUE_DEPTH_DICT.keys()
for k in DEFAULT_DEPTH_DICT.keys():
    if k not in UNIQUE_DEPTH_DICT.keys():
        raise ValueError(f"key {k} not in UNIQUE_DEPTH_DICT.keys()")

# the above listed FIFOs shouldn't be touched
DONT_TOUCH_FIFO = list(DEFAULT_DEPTH_DICT.keys())

# fill the rest
for k in UNIQUE_DEPTH_DICT.keys():
    if k not in DEFAULT_DEPTH_DICT.keys():
        DEFAULT_DEPTH_DICT[k] = SHALLOW_DEPTH
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# shallow
SHALLOW_DEPTH_DICT = deepcopy(DEFAULT_DEPTH_DICT)

# deep
DEEP_DEPTH_DICT = deepcopy(DEFAULT_DEPTH_DICT)
for fifo_name, fifo_depth in DEEP_DEPTH_DICT.items():
    if fifo_depth == SHALLOW_DEPTH:
        DEEP_DEPTH_DICT[fifo_name] = URAM4_DEPTH

# optimal
OPTIMAL_DEPTH_DICT = deepcopy(DEFAULT_DEPTH_DICT)
# currently not determined
OPTIMAL_DEPTH_DICT["R_HEAD"] = DEEP_DEPTH
OPTIMAL_DEPTH_DICT["RQ_HEAD"] = DEEP_DEPTH
OPTIMAL_DEPTH_DICT["KQ_RESHAPE_HEAD"] = DEEP_DEPTH
