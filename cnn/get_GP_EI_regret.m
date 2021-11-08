function [regret, time_vector, time_function_evals] = get_GP_EI_regret(n_loops, T)

regret = zeros(n_loops, T);
time_vector = zeros(n_loops, T);
time_function_evals = zeros(n_loops, T);
for i = 1:n_loops
    [reg, ~, t_vec, time_f] = GP_EI(T);
    regret(i, :) = reg(1:T);
    time_vector(i, :) = t_vec(1:T);
    time_function_evals(i, :) = time_f(1:T);
    disp(i);
end

end