# Multi_UAV_Mobile_Edge_Computing
Aerial drones (UAVs) have long been utilized in mobile networks as network processors, but they are now being employed as mobile servers in Mobile Edge Computing (MEC). Because of their flexibility, portability, strong line-ofsight communication linkages and low-cost, changeable use, they have become more popular in research and commercial applications. A wide range of civilian services may now be supported by their essential characteristics, including transportation and industrial monitoring and agricultural, as well as forest fire and wireless services. Mobile edge computing networks based on Unmanned Aerial Vehicles are researched in this project,on where the unmanned aerial vehicle (UAV) does computations that mobile terminal users supply to it. (TUs). In order to assure each TU’s Quality-of-service (QoS), the UAV dynamically selects its course based on mobile TUs’ locations.


# This is the source code of 'Multi-UAV Mobile Edge Computing and Path Planning Platform based on Reinforcement Learning'

To Run the code use following steps:
1. For a single run, use main.m

**main.m** is the main entrance of the program, which automatically plots and saves figures.

2. For batch runs. use main_loop.m

**main_loop.m** is used to loop with for getting batch data, in which parameters can be set to a series of values to examine their influence on the results. For example, K_list=[5], M_list=[0.01, 0.02]

main_loop.m automatically outputs a form recording the results.

All other scripts and functions are called in these two scripts.
