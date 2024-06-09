clc, clear;
score = readmatrix('data3-3.xlsx','range','B2:I11');

[n,m] = size(n,m);
score2 = zeros(n, m);
for j = 1:m
    for i = 1:n
        score2(i,j) = (score(i,j)-min(score(:,j)))/(max(score(:,j)-min(score(:,j)));
        if score2(i,j)==0
            score2(i,j)=0.0001;
        end
    end
end

p = score2./sum(score2);
e = -sum(p.*log(p))/log(n);
g = 1-e;
w = g/sum(g);
s = w*p';
[ss,rank] = sort(s,'decend');