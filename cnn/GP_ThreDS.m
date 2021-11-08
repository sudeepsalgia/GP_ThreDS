function [regret, t_elapsed, time_vec, time_function_evals] = GP_ThreDS(T, x)
    
    load('input_data.mat');

    global train_x;
    global train_y;
    global test_x;
    global test_y;
    global val_x;
    global val_y;
    
    train_x = training_imgs;
    train_y = training_labels;
    test_x = test_imgs;
    test_y = test_labels;
    val_x = validation_imgs;
    val_y = validation_labels;
    
    global grid_pts_4;
    global grid_pts_3;
    global grid_pts_6;
    
    grid_pts_4 = [-0.4999, -1/6, 1/6, 0.5];
    grid_pts_3 = [-0.4999,0,0.5];
    grid_pts_6 = linspace(-0.5,0.5, 6);
    grid_pts_6(1) = grid_pts_6(1) + 1e-4;

    l = 0.2;  
    noise_var = 0.0001;
    noise_sig = sqrt(noise_var);
    d = 5;
    
    curr_idxs = 1;
    if nargin < 2
        h_const = 5e4; 
        h_max = ceil(log2(h_const));
        x = x_sequence_nd(d, h_max);
    end
    len_x = size(x,2);
    
    regret = zeros(1, T);
    
    t = 0;
    epoch_ctr = 1;
    
    a = 0.3;
    b = 1.4;
    
    int_length = b - a;
    tau = (a + b)/2;

    time_vec = zeros(1, T);
    time_function_evals = zeros(1, T);
    
    t_main = tic;
    
    while t < T
    
        new_idxs = [];
        
        len_curr_idxs = length(curr_idxs);
        curr_idxs = curr_idxs(randperm(len_curr_idxs));
        
        
        for i = curr_idxs
            t_term = 8; 
            t_max = max(T - t, 0); 
            tree_loc_idxs = [i, 2*i + [0,1], 4*i + (0:3), 8*i + (0:7), 16*i + (0:15), 32*i + (0:31)]; 
            if max(tree_loc_idxs) > len_x
                regret((t + 1):end) = -0.99;
                t = T;
                break;
            end
            tree_loc = x(:, tree_loc_idxs);
            len = 2^(1-epoch_ctr);
            t_init = toc(t_main);
            [target_nodes, reg_ret, t_vec_RWT, time_f] = updated_local_test(x(:, i), len, tree_loc_idxs(32:63), tree_loc(:, 32:63), T, tau, noise_sig, l, t_term, t_max);
            new_idxs = [new_idxs, target_nodes];
            t_loc = length(reg_ret);
            regret((t+1):(t+t_loc)) = reg_ret;
            time_vec((t+1):(t+t_loc)) = t_init + t_vec_RWT;
            time_function_evals((t+1):(t+t_loc)) = time_f;
            t = t + t_loc;
            
            if time_vec(t) > 2500
                regret((t + 1):end) = -0.99;
                t = T;
                break;
            end
                
        end
        
        
        if isempty(new_idxs)
            shift = (b-a)/2;
            b = b - shift;
            a = a - shift;
            tau = (a + b)/2;
        else
            a = tau - 0.1*2^(-epoch_ctr)*int_length;
            tau = (a + b)/2;
            curr_idxs = new_idxs;
            epoch_ctr = epoch_ctr + 1;
        end
        
    end
    regret = regret + 0.99;
    t_elapsed = toc(t_main);
    
    regret = regret(1:T);
    time_vec = time_vec(1:T);
end