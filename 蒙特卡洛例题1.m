p = 10000;
r = 1; x0 = 1; y0 = 1; n = 0;

hold on
for i = 1:p
    px = rand*2;
    py = rand*2;
    if (px-1)^2 + (py-1)^2 < 1
        plot(px, py, '.', 'color', 'b');
        n = n + 1;
    else
        plot(px, py, '.', 'color', 'r');
    end
end
axis equal
s = (n/p)*4;
pi1 = s
