function [x_seq] = x_sequence(h_max)
    x_seq = zeros(1, 2^h_max-1);
    n = 1;
    for i = 0:(h_max-1)
        len = 2^(-(i+1));
        for j = 0:(2^(i)-1)
            if n == 1
                x_seq(n) = 0.5;
            else
                par_idx = floor(n/2);
                if mod(j, 2) == 0
                    x_seq (n)= x_seq(par_idx) - len;
                else
                    x_seq(n) = x_seq(par_idx) + len;
                end  
            end   
            n = n + 1;
        end
    end
end