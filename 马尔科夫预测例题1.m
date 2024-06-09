clc, clear;

a0 = [4 3 2 1 4 3 1 1 2 3
      2 1 2 3 4 4 3 3 1 1
      1 3 3 2 1 2 2 2 4 4
      2 3 2 3 1 1 2 4 3 1];
a1 = a0';
a2 = a1(:);
a = a2';

for i = 1:4
    for j = 1:4
        f(i,j) = length(strfind(a, [i,j]));
    end
end

ni = sym(sum(f,2));
P = f./ni;

p0 = [0.2 0.3 0.3 0.2];
p5 = p0*(P^5)