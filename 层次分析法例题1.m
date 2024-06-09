clc, clear

% 输入判断矩阵

A = [1 2 3 5
    1/2 1 1/2 2
    1/3 2 1 2
    1/5 1/2 1/2 1];

maxlam = max(eig(A))
[~,n] = size(A)
RI = [0, 0, 0.58, 0.9, 1.12, 1.24, 1.32, 1.41, 1.45];
CI = (maxlam - n)/(n-1)
CR = CI/RI(n)
if CR < 0.10
    disp('该矩阵通过一致性检验。');
else 
    disp('该矩阵未通过一致性检验! ');
    return  
end

[n,~] = size(A)
Asum = sum(A,1);
Aprogress = A./(ones(n,1)*Asum);
W = sum(Aprogress, 2)./n;

data = [1986.4 3183 12000 397
        903.6 1916.4 3439.6 43
        837.6 817.6 4748 1159
        824.9 1296.4 12000 442
        2110.2 1465.7 6199.5 228];

[mm, nn] = size(data);
for j = 1:nn
    msum = sum(data(:,j));
    for i = 1:mm
        data(i,j) = data(i,j)./msum;
    end
end

grade = data*W
