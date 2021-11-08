function [] = plot_rosenbrock()
g0 = linspace(0,1);
g0 = g0*0.3 + 0.8;
[x,y] = meshgrid(g0, g0);
z = 10 - 100*(y - x.^2).^2 - (1 - x).^2;
surf(x,y,z, 'EdgeColor', 'none' );
end