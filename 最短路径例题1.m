a = zeros(6);
a(1, [2:6]) = [15 20 27 37 54];
a(2, [3:6]) = [15 20 27 37];
a(3, [4:6]) = [16 21 28];
a(4, [5:6]) = [16 21];
a(5, 6) = 17;

s = cellstr(strcat('顶点',int2str([1:6]')));
G = digraph(a, s);
P = plot(G, 'layout', 'force', 'EdgeColor','k','NodeFontSize',12);

[path, d] = shortestpath(G, 1, 6);
highlight(P, path, 'EdgeColor','red', 'LineWidth',3.5)
