function [regret, time_elapsed, time_vec, time_function_evals] = GP_PI(T)

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
    
    
    l = 0.2;
    noise_var = 0.0001;
    noise_sig = sqrt(noise_var);
    d = 5;
    
    eps = 0.01;
    
    grid_cell = cell(1, 5);
    
    grid_cell{1} = linspace(0,1,8);
    grid_cell{2} = linspace(0,1,4);
    grid_cell{3} = linspace(0,1,4);
    grid_cell{4} = linspace(0,1,31);
    grid_cell{5} = linspace(0,1,6);
    
    parameter_cell = cell(1, 5);
    
    parameter_cell{1} = 2.^(3:10);
    parameter_cell{2} = [3,5,7,9];
    parameter_cell{3} = [3,5,7,9];
    parameter_cell{4} = 10:40;
    parameter_cell{5} = 10.^(-6:-1);
    
    grid_1 = grid_cell{1};
    grid_2 = grid_cell{2};
    grid_3 = grid_cell{3};
    grid_4 = grid_cell{4};
    grid_5 = grid_cell{5};
    
    regret = zeros(1, T);
    sample_pts = zeros(d,T);
    observations = zeros(1,T);
    
    sample_pt_idx = [randi(8), randi(3), randi(3), randi(31), randi(6)];
    
    max_so_far = 0;

    time_vec = zeros(1, T);
    time_function_evals = zeros(1, T);
    tic;
    
    for t = 1:T
        sample_pt_x = zeros(5,1);
        sample_pt_actual = zeros(5,1);
        for i = 1:5
            grid = grid_cell{i};
            parameters = parameter_cell{i};
            sample_pt_x(i) = grid(sample_pt_idx(i));
            sample_pt_actual(i) = parameters(sample_pt_idx(i));
        end
        [f_t, t_f] = f(sample_pt_actual);
        time_vec(t) = toc;
        time_function_evals(t) = t_f;
        regret(t) = - f_t;
        observations(t) = f_t + randn*noise_sig;
        sample_pts(:, t) = sample_pt_x;
        
%         if time_vec(t) > 2000
%             break;
%         end
        
        diff_x_sq = 0;
        diff_x_abs = 0;
        for i = 1:d
            diff_x = repmat(sample_pts(i, 1:t), [t, 1]);
            diff_x_sq = diff_x_sq + (diff_x - diff_x').^2;
            diff_x_abs = diff_x_abs + abs(diff_x - diff_x');
        end
        
        K = (1 + sqrt(5)*diff_x_abs/l + 5*diff_x_sq/(3*l^2)).*exp(-sqrt(5)*diff_x_abs/l);
        
        inv_mat = inv(K + noise_var*eye(t));
        
        max_PI = 0;
        argmax_PI = sample_pt_idx;
        
        max_mu_new = 0;
        
        
        for n1 = 1:8
            for n2 = 1:4
                for n3 = 1:4
                    for n4 = 1:31
                        for n5 = 1:6
                            check_pt = [grid_1(n1); grid_2(n2); grid_3(n3); grid_4(n4); grid_5(n5)];
                            
                            diff_pts = sample_pts(:, 1:t) - repmat(check_pt, [1,t]);

                            k_vec = (1 + sqrt(5)*sum(abs(diff_pts))/l + 5*sum(diff_pts.^2)/(3*l^2)).*exp(-sqrt(5)*sum(abs(diff_pts))/l);
                            
                            mu_x = k_vec*inv_mat*observations(1:t)';
                            sigma_x = abs(sqrt(1 - k_vec*inv_mat*k_vec'));
                            
                            imp = mu_x - max_so_far - eps;
                            Z = imp/sigma_x;
                            pi_x = normcdf(Z);
                               
                            
                            if max_PI < pi_x
                                max_PI = pi_x;
                                argmax_PI = [n1,n2,n3,n4,n5];
                            end

                            if max_mu_new < mu_x
                                max_mu_new = mu_x;
                            end

                        end
                    end
                end
            end
        end
        
        sample_pt_idx = argmax_PI;
        
        max_so_far = max_mu_new;
    end
    
    regret = regret +  0.99;
    time_elapsed = toc;
end