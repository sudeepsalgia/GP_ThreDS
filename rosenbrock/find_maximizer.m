function [argmax_I, to_update] = find_maximizer(data_pts, y, par_data_pts, sample_pts, noise_var, h_vec, T, l)
    n_data_pts = size(data_pts, 2);
    n_samp_pts = size(sample_pts, 2);
    d = 2;
    
    diff_x_sq = 0;
    for i = 1:d
        diff_x = repmat(sample_pts(i, :), [n_samp_pts, 1]);
        diff_x_sq = diff_x_sq + (diff_x - diff_x').^2;
    end
    K = exp(-diff_x_sq/(2*l^2));
    inv_mat = inv(K + noise_var*eye(n_samp_pts));
    
    C_1 = 2;
    C_2 = 2*log(2*C_1^2*pi^2/6);
    C_3 = 1 + 2.7*sqrt(2*log(2));
    C_4 = C_2 + 2*log(T^2*pi^2/6);
    
    h_max = log2(T);
    beta = sqrt(2*(2 + log(T*h_max) + d*h_max*log(2) + log(2)));
    c_v = 4;
    
    max_I = 0;
    argmax_I = 0;
    
    to_update = 0;
    
    for i = 1:n_data_pts
        dx = sample_pts(1, :) - data_pts(1, i);
        dy = sample_pts(2, :) - data_pts(2, i);
        k_vec = exp(-((dx.^2) + (dy.^2))/(2*l^2));
        h = h_vec(i);
        mu_x = k_vec*inv_mat*y';
        sigma_x = sqrt(1 - k_vec*inv_mat*k_vec');
        V_h = c_v*2^(-h/d)*(sqrt(4 + C_4 + h*log(2) + 4*d*log(2^(h/d)/l)) + C_3);
        
        dx = sample_pts(1, :) - par_data_pts(1, i);
        dy = sample_pts(2, :) - par_data_pts(2, i);
        k_vec = exp(-((dx.^2) + (dy.^2))/(2*l^2));
        h_par = max(h_vec(i)-1, 1);
        mu_x_par = k_vec*inv_mat*y';
        sigma_x_par = sqrt(1 - k_vec*inv_mat*k_vec');
        V_h_par = c_v*2^(-h_par/d)*(sqrt(4 + C_4 + h_par*log(2) + 4*d*log(2^(h_par/d)/l)) + C_3);
        
        
        I = min(mu_x + beta*sigma_x, mu_x_par + beta*sigma_x_par + V_h_par ) + V_h;
        if I > max_I
            max_I = I;
            argmax_I = i;
            if beta*sigma_x <= V_h
                to_update = 1;
            else
                to_update = 0;
            end
        end
    end
end