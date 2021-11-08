function [val] = f(x)
x = x*0.3 + 0.8;
val = 10 - 100*(x(2) - x(1)^2)^2 - (1 - x(1))^2;
end