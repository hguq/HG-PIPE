import numpy as np

# read in "behavior_type_dict.npy"
d = np.load("behavior_type_dict.npy", allow_pickle=True).item()
for name, (sign_type, bit_width) in d.items():
    # format with 20 spaces
    print(f"    {name:30} {sign_type:10} {bit_width:10}")