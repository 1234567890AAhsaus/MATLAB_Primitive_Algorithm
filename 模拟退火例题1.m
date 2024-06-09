clc, clear, close all
city = table2array(readtable('citys.xlsx','Range','B2:C35'));
n = size(city,1);      %城市距离初始化                                                                    
d = zeros(n,n+1);      %35号只会作为终点          
for i = 1:n
    for j = 1:n
            d(i,j)= distance(city(i,2),city(i,1),city(j,2),city(j,1),6371); % distance求圆心角的角度.第一个点的纬度、第一个点的经度
    end    
end
%各城市到35号即北京的距离作为第35列
for i=1:n
    d(i,35)= distance(city(i,2),city(i,1),city(1,2),city(1,1),6371);
end

path=[];
lenth=inf; %总路径及长度初始化
for j=1:1000  %求较好的初始解，随机求1000种方案，挑出最好的作为初始方案
    temp_path=[1 1+randperm(33) 35];    % 当前解（方案）
    temp_lenth=0;   % 当前方案的总路径
    % 求该方案下总路径长度temp_lenth
    for i=1:34
        temp_lenth=temp_lenth+d(temp_path(i),temp_path(i+1));
    end
    % 如果该方案下总路径长度temp小于所记录的当前最短总路径长度long（初始为正无穷）
    if temp_lenth<lenth
        path=temp_path; lenth=temp_lenth;      % 将该路径方案temp_path记为最短路径方案path，将该方案的长度temp_lenth记为最短路径长度lenth
    end
    % 如此循环1000次，就从1000个随机方案里挑选出最优的方案作为初始方案，用于后面的模拟退火
end

e=0.1^30;alpha=0.999;T=1;markov=1;   %这些参数都是可以改的

% for k=1:L  %退火过程
accept=0;rand_accept=0;refuse=0;
while T>e
    for t=1:markov
        %新解随机选序号𝑢, 𝑣，将𝑢到𝑣的这部分转为逆序作为新解
        c=2+floor(33*rand(1,2));  %产生新解；floor向下取整，得到两个2到34的随机整数
        c=sort(c);  %随机选的两个点升序排序，用于接下来计算
        u=c(1);v=c(2);  %模型中的随机选的两个点u和v，u是序号小的那一个
        %计算目标函数值的增量
        df=d(path(u-1),path(v))+d(path(u),path(v+1))-...
            d(path(u-1),path(u))-d(path(v),path(v+1));
        if df<0 %接受准则
            path=[path(1:u-1),path(v:-1:u),path(v+1:35)]; %新路径u到v逆序
            lenth = lenth + df;
            accept = accept + 1;
        elseif exp(-df/T)>=rand
            path = [path(1:u-1), path(v:-1:u), path(v+1:35)];
            lenth = lenth + df;
            rand_accept = rand_accept + 1;
        else
            refuse = refuse + 1;
        end
    end
    T = T*alpha;
end

path(35) = 1;
plot(city(path,1), city(path, 2), 'o-');
    disp('最短路程：')
    disp(lenth)
    disp('直接接受新解次数：')
    disp(accept);
    disp('接受更差的随机解次数: ')
    disp(rand_accept)
    disp('不接受随机解次数: ')
    disp(refuse)
for i = 1:n
    text(city(i,1), city(i,2), ['    ',num2str(i)]);
end
xlabel('东经');
ylabel('北纬');

            