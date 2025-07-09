function stc = MyDataProcessor_MOS_3D_Data1_IdVdsVgs(data, unit_Id, windowSize)
%%
% 继承原函数 MyDataProcessor_BJT_Data1_IcVceIb_3D, 有默认参数：
unit_Ib = 'A';
R_Ib = 1;

%{
Input format:
列 1      2        3      4        5      6
Vce (V)	Ic (A)	Vbe (V)	Ib (A)	Vrc (V)	Vrb (V)
x       y       -        -      rx_Ic   ry_Ib
%}

%%
% 依据 Vrb (I_b) 对数据分组
leg_Vrb = unique(data(:, 5));   % 提取 Vrb 字符串
length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
Index = zeros(length_Ib, 2);    % 左起始, 右终止
for i = 1:length_Ib
    Index(i, 1) = find(  round(data(:, 5), 4) == round(leg_Vrb(i), 4)  , 1, 'first' );
    % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
    Index(i, 2) = find(  round(data(:, 5), 4) == round(leg_Vrb(i), 4)   , 1, 'last' );
    % 找到最后一个
end

% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Ib
        data(Index(i, 1):Index(i, 2), 2) = filter(b, a, data(Index(i, 1):Index(i, 2), 2));  % 滤波
    end
    for i = 1:length_Ib
        data(Index(i, 1):Index(i, 2), 1) = filter(b, a, data(Index(i, 1):Index(i, 2), 1));  % 滤波
    end
end

%%
% 输入等效 Vrb 向 Ib 转换的 R_ob, Ic 的单位, 以及其它参量
%R_ob = 10e3;    % unit: Ohm
%unit_Ic = 'mA';
%unit_Ib = 'uA';
%Name = 'xxxxxxx';

amplification_Ic = 0;   % 系数初始化
switch unit_Id
    case 'A'
        amplification_Ic = 1;
    case 'mA'
        amplification_Ic = 1e3;
    case 'uA'
        amplification_Ic = 1e6;
end

switch unit_Ib
    case 'A'
        amplification_Ib = 1;
    case 'mA'
        amplification_Ib = 1e3;
    case 'uA'
        amplification_Ib = 1e6;
end

%%
%%%%%%%%% (Ic, Vce, Ib) 图片代码
% 数据转化
data_tra = data';
%Ic = data_tra(2, :)*amplification_Ic;   % Ic 单位转化
Ib = data_tra(5, :)/R_Ib*amplification_Ib;   % Vrb 转化为 Ib, Ib 单位转化
leg_Ib = unique(data(:, 5))/R_Ib*amplification_Ib;   % 提取 Vrb 字符串
X = zeros(Index(1, 2), length_Ib);
Y = zeros(Index(1, 2), length_Ib);
Z = zeros(Index(1, 2), length_Ib);
for i = 1:length_Ib
    X(i, :) = data_tra(1, Index(i, 1):Index(i, 2)); % Vce
    Y(i, :) = Ib(Index(i, 1):Index(i, 2));    % Ib
    Z(i, :) = data_tra(2, Index(i, 1):Index(i, 2))*amplification_Ic; % Ic
end

% 作图
stc = MySurf(X, Y, Z);
%stc.title.String = name + " 3D View of Static Chara $(r_O,\ I_C,\ I_B) \\$";
stc.label_left.x.String = 'Drain-Source Voltage $V_{DS}$ (V)';
stc.label_left.y.String = "Gate-Source Voltage $V_{GS}$ (V)";
stc.label_left.z.String = "Drain Current $I_{D}$ (" + unit_Id + ')';
stc.label_right.x.String = 'Drain-Source Voltage $V_{DS}$ (V)';
stc.label_right.y.String = "Gate-Source Voltage $V_{GS}$ (V)";
stc.title.Interpreter = 'latex';
stc.axes_left.XLim(1) = 0;
stc.axes_left.YLim(1) = 0;
%stc.axes_left.ZLim(1) = 0;
stc.axes_right.XLim(1) = 0;
stc.axes_right.YLim(1) = 0;
MyFigure_ChangeSize(stc.fig, [1536 512]*1.1);
%MyMesh
end