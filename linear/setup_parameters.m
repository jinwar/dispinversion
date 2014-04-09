% setup for grid search
parameters.sedh = [2 4];
parameters.sedv = [2.5];
parameters.crusth_ratio = [1.0];
parameters.crustv = [3.4 3.5 3.6];
parameters.mantlev = [4.1 4.3 4.5 4.7];

% setup for monte carlo inversion

parameters.testN = 100;
parameters.crusth_var = 5;
parameters.sedh_var = 1;
parameters.velocity_var = 0.1;
parameters.r = 0.2;

parameters.sedlayernum = 1;
parameters.crustlayernum = 4;
parameters.mantle_layer_thickness = [10*ones(1,10)];
parameters.vpvs = 1.8;

% setup for model space
parameters.depth_nodes = 0:0.1:100;
parameters.vec_nodes = 1.5:0.03:5;

lalim = [-11.2 -7.8];
lolim = [148.8 151.5];

