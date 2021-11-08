function [regret, t_elapsed, time_vec] = GP_ThreDS(T)
    l = 0.2;  
    noise_var = 0.01;
    noise_sig = sqrt(noise_var);
    
    curr_idxs = 1;
    h_const = 5e5; 
    h_max = ceil(log2(h_const));
    x = x_sequence_2D(h_max);
    len_x = size(x,2);
    init_pt_vec = x;
    
    regret = zeros(1, T);
    t_term_0 = 20;
    
    t = 0;
    epoch_ctr = 1;
    
    a = 0.5;
    b = 1.2;
    
    int_length = b - a;
    tau = (a + b)/2;

    time_vec = zeros(1, T);
    
    t_main = tic;
    
    while t < T
    
        new_idxs = [];
        
        
        for i = curr_idxs
            t_term = 50; 
            t_max = T-t;  
            tree_loc_idxs = [i, 2*i, 2*i + 1, 4*i, 4*i + 1, 4*i + 2, 4*i + 3];
            if max(tree_loc_idxs) > len_x
                regret((t + 1):end) = -1.0474;
                t = T;
                break;
            end
            tree_loc = x(:, tree_loc_idxs);
            len = 2^(1-epoch_ctr);
            t_init = toc(t_main);
            [target_nodes, reg_ret, t_vec_RWT] = updated_local_test(20, x(:, i), len, tree_loc_idxs(4:7), tree_loc(:, 4:7), T, tau, noise_sig, l, t_term, t_max);
            new_idxs = [new_idxs, target_nodes];
            t_loc = length(reg_ret);
            regret((t+1):(t+t_loc)) = reg_ret;
            time_vec((t+1):(t+t_loc)) = t_init + t_vec_RWT;
            t = t + t_loc;
            
            if time_vec(t) > 100
                regret((t + 1):end) = -1.0474;
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
            a = tau - 0.4*2^(-epoch_ctr)*int_length;
            tau = (a + b)/2;
            curr_idxs = new_idxs;
            epoch_ctr = epoch_ctr + 1;
        end
        
    end
    regret = regret + 1.0474;
    t_elapsed = toc(t_main);
    
    regret = regret(1:T);
    time_vec = time_vec(1:T);
end