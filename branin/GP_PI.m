function [regret, time_elapsed, time_vec] = GP_PI(T)
    l = 0.2;
    noise_var = 0.01;
    noise_sig = sqrt(noise_var);
    n_init = 20;
    d = 2;
    
    eps = 0.0;
    
    x_grid = linspace(0,1,n_init);
    n_grid_pts = length(x_grid);
    
    regret = zeros(1, T);
    sample_pts = zeros(d,T);
    observations = zeros(1,T);
    
    sample_pt_x_idx = randi(n_grid_pts);
    sample_pt_y_idx = randi(n_grid_pts);
    
    max_so_far = 0;

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
        
        max_PI = 0;
        argmax_PI_x = 0;
        argmax_PI_y = 0;
        
        max_mu_new = 0;
        
        n_grid_pts = min(n_init + t, 80);
        x_grid = linspace(0,1,n_grid_pts); 
        
        for i = 1:n_grid_pts
            dx = sample_pts(1, 1:t) - x_grid(i);
            for j = 1:n_grid_pts
                dy = sample_pts(2, 1:t) - x_grid(j);
                k_vec = exp(-((dx.^2) + (dy.^2))/(2*l^2));
                mu_x = k_vec*inv_mat*observations(1:t)';
                sigma_x = sqrt(1 - k_vec*inv_mat*k_vec');

                imp = mu_x - max_so_far - eps;
                Z = imp/sigma_x;
                pi_x = normcdf(Z);
                
                if max_PI < pi_x
                    max_PI = pi_x;
                    argmax_PI_x = i;
                    argmax_PI_y = j;
                end
                
                if max_mu_new < mu_x
                    max_mu_new = mu_x;
                end
            end
        end
        
        sample_pt_x_idx = argmax_PI_x;
        sample_pt_y_idx = argmax_PI_y;
        
        max_so_far = max_mu_new;
    end
    
    regret = regret + 1.0474;
    time_elapsed = toc;
end