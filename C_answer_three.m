clear

xc = ones(57, 30, 6);
yc = ones(57, 30, 6);

xcl = reshape(xc, [], 1);
ycl = reshape(yc, [], 1);

% 定义目标函数系数
f = [xcl; ycl];

% 定义变量类型和上下界
intcon = 1:length(f);
lb = [10*ones(length(f)/2, 1); zeros(length(f)/2, 1)];
ub = [60*ones(length(f)/2, 1); inf*ones(length(f)/2, 1)];

% 定义约束矩阵和约束边界
% 约束: 每天的货量处理完成
rows = 1710;
cols = 20520;

blockSize = 6
A1 = zeros(rows, cols);
fillvalueX = 25*8;
fillvalueY = 20*8;
for i = 1:rows
    startXIndex = mod((i-1)*blockSize, cols) + 1;
    endXIndex = startXIndex + blockSize - 1;
    startYIndex = cols/2 + startXIndex;
    endYIndex = startYIndex + blockSize - 1;

    if endXIndex > cols/2
        overIndex = endXIndex - cols/2;
        A1(i, startXIndex: cols/2) = fillvalueX;
        A1(i, 1:overIndex) = fillvalueX;
        A1(i, startYIndex:cols) = fillvalueY;
        A1(i, cols/2+1:cols/2+overIndex) = fillvalueY;
    else
        A1(i, startXIndex:endXIndex) = fillvalueX;
        A1(i, startYIndex:endYIndex) = fillvalueY;
    end
end

b1_table = readtable('cargo_volume_only.csv');
b1 = table2array(b1_table);  % 将表转换为数组
b1 = b1(:);  % 确保 b 是列向量

rows_A1 = 1710;
cols_half_A1 = 10260;
A1 = [-160*ones(rows_A1, cols_half_A1), -160*ones(rows_A1, cols_half_A1)];

b2 = 60*ones(57, 1)

rows1 = 57;
cols1 = 20520;

blockSize = 6
A2 = zeros(rows1, cols);
fillvalueX = 1;
fillvalueY = 0;
for i = 1:rows1
    startXIndex = mod((i-1)*blockSize, cols) + 1;
    endXIndex = startXIndex + blockSize - 1;
    startYIndex = cols/2 + startXIndex;
    endYIndex = startYIndex + blockSize - 1;

    if endXIndex > cols/2
        overIndex = endXIndex - cols/2;
        A2(i, startXIndex: cols/2) = fillvalueX;
        A2(i, 1:overIndex) = fillvalueX;
        A2(i, startYIndex:cols) = fillvalueY;
        A2(i, cols/2+1:cols/2+overIndex) = fillvalueY;
    else
        A2(i, startXIndex:endXIndex) = fillvalueX;
        A2(i, startYIndex:endYIndex) = fillvalueY;
    end
end


A = [-A1; A2]
b = [-b1; b2]


% 设计选项以保存迭代信息
options = optimoptions(@intlinprog, 'display', 'iter', 'OutputFcn', @savemilpsolutions, 'PlotFcn', @optimplotmilp);

[x, fval, exitflag, output] = intlinprog(f, intcon, A, b, [], [], lb, ub, options);

disp('最优解: ');
disp(x);
disp('目标函数值: ');
disp(fval);
disp('退出标志：');
disp(exitflag);


%%
center_write = []
date_write = []
result_write = []
banci_write = []
banci = {'00:00-08:00','05:00-13:00','08:00-16:00','12:00-20:00','14:00-22:00','16:00-24:00'}
% 重复元胞数组1710次
banci_repeated = (repmat(banci, 1, 1710))';
banci_write = banci_repeated
filename = '结果表5.csv';
variable_names = {'分拣中心', '日期', '班次', '正式工人数', '临时工人数'}
startDate = datetime(2023, 12, 1);
endDate = datetime(2023, 12, 30);
timeData = startDate:endDate;
timeString = datestr(timeData, 'yyyy/mm/dd');
date = cellstr(timeString);
expanded_date = {};

for i = 1:numel(date)
    repeaded_date = cellstr(repmat(date{i}, 6, 1));
    expanded_date = [expanded_date; repeaded_date];
end

date_write = []
for k = 1:57
    date_write = [date_write; expanded_date];
end

center_table = readtable('sorting_center_only.csv');
center1 = table2array(center_table);  % 将表转换为数组
center1 = center1(:);  % 确保 b 是列向量



z1 = num2cell(x(1:10260))
z2 = num2cell(x(10261:end))

xlswrite(filename, [variable_names; center_write, date_write, banci_write, z1, z2], '结果表5', 'A1');



