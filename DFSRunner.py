from post_syn_process import *
import os
from copy import deepcopy
from constants import DEFAULT_DEPTH_DICT
import pickle
import colorama
import threading

TARGET_LATENCY = 57625


class DFSRunner:
    def __init__(self, cur_attn_id):
        self.attn_id = cur_attn_id
        # a list of (_name, _width)
        self.fifo2width = [(_name, WIDTH_DICT[_name]) for _name in RELATED_FIFOS]
        self.fifo2width.sort(key=lambda pair: pair[1], reverse=True)  # sort by width, from large to small
        self.related_fifo = [pair[0] for pair in self.fifo2width]
        # the related fifo is ordered
        print(f"Attn {self.attn_id:2d} related fifo:", self.related_fifo)
        self.history = set()

        # create the cache folder if it doesn't exist
        if not os.path.exists("search_cache"):
            os.mkdir("search_cache")

        # hot
        self.hot = False

        # decorate cache
        self.f = self.file_cache_decorator_for_class_method(f"search_cache/f_{self.attn_id}.pkl")(self.f)
        self.L = self.file_cache_decorator_for_class_method(f"search_cache/L_{self.attn_id}.pkl")(self.L)

        # record result
        self.best_xs = None
        self.best_L = None

        # sorted keys
        self.sorted_fifo_names = sorted(WIDTH_DICT.keys())

    def file_cache_decorator_for_class_method(self, file_name):
        # decorate one class method
        self.hot = True

        def decorator(func):
            def wrapper(*args, **kwargs):
                if not hasattr(wrapper, "cache"):
                    if os.path.exists(file_name):
                        with open(file_name, "rb") as f:
                            wrapper.cache = pickle.load(f)
                    else:
                        wrapper.cache = {}

                # statistics of sampling times
                if not hasattr(wrapper, "sampling_times"):
                    wrapper.sampling_times = 0
                wrapper.sampling_times += 1

                # self will not be included as an arg, this xs works for multiple variables
                if args not in wrapper.cache:
                    wrapper.cache[args] = func(*args, **kwargs)
                    # instantly save the cache, because the program can be interrupted at any time
                    with open(file_name, "wb") as f:
                        pickle.dump(wrapper.cache, f)
                return wrapper.cache[args]

            return wrapper

        return decorator

    def tuple_format(self, prefix, xs):
        # use 20 chars to print prefix
        print(f"Attn {self.attn_id:2d} {prefix:30}", end="")
        for x in xs:
            if x in DEPTH_COLOR_DICT.keys():
                c = DEPTH_COLOR_DICT[x]
                print(c + f"{x:7d}" + colorama.Style.RESET_ALL, end="")
            else:
                print(f"{x:7d}", end="")
        print()

    def f(self, all_depth):
        for (cache_x,), cache_y in self.f.cache.items():
            # two requirement
            # 1. history cannot satisfy TARGET_LATENCY
            # 2. current is worse than history
            if cache_y > TARGET_LATENCY and all(first <= second for first, second in zip(all_depth, cache_x)):
                return cache_y

        # Now f get all depth as input, therefore it can share cache with different "DONT_TOUCH" settings
        cur_depth_dict = {_k: _v for _k, _v in zip(self.sorted_fifo_names, all_depth)}
        to_spinal_one_block(ROOT_DIR + "/instances/", self.attn_id, cur_depth_dict)
        launch_one_spinal_sim(self.attn_id)
        latency = get_latency(self.attn_id)
        return latency

    def L(self, all_depth):
        cur_depth_dict = {_k: _v for _k, _v in zip(self.sorted_fifo_names, all_depth)}
        return cal_block_bram_cost(cur_depth_dict)

    def _helper(self, xs):
        # get related fifo depth, return all depth, including don't touch, and they are sorted by fifo names
        cur_depth_dict = deepcopy(DEFAULT_DEPTH_DICT)
        for _name, _depth in zip(self.related_fifo, xs):
            cur_depth_dict[_name] = _depth
        return tuple(cur_depth_dict[_key] for _key in self.sorted_fifo_names)

    def f_helper(self, xs):
        return self.f(self._helper(xs))

    def L_helper(self, xs):
        return self.L(self._helper(xs))

    def dfs(self, xs, depth):
        # xs is a tuple, containing the depth of each fifo until current depth
        assert len(xs) == depth
        self.tuple_format(f"Entering depth {depth}:", xs)

        # enumerate
        # start from smaller options
        for val in DEPTH_COLLECTION:

            new_xs = xs + (val,)

            # prune: if there are more than 4 MEDIUM_DEPTH, then prune
            if new_xs.count(MEDIUM_DEPTH) > 4:
                self.tuple_format("Pruned by MEDIUM:", new_xs)
                continue

            # prune: only at the last layer, do history based pruning
            # if depth == len(self.related_fifo):
            #     worse = False
            #     for history_xs in self.history:
            #         # if there's a better solution in history, then prune
            #         if all(x >= history_x for x, history_x in zip(xs, history_xs)):
            #             self.tuple_format("Pruned by history:", history_xs)
            #             worse = True
            #             break
            #     if worse:
            #         continue

            # even set all rest to shallow, the L is still larger than best_L, then prune
            if depth != len(self.related_fifo):
                L_trial = new_xs + (min(DEPTH_COLLECTION),) * (len(self.related_fifo) - depth - 1)
                L_trial_val = self.L_helper(L_trial)
                if L_trial_val >= self.best_L:
                    self.tuple_format(f"Pruned by L, {L_trial_val:.2f}>={self.best_L:.2f}", L_trial)
                    continue

            # even set all rest to max, the f is still larger than target_latency, then prune
            if depth != len(self.related_fifo):
                f_trial = new_xs + (max(DEPTH_COLLECTION),) * (len(self.related_fifo) - depth - 1)
                if self.f_helper(f_trial) > TARGET_LATENCY:
                    self.tuple_format("Pruned by f:", f_trial)
                    # continue
                    break
                    # use break! instead of continue

            # at last layer, do the final check
            if depth == len(self.related_fifo):
                current_f = self.f_helper(xs)
                current_L = self.L_helper(xs)
                if current_f <= TARGET_LATENCY and current_L < self.best_L:
                    self.best_L = current_L
                    self.best_xs = xs

                    print("*" * 80)
                    print("Found a better solution:")
                    print("Best L value:", self.best_L)
                    print("Current f:", current_f)
                    print("Current L:", current_L)
                    self.pretty_print(self.best_xs)
                    print("*" * 80)

                    self.history.add(xs)

            else:
                self.dfs(xs + (val,), depth + 1)

    def pretty_print(self, best_xs):
        print("*" * 80)
        self.tuple_format("Best x values:", self.best_xs)
        self.tuple_format("Related fifo width:", [WIDTH_DICT[_name] for _name in self.related_fifo])
        for _name in WIDTH_DICT.keys():
            if _name in self.related_fifo:
                _depth = self.best_xs[self.related_fifo.index(_name)]
                c = DEPTH_COLOR_DICT[_depth]
                print(c + f"{_name:20s}: width={WIDTH_DICT[_name]:7d}, depth={_depth:7d}" + colorama.Style.RESET_ALL)
            else:
                _depth = DEFAULT_DEPTH_DICT[_name]
                print(f"{_name:20s}: width={WIDTH_DICT[_name]:7d}, depth={_depth:7d}")
        print("*" * 80)
        print()

    def run(self):
        try:
            xs = tuple()
            self.best_L = float("inf")
            self.best_xs = tuple()
            self.dfs(xs, 0)
        except KeyboardInterrupt:
            print("KeyboardInterrupt")
        finally:
            self.pretty_print(self.best_xs)

    # def random_sampling_f(self):


def run_all():
    runners = [DFSRunner(cur_attn_id=cur_attn_id) for cur_attn_id in range(1)]
    threads = [threading.Thread(target=runner.run, args=()) for runner in runners]

    try:
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
    except KeyboardInterrupt:
        print("KeyboardInterrupt")
        exit(0)

    # print first line
    print(" " * 80)
    _names = UNIQUE_DEPTH_DICT.keys()
    print(f"{' ':10s}", end="")
    print("".join([f"{_name[:-11] + '|':10s}" for _name in _names]), end='')
    print(f"{'cost':10s}")
    # print lines
    for runner in runners:
        print(f"Attn {runner.attn_id:2d} ", end="")
        for _name in _names:
            if _name in runner.related_fifo:
                _depth = runner.best_xs[runner.related_fifo.index(_name)]
                c = DEPTH_COLOR_DICT[_depth]
                print(c + f"{_depth:9d}" + "|" + colorama.Style.RESET_ALL, end="")
            else:
                _depth = DEFAULT_DEPTH_DICT[_name]
                print(f"{_depth:9d}" + "|" + colorama.Style.RESET_ALL, end="")
        print(f"{runner.best_L: 10.2f}", end="")
        print()

    # save the result to numpy, with a dict
    # one is fifo depth
    # one is fifo width
    # _depth_matrix = np.zeros(len(_names))
    # fifo_width_matrix = np.zeros(len(_names))
    #
    # for runner in runners:
    #     for _name in _names:
    #         if _name in runner.related_fifo:
    #             _depth_matrix[list(_names).index(_name)] = runner.best_xs[runner.related_fifo.index(_name)]
    #             fifo_width_matrix[list(_names).index(_name)] = WIDTH_DICT[_name]
    #         else:
    #             _depth_matrix[list(_names).index(_name)] = 0
    #             fifo_width_matrix[list(_names).index(_name)] = WIDTH_DICT[_name]
    #
    # np.save("_depth_matrix.npy", _depth_matrix)
    # np.save("fifo_width_matrix.npy", fifo_width_matrix)


def run_one(cur_attn_id):
    runner = DFSRunner(cur_attn_id)
    runner.run()
    # print(f"Attn {runner.attn_id:2d} sampling times: {runner.f.sampling_times}")


if __name__ == "__main__":
    run_all()
    # run_one(7)
