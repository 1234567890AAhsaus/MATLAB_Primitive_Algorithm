clc, clear;

x = optimvar('x', 2, 'LowerBound',0);
dp = optimvar('dp', 3, 'LowerBound', 0);
dm = optimvar('dm', 3, 'LowerBound', 0);

p = optimproblem('ObjectiveSense','min');
p.Constraints.cons1 = ( 2*x(1)+x(2) <= 11);
p.Constraints.cons2 = [x(1)-x(2)+dm(1)-dp(1)==0
                       x(1)+2*x(2)+dm(2)-dp(2)==10
                       8*x(1)+10*x(2)+dm(3)-dp(3)==56];

obj = [dp(1); dm(2)+dp(2); dm(3)];
goal = 100000*ones(3,1);

for i = 1:3
    p.Constraints.cons3 = [obj<=goal];
    p.Objective = obj(i);
    [sx, fval] = solve(p);
    fprintf('第%d级目标求解为：\n', i)
    fval, xx = sx.x, sdm = sx.dm, sdp = sx.dp
    goal(i) = fval;
end

