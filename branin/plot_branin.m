function [] = plot_branin()
    g0 = linspace(0,1,1000);
    [x,y] = meshgrid(g0, g0);
    
    u = 15*x - 5;
    v = 15*y;
    
    term1 = v - 5.1*(u.^2)/(4*pi^2) + 5*u/pi - 6;
    term2 = (10 - 10/(8*pi)) * cos(u);
    
    z = -(term1.^2 + term2 - 44.81) / 51.95;
    
    surf(x,y,z, 'EdgeColor','none');
    
end