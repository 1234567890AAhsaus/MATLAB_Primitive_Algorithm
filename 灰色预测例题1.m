clc, clear
x0 = [71.1 72.4 72.4 72.1 71.4 72.0 71.6]';
n = length(x0);
lamda = x0(1:n-1)./x0(2:n);
range = minmax(lamda');
lamrange_min = exp(-2/(n+1));
lamrange_max = exp(2/(n+1));
if (range(1)>lamrange_min && range(2)<lamrange_max)
    fprintf("原始数据通过级比检验")
else
    fprintf("原始数据未通过级比检验!!!")
    return;
end

x1 = cumsum(x0)
B = [-0.5*(x1(1:n-1)+x1(2:n)),ones(n-1,1)];
Y = x0(2:n);
u = B\Y

syms x(t)
x = dsolve(diff(x)+u(1)*x==u(2), x(0)==x0(1));
xt = vpa(x, 6);

nihe1 = subs(x,t,[0:n-1]);
nihe1 = double(nihe1);
nihe = [x0(1),diff(nihe1)]

yuce_result = double(subs(x,t,7)) - double(subs(x,t,6))

delta = abs((x0'-nihe)./x0');
rho = 1-(1-0.5*u(1))/(1+0.5*u(1))*lamda'