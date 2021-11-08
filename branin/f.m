function [val] = f(x)
u = 15*x(1) - 5;
v = 15*x(2);

term1 = v - 5.1*u^2/(4*pi^2) + 5*u/pi - 6;
term2 = (10 - 10/(8*pi)) * cos(u);

val = -(term1^2 + term2 - 44.81) / 51.95;
end