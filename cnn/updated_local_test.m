function [target_nodes, reg_ret, time_vec, time_function_evals] = updated_local_test(mid_pt, len, child_idxs, child_pts, T, tau, noise_sig, l, t_term, t_max)
    target_nodes = [];
    noise_var = noise_sig^2;
    
    d = 5;
   
    global grid_pts_4;
    global grid_pts_6;
    
    grid_1 = grid_pts_4*len + mid_pt(1);
    grid_2 = grid_pts_4*len + mid_pt(2);
    grid_3 = grid_pts_4*len + mid_pt(3);
    grid_4 = grid_pts_4*len + mid_pt(4);
    grid_5 = grid_pts_6*len + mid_pt(5);
    
    samp_idx_t = [3,2,2,3,5]; 
    vec_init_size = min(200, t_max);
    regret = zeros(1, vec_init_size);
    observations = zeros(1, vec_init_size);
    sample_pts = zeros(d, vec_init_size);
    time_vec = zeros(1, vec_init_size);
    time_function_evals = zeros(1, vec_init_size);
    
   	n_child = size(child_pts, 2);
    
    t = 1;
    B = 0.5;
    terminate = t_max < t;
    t_loc = 1;
    
    curr_time = 0;
    tic;
    
    while ~terminate && (curr_time < 2500)
        sample_pt = [grid_1(samp_idx_t(1)), grid_2(samp_idx_t(2)), grid_3(samp_idx_t(3)), grid_4(samp_idx_t(4)), grid_5(samp_idx_t(5))];
        sample_pt_actual = zeros(d, 1);
        
        sample_pt_actual(1) = 2^(2+ceil(sample_pt(1)*8));
        sample_pt_actual(2) = 2*(ceil(sample_pt(2)*4) - 1) + 3;
        sample_pt_actual(3) = 2*(ceil(sample_pt(3)*4) - 1) + 3;
        sample_pt_actual(4) = (9+ceil(sample_pt(4)*31));
        sample_pt_actual(5) = 10^(ceil(sample_pt(5)*6) - 7);
        
        [f_t, t_f] = f(sample_pt_actual);
        curr_time = toc;
        time_vec(t) = curr_time;
        time_function_evals(t) = t_f;
        regret(t) = - f_t;
        observations(t) = f_t + randn*noise_sig;
        sample_pts(:, t) = sample_pt;
        
        diff_x_sq = 0;
        diff_x_abs = 0;
        for i = 1:d
            diff_x = repmat(sample_pts(i, 1:t), [t, 1]);
            diff_x_sq = diff_x_sq + (diff_x - diff_x').^2;
            diff_x_abs = diff_x_abs + abs(diff_x - diff_x');
        end
        
        K = (1 + sqrt(5)*diff_x_abs/l + 5*diff_x_sq/(3*l^2)).*exp(-sqrt(5)*diff_x_abs/l);
        
        inv_mat = inv(K + noise_var*eye(t));
        
        max_p = 0;
        max_m = 0;
        
        max_UCB = 0;
        argmax_UCB = 0;
        argmax_node_idx = 0;
        max_m_node_idx = 0;
        
        T_0 = 50;
        beta_T = B + noise_sig*sqrt(2*((sqrt(t)) + 1 + log(T_0)));
        
        for n1 = 1:4
            for n2 = 1:4
                for n3 = 1:4
                    for n4 = 1:4
                        for n5 = 1:6
                            check_pt = [grid_1(n1); grid_2(n2); grid_3(n3); grid_4(n4); grid_5(n5)];
                            distances = max(abs(child_pts - repmat(check_pt, [1, n_child])));
                            [~, min_child_idx] = min(distances);
                            curr_node_idx = child_idxs(min_child_idx);
                            
                            if isempty(find(target_nodes == curr_node_idx, 1))
                
                                diff_pts = sample_pts(:, 1:t) - repmat(check_pt, [1,t]);
                            
                                k_vec = (1 + sqrt(5)*sum(abs(diff_pts))/l + 5*sum(diff_pts.^2)/(3*l^2)).*exp(-sqrt(5)*sum(abs(diff_pts))/l);

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
                                   argmax_UCB = [n1,n2,n3,n4,n5];
                                   argmax_node_idx = curr_node_idx;
                                end
                            end
                        end
                    end
                end
            end
        end
    
        if max_p < tau - 0.1*len
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
        time_function_evals = time_function_evals(1:t-1);
    else
        reg_ret = [];
        time_vec = [];
        time_function_evals = [];
    end
    
   
end