## A Domain-Shrinking based Bayesian Optimization Algorithm with Order-Optimal Regret Performance

This repository is the official implementation of the experiments in the paper **A Domain-Shrinking based Bayesian Optimization Algorithm with Order-Optimal Regret Performance** published in NeurIPS 2021. A preprint of the paper can be found [here](https://arxiv.org/abs/2010.13997).



Matlab 2019a is used for the experiments. The repository contains several folders. Each folder contains a mat file titled 'all_alg_res.mat' along with several matlab codes. The hyperparameters for all the functions are set to the values described in the paper. Below is a description of the files in each folder. 



## Branin and Rosenbrock Folder 

* The files with the name of different algorithms correspond to the code for the respective algorithms. If you want to run one iteration of any algorithm, you can simply call the respective function with the time horizon 'T' as the argument.

* The files with the name 'get_alg_regret.m' where 'alg' corresponds to one of the five algorithms allows to run several Monte Carlo runs of the the corresponding algorithm. It takes two arguments, 'n_loops', the number of Monte Carlo runs and 'T', the time horizon. It returns two n_loops x T matrices. In the first one, each row corresponds to the regret in each run while in the second, each row corresponds to the time elapsed since the beginning after taking each sample.

* The 'plot_curves.m' file can be used to obtain the plots presented in the paper. It takes a boolean argument, which controls whether to display the error bars or not. The default value is set to True. It can also be used to plot the curves for different results by loading a different mat file with the required regret-time matrices and updating the variable 'n_loops', if required.

* The 'all_alg_res.mat' contains all the final results which are used for plotting.

* 'plot_branin.m' and 'plot_rosenbrock.m' can be used to visualize these functions. All other matlab code are helper files.

* Example commands: 

  1. To run IGP-UCB for 1000 time steps

     ~~~~matlab
     [regret, time_elapsed, time_vec] = IGP_UCB(1000);
     ~~~~

  2. To obtain 10 Monte-Carlo runs of GP-ThreDS for 2000 time steps.

     ~~~~matlab
     [regret, time_taken_vector] = get_GP_ThreDS_regret(10, 2000);
     ~~~~

  3. To plot the curves in the paper with error bars

     ~~~~matlab
     plot_curves(1);
     ~~~~

## CNN Folder

The instructions for the task of CNN hyperparameter tuning are almost the same as for the synthetic functions with a couple of minor differences. 

* The functions for GP_adaptive_discretization and GP_ThreDS, take an additional argument x, which corresponds to the binary tree used by the algorithm, with each node represented by its center point. This tree can be obtained by calling the function 'x_sequence_nd.m' with arguments d=5 (the dimension) and 'h_max', the maximum height. For the simulations in the paper, we have used the following commands to obtain the trees x_AD (for adaptive discretization) and x_GPTDS (for GP-ThreDS).

  ~~~~matlab
  x_AD = x_sequence_nd(5, ceil(log2(8000)));
  
  x_GPTDS = x_sequence_nd(5, ceil(log2(5e5)));
  ~~~~

  The value of h_max depends on the length of the time horizon as well.

* The files 'get_alg_regret.m' return three values in the case of CNN instead of two. The third is also a n_loops x T matrix whose each entry corresponds to the time taken to train the CNN corresponding to that iteration and sample index. This is helpful to differentiate the _optimization time_ from the _total time_.

* The cnn folder does not have a code to plot the function.

* Example commands: 

  1. To run GP-PI for 50 time steps

     ~~~~matlab
     [regret, time_elapsed, time_vec, time_function_evals] = GP_PI(50);
     ~~~~

  2. To obtain 10 Monte-Carlo runs of Adaptive Discretiztaion for 200 time steps.

     ~~~~matlab
     x_AD = x_sequence_nd(5, ceil(log2(8000)));
     [regret, time_taken_vector, time_function_evals_vector] = get_AD_regret(10, 200, x_AD);
     ~~~~

  3. To plot the curves in the paper without error bars

     ~~~~matlab
     plot_curves(0);
     ~~~~

  

