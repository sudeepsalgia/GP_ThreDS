function [regret, time_vector] = get_IGP_UCB_regret(n_loops, T)

regret = zeros(n_loops, T);
time_vector = zeros(n_loops, T);
for i = 1:n_loops
    [reg, ~, t_vec] = IGP_UCB(T);
    regret(i, :) = reg(1:T);
    time_vector(i, :) = t_vec(1:T);
    disp(i);
end

end