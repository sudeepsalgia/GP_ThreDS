function [avg_reg] = new_metric_plot(reg, t_vec, t_len)
    if nargin < 3
        t_len = 70;
    end
    avg_reg = zeros(1, t_len);
    for i = 1:t_len
        avg_reg(i) = mean(reg(t_vec <= 0.1*i & t_vec > 0));
    end
end