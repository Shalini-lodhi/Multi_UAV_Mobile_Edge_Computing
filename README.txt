This is the source code of 'Multi-UAV Mobile Edge Computing and Path Planning Platform based on Reinforcement Learning'

1. For a single run, use main.m

main.m is the main entrance of the program, which automatically plots and saves figures.

2. For batch runs. use main_loop.m

main_loop.m is used to loop with for getting batch data, in which parameters can be set to a series of values to examine their influence on the results. For example, K_list=[5], M_list=[0.01, 0.02]

main_loop.m automatically outputs a form recording the results.

All other scripts and functions are called in these two scripts.