
clear;

%构建整数规划模型

% 创建目标函数系数
f = ones(1, 36000);

% 指定需要为整数的变量索引（假设所有变量都需要为整数）
intcon = 1:36000;

% 创建一个 30 行 36000 列的全为 -25 的矩阵
A = -25 * ones(60, 36000);

% 使用 readtable 函数读取 CSV 文件
b1_table = readtable('volume_data_answer2_1.csv');
b = table2array(b1_table);  % 将表转换为数组
b = -b(:);  % 确保 b 是列向量

% 设置线性规划问题的其他参数
Aeq = [];  % 没有等式约束时设为空矩阵
beq = [];
lb = zeros(36000, 1);  % 下界设为 0
ub = ones(36000, 1);  % 上界设为 1
options = optimoptions('intlinprog', 'Display', 'iter');  % 设置选项

% 使用 intlinprog 求解整数线性规划问题
try
    [x, fval, exitflag, output] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);
    % 显示结果
    disp('Optimal solution:');
    disp(x);
    disp('Objective function value at optimal solution:');
    disp(fval);
catch ME
    disp('An error occurred:');
    disp(ME.message);
end
%{
% 填写正式工人数

% 假设 x 是一个 36000 行 1 列的列向量
x = rand(36000, 1); % 生成一个随机的列向量作为示例

% 创建一个空表格
T = table();

% 外层循环 30 次
for day = 1:30
    % 构造日期
    date_str = datestr(datetime(2023, 12, day), 'yyyy/mm/dd');
    
    % 自定义的六个数
    custom_numbers = {'00:00-08:00', '05:00-13:00', '08:00-16:00', '12:00-20:00', '14:00-22:00', '16:00-24:00'};
    
    % 中层循环 6 次
    for custom_index = 1:numel(custom_numbers)
        custom_number = custom_numbers{custom_index};
        
        % 内层循环 200 次
        for worker = 1:200
            % 构造正式工编号
            worker_id = ['正式工' num2str(worker)];
            
            % 创建新行数据并添加到表格
            row_data = {date_str, custom_number, worker_id};
            T_new = cell2table(row_data, 'VariableNames', {'Date', 'CustomNumber', 'WorkerID'});
            T = [T; T_new];
        end
    end
end

% 显示表格的前几行
disp(head(T));

% 将表格导出为 CSV 文件
filename = 'exported_data.csv';
writetable(T, filename);

disp(['数据已导出到文件：' filename]);
%}

%最后筛选出有36000行中决策变量为1的行，通过也将x列向量转为csv文件,列名也是WorkerID

T = table(x, 'VariableNames', {'WorkerID'});

% 指定导出文件的路径和文件名
filename = 'exported_data_x.csv';

% 使用 writetable 函数将表格数据导出为 CSV 文件
writetable(T, filename);

disp(['数据已导出到文件：' filename]);

