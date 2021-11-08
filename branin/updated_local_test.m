function [target_nodes, reg_ret, time_vec] = updated_local_test(n_pts, mid_pt, len, child_idxs, child_pts, T, tau, noise_sig, l, t_term, t_max)
    target_nodes = [];
    noise_var = noise_sig^2;
    
    d = length(mid_pt);
    x0_grid = linspace(-0.5,0.5, n_pts);
    grid_matrix = repmat(x0_grid, [d, 1])*len + repmat(mid_pt, [1, n_pts]);
    grid_vec = grid_matrix';
    grid_vec = grid_vec(:);
    
    samp_idx_t = ceil(n_pts/2)*ones(1, d);
    vec_init_size = min(1000, t_term);
    regret = zeros(1, vec_init_size);
    observations = zeros(1, vec_init_size);
    sample_pts = zeros(d, vec_init_size);
    time_vec = zeros(1, vec_init_size);
    
   	n_child = size(child_pts, 2);
    
    t = 1;
    B = 0.5;
    tot_pts = n_pts^d;
    terminate = t_term < t;
    t_loc = 1;
    
    curr_time = 0;
    tic;
    
    while ~terminate && (curr_time < 100)
        sample_pt = grid_vec(n_pts*(0:(d-1)) + samp_idx_t);
        y_t = f(sample_pt) + randn*noise_sig;
        curr_time = toc;
        time_vec(t) = curr_time;
        regret(t) = - f(sample_pt);
        observations(t) = y_t;
        sample_pts(:, t) = sample_pt;
        
        diff_x_sq = 0;
        for i = 1:d
            diff_x = repmat(sample_pts(i, 1:t), [t, 1]);
            diff_x_sq = diff_x_sq + (diff_x - diff_x').^2;
        end
        
        K = exp(-diff_x_sq/(2*l^2));
        inv_mat = inv(K + noise_var*eye(t));
        
        max_p = 0;
        max_m = 0;
        
        max_UCB = 0;
        argmax_UCB = 0;
        argmax_node_idx = 0;
        max_m_node_idx = 0;
        
        T_0 = 1000;
        beta_T = B + noise_sig*sqrt(2*((log(t)) + 1 + log(T_0)));
        
        for i = 1:tot_pts
            pt_idx = zeros(1, d);
            i_loc = i;
            for j = 1:d
                rem = mod(i_loc, n_pts);
                pt_idx(d + 1 - j) = rem + 1;
                i_loc = (i_loc - rem)/n_pts;
            end
            check_pt = grid_vec(n_pts*(0:(d-1)) + pt_idx);
            distances = max(abs(child_pts - repmat(check_pt, [1, n_child])));
            [~, min_child_idx] = min(distances);
            curr_node_idx = child_idxs(min_child_idx);

            if isempty(find(target_nodes == curr_node_idx, 1))
                
                diff_pts = sample_pts(:, 1:t) - repmat(check_pt, [1,t]);
                k_vec = exp(-sum(diff_pts.^2)/(2*l^2));

                mu_x = k_vec*inv_mat*observations(1:t)';
                sigma_x = sqrt(1 - k_vec*inv_mat*k_vec');

                plus_val = mu_x + beta_T*sigma_x;
                minus_val = mu_x - beta_T*sigma_x;

                UCB = mu_x + beta_T*sigma_x;

                if max_p < plus_val
                    max_p = plus_val;
                end
                if max_m < minus_val
                    max_m = minus_val;
                    max_m_node_idx = curr_node_idx;
                end
                 if max_UCB < UCB
                    max_UCB = UCB;
                    argmax_UCB = pt_idx;
                    argmax_node_idx = curr_node_idx;
                 end
            end
        end
    
        if max_p < tau - 0.2*len
            terminate = 1;
        elseif max_m > tau
            target_nodes = [target_nodes, max_m_node_idx];
            t_loc = 0;
        elseif t_loc == t_term
            target_nodes = [target_nodes, max_m_node_idx];
            t_loc = 0;
        end
        
        samp_idx_t = argmax_UCB;
        t = t +1;
        t_loc = t_loc + 1;
        
        if t > t_max
            terminate = 1;
        end
    end
    
    if t_term > 0
        reg_ret = regret(1:t-1);
        time_vec = time_vec(1:t-1);
    else
        reg_ret = [];
        time_vec = [];
    end
    
   
end