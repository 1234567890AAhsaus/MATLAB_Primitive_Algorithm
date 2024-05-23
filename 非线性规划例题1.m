% 第一题
clear; clc;
% 六个工地坐标
a = [1.25 8.75 0.5 5.75 3 7.25];
b = [1.25 0.75 4.75 5 6.5 7.75];
% 临时料场位置
x = [5 2];
y = [1 7];
% 6个工地水泥日用量
d = [3 5 4 7 6 11];
% 计算目标函数系数，即6工地与两个料场的距离，共12个值
for i = 1:6
    for j = 1:2
        l(i, j) = sqrt((x(j)-a(i))^2 + (y(j)-b(i))^2);
    end
end

f = [l(:,1); l(:,2)];

A = [1 1 1 1 1 1 0 0 0 0 0 0
     0 0 0 0 0 0 1 1 1 1 1 1];
b = [20; 20];

Aeq = [eye(6), eye(6)];
beq = [d(1); d(2); d(3); d(4); d(5); d(6)];
Vlb = zeros(12,1); 

[x, fval] = linprog(f, A, b, Aeq, beq, Vlb);
x, fval

%　第二题
A2 = [1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
      0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 0];
B2 = [20; 20];
Aeq2 = [eye(6), eye(6), zeros(6,4)];
beq2 = [3 5 4 7 6 11]';
Vlb2 = [zeros(12,1); -inf; -inf; -inf; -inf];

x0 = [3 5 0 7 0 1 0 0 4 0 6 10 5 1 2 7]';
[x2, fval2] = fmincon(@obj_f, x0, A2, B2, Aeq2, beq2, Vlb2)

% 蒙特卡洛法求最开始解
p0 = 10000; n = 10^6; tic
x_m0 = 0;
for i = 1:n
    x_m = [randi(4)-1,randi(6)-1,randi(5)-1,randi(8)-1,randi(7)-1,randi(12)-1,...
        randi(4)-1,randi(6)-1,randi(5)-1,randi(8)-1,randi(7)-1,randi(12)-1,...
        9*rand(1,4)];

    [g, k] = constraint(x_m);
    if all(g<=0)
        if all(abs(k)<=1)
            ff = obj_f(x_m);
            if ff < p0
                x_m0 = x_m; p0 = ff;
            end
        end
    end
    
end
x_m0, p0, toc
[x3, fval3] = fmincon(@obj_f, x_m0, A2, B2, Aeq2, beq2, Vlb2)

function ff = obj_f(x)

a1 = [1.25 8.75 0.5 5.75 3 7.25];
b1 = [1.25 0.75 4.75 5 6.5 7.75];

f1 = 0;

for i = 1:6
    s(i) = sqrt((x(13)-a1(i))^2 + (x(14)-b1(i))^2);
    f1 = s(i)*x(i) + f1;
end

f2 = 0;

for i = 7:12
    s(i) = sqrt((x(15)-a1(i-6))^2 + (x(16)-b1(i-6))^2);
    f2 = s(i)*x(i) + f2;
end

ff = f1 + f2;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [g, k] = constraint(x)

g =  [sum(x(:,1:6),2)-20    
     sum(x(:,7:12),2)-20 
     ];
    

k = [x(1)+x(7)-3
     x(2)+x(8)-5
     x(3)+x(9)-4
     x(4)+x(10)-7
     x(5)+x(11)-6
     x(6)+x(12)-11
     ];
end
