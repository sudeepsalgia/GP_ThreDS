function [] = plot_curves(plot_err_bar)

if nargin < 1
    plot_err_bar = 1;
end

n_pts = 80;
time_stamps = 0.1*(1:n_pts);

n_loops = 10;

load('all_alg_res.mat');


ar_IGP_mat = zeros(n_loops, n_pts);
ar_AD_mat = zeros(n_loops, n_pts);
ar_GPTDS_mat = zeros(n_loops, n_pts);
ar_EI_mat = zeros(n_loops, n_pts);
ar_PI_mat = zeros(n_loops, n_pts);

err_IGP = zeros(2, n_pts);
err_AD = zeros(2, n_pts);
err_GPTDS = zeros(2, n_pts);
err_EI = zeros(2, n_pts);
err_PI = zeros(2, n_pts);

ar_IGP_mean = zeros(1, n_pts);
ar_AD_mean = zeros(1, n_pts);
ar_GPTDS_mean = zeros(1, n_pts);
ar_EI_mean = zeros(1, n_pts);
ar_PI_mean = zeros(1, n_pts);

for i = 1:n_loops
    ar_IGP_mat(i, :) = new_metric_plot(reg_IGP_UCB(i, :), t_IGP_UCB(i, :), n_pts);
    ar_AD_mat(i, :) = new_metric_plot(reg_AD(i, :), t_AD(i, :), n_pts);
    ar_GPTDS_mat(i, :) = new_metric_plot(reg_GPTDS(i, :), t_GPTDS(i, :), n_pts);
    ar_EI_mat(i, :) = new_metric_plot(reg_EI(i, :), t_EI(i, :), n_pts);
    ar_PI_mat(i, :) = new_metric_plot(reg_PI(i, :), t_PI(i, :), n_pts);
end

for i = 1:n_pts
    ar_IGP_mean(i) = mean(ar_IGP_mat(:, i));
    err_IGP(1, i) = max(ar_IGP_mat(:, i));
    err_IGP(2, i) = min(ar_IGP_mat(:, i));
    
    ar_AD_mean(i) = mean(ar_AD_mat(:, i));
    err_AD(1, i) = max(ar_AD_mat(:, i));
    err_AD(2, i) = min(ar_AD_mat(:, i));
    
    ar_GPTDS_mean(i) = mean(ar_GPTDS_mat(:, i));
    err_GPTDS(1, i) = max(ar_GPTDS_mat(:, i));
    err_GPTDS(2, i) = min(ar_GPTDS_mat(:, i));
    
    ar_EI_mean(i) = mean(ar_EI_mat(:, i));
    err_EI(1, i) = max(ar_EI_mat(:, i));
    err_EI(2, i) = min(ar_EI_mat(:, i));
    
    ar_PI_mean(i) = mean(ar_PI_mat(:, i));
    err_PI(1, i) = max(ar_PI_mat(:, i));
    err_PI(2, i) = min(ar_PI_mat(:, i));
end

green_color = [0.4660 0.7640 0.1880] ;
red_color = [0.8500 0.3250 0.0980] ;
purple_color = [0.4940 0.1840 0.5560] ;
yellow_color = [0.9290 0.6940 0.1250];
blue_color = [0.3010 0.7450 0.9330];

IGP_color = yellow_color;
AD_color = red_color;
GPTDS_color = green_color;
EI_color = purple_color;
PI_color = blue_color;

semilogy(time_stamps, ar_IGP_mean, 'Color', IGP_color, 'LineWidth', 2);
hold on;
semilogy(time_stamps, ar_AD_mean, 'Color', AD_color, 'LineWidth', 2);
hold on;
semilogy(time_stamps, ar_GPTDS_mean, 'Color', GPTDS_color, 'LineWidth', 2);
hold on;
semilogy(time_stamps, ar_EI_mean, 'Color', EI_color, 'LineWidth', 2);
hold on;
semilogy(time_stamps, ar_PI_mean, 'Color', PI_color, 'LineWidth', 2);
alpha_val = 0.1;

hold on;

if(plot_err_bar)

patch([time_stamps, fliplr(time_stamps)], [err_IGP(1, :), fliplr(err_IGP(2, :))], IGP_color,  'FaceColor', IGP_color, ...
   'EdgeColor', IGP_color, 'FaceAlpha', alpha_val, 'EdgeAlpha', alpha_val);

hold on;

patch([time_stamps, fliplr(time_stamps)], [err_AD(1, :), fliplr(err_AD(2, :))], AD_color, 'FaceColor', AD_color, ...
    'EdgeColor', AD_color, 'FaceAlpha', alpha_val, 'EdgeAlpha', alpha_val);

hold on;

patch([time_stamps, fliplr(time_stamps)], [err_GPTDS(1, :), fliplr(err_GPTDS(2, :))] ,GPTDS_color, 'FaceColor', GPTDS_color, ...
'EdgeColor', GPTDS_color, 'FaceAlpha', alpha_val, 'EdgeAlpha', alpha_val);

hold on;

patch([time_stamps, fliplr(time_stamps)], [err_EI(1, :), fliplr(err_EI(2, :))] ,EI_color, 'FaceColor', EI_color, ...
'EdgeColor', EI_color, 'FaceAlpha', alpha_val, 'EdgeAlpha', alpha_val);


hold on;

patch([time_stamps, fliplr(time_stamps)], [err_PI(1, :), fliplr(err_PI(2, :))] ,PI_color, 'FaceColor', PI_color, ...
'EdgeColor', PI_color, 'FaceAlpha', alpha_val, 'EdgeAlpha', alpha_val);

end

ylim([0, 2]);
legend({'IGP UCB', 'AD', 'GPTDS', 'EI', 'PI'}, 'Interpreter', 'latex', 'FontSize', 15);
title('$R(T)/T$ versus wall clock time', 'Interpreter', 'latex', 'FontSize', 18);

end