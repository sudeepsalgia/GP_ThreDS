function [regret, t_elapsed, time_vec, time_function_evals] = GP_adaptive_discretization(T, x)
    l = 0.2;
    noise_var = 0.0001;
    noise_sig = sqrt(noise_var);
    d = 5;
    
    curr_idxs = 1; 
    if nargin < 2
        h_max = ceil(log2(T));
        x = x_sequence_nd(d, h_max);
    end
    sample_pts = zeros(d,T);
    observations = zeros(1,T);
    regret = zeros(1, T);
    t = 1;

    time_vec = zeros(1, T);
    time_function_evals = zeros(1, T);
    
    tic;
    
    while t <= T
        if t == 1
            argmax_I = 1;
            to_update = 0;
        else
            data_pts = x(:, curr_idxs);
            par_idxs = floor(curr_idxs/2);
            par_idxs(par_idxs == 0) = 1;
            par_data_pts = x(:, par_idxs);
            h_vec = floor(log2(curr_idxs));
            [argmax_I, to_update] = find_maximizer(data_pts, observations(1:(t-1)), par_data_pts, sample_pts(:, 1:(t-1)), noise_var, h_vec, T, l);
        end
        node_idx = curr_idxs(argmax_I);
        if to_update && (2*node_idx < T)
            curr_idxs(argmax_I) = [];
            curr_idxs = [curr_idxs, 2*node_idx, 2*node_idx+1];
        else
            x_t = x(:, node_idx);
            x_t_actual = zeros(d, 1);
        
            x_t_actual(1) = 2^(2+ceil(x_t(1)*8));
            x_t_actual(2) = 2*(ceil(x_t(2)*4) - 1) + 3;
            x_t_actual(3) = 2*(ceil(x_t(3)*4) - 1) + 3;
            x_t_actual(4) = (9+ceil(x_t(4)*31));
            x_t_actual(5) = 10^(ceil(x_t(5)*6) - 7);

            [f_t, t_f] = f(x_t_actual);
            time_vec(t) = toc;
            time_function_evals(t) = t_f;
            regret(t) = - f_t;
            observations(t) = f_t + randn*noise_sig;
            sample_pts(:, t) = x_t;
            t = t + 1;
        end
    end
    
    regret = regret + 0.99;
    t_elapsed = toc;
    
end