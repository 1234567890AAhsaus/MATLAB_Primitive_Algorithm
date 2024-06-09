clc, clear;
lam = 0.4;
mu = 0.1;
I = 0.4;
S = 0.5;

tspan = [0:1:50];
y0 = [I S];

[t,y] = ode45(@(t,y)SIRfunc(t,y,lam,mu), tspan, y0);
r = 1-y(:,1)-y(:,2);

plot(t,y(:,1),t,y(:,2),t,r,'k','LineWidth',2);
legend('患病:i(t)','易感染者:s(t)','移除者:r(t)','Location','Best');
ylabel('占人口比例%');
xlabel('时间t');
title('SIR模型(ode)');

function dydt = SIRfunc(t,y,lam,mu)
dydt = zeros(2,1);
dydt(1) = lam*y(1)*y(2) - mu*y(1);
dydt(2) = -lam*y(1)*y(2);
end
