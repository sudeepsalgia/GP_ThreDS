function [regret, time_elapsed, time_vec] = IGP_UCB(T)
    l = 0.2;
    noise_var = 0.01;
    noise_sig = sqrt(noise_var);
    n_init = 20;
    d = 2;
    
    B = 0.5;
    
    x_grid = linspace(0,1,n_init);
    n_grid_pts = length(x_grid);
    
    regret = zeros(1, T);
    sample_pts = zeros(d,T);
    observations = zeros(1,T);
    
    sample_pt_x_idx = randi(n_grid_pts);
    sample_pt_y_idx = randi(n_grid_pts);

    time_vec = zeros(1, T);
    tic;
    
    for t = 1:T
        sample_pt = [x_grid(sample_pt_x_idx); x_grid(sample_pt_y_idx)];
        y_t = f(sample_pt) + randn*noise_sig;
        time_vec(t) = toc;
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
        
        max_UCB = 0;
        argmax_UCB_x = 0;
        argmax_UCB_y = 0;
        
        T_0 = 1000;
        beta_t = B + noise_sig*sqrt(2*(log(t) + 1 + log(T_0)));
        
        n_grid_pts = min(n_init + t, 80);
        x_grid = linspace(0,1,n_grid_pts); 
        
        for i = 1:n_grid_pts
            dx = sample_pts(1, 1:t) - x_grid(i);
            for j = 1:n_grid_pts
                dy = sample_pts(2, 1:t) - x_grid(j);
                k_vec = exp(-((dx.^2) + (dy.^2))/(2*l^2));
                mu_x = k_vec*inv_mat*observations(1:t)';
                sigma_x = sqrt(1 - k_vec*inv_mat*k_vec');

                plus_val = mu_x + beta_t*sigma_x;

                if max_UCB < plus_val
                    max_UCB = plus_val;
                    argmax_UCB_x = i;
                    argmax_UCB_y = j;
                end
            end
        end
        
        sample_pt_x_idx = argmax_UCB_x;
        sample_pt_y_idx = argmax_UCB_y;
    end
    
    regret = regret + 1.0474;
    time_elapsed = toc;
end