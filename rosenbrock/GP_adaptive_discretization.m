function [regret, t_elapsed, time_vec] = GP_adaptive_discretization(T)
    l = 0.2;
    noise_var = 0.01;
    
    h_max = ceil(log2(T));
    curr_idxs = 1;
    x = x_sequence_2D(h_max);
    sample_pts = zeros(2,T);
    observations = zeros(1,T);
    regret = zeros(1, T);
    t = 1;

    time_vec = zeros(1, T);
    
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
            y = f(x_t) + randn*sqrt(noise_var);
            time_vec(t) = toc;
            sample_pts(:, t) = x_t;
            regret(t) = - f(x_t);
            observations(t) = y;
            t = t + 1;
        end
    end
    
    regret = regret + 10;
    t_elapsed = toc;
    
end