function [stc_Ic_Vce_Ib, stc_rO_Ic_Ib] = MyDataProcessor_BJT_Data1_IcVceIb(data, data_window, name, rOfit, rO_window, R_Ib, unit_Ic, unit_Ib)
%%
%{
Input format:
列 1      2        3      4        5      6
Vce (V)	Ic (A)	Vbe (V)	Ib (A)	Vrc (V)	Vrb (V)
  x       y       -        -      rx_Ic   ry_Ib
%}

%%
% 依据 Vrb (I_b) 对数据分组
leg_Vrb = unique(round(data(:, 6), 5));   % 提取 Vrb 字符串
length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
Index = zeros(length_Ib, 2);    % 左起始, 右终止
for i = 1:length_Ib
    Index(i, 1) = find(  round(data(:, 6), 4) == round(leg_Vrb(i), 4)  , 1, 'first' );
    % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
    Index(i, 2) = find(  round(data(:, 6), 4) == round(leg_Vrb(i), 4)   , 1, 'last' );
    % 找到最后一个
end

% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Ib
        data(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end

%%
% 输入等效 Vrb 向 Ib 转换的 R_ob, Ic 的单位, 以及其它参量
%R_ob = 10e3;    % unit: Ohm
%unit_Ic = 'mA';
%unit_Ib = 'uA';
%Name = 'xxxxxxx';

amplification_Ic = 0;   % 系数初始化
switch unit_Ic
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
Ib = data_tra(6, :)/R_Ib*amplification_Ib;   % Vrb 转化为 Ib, Ib 单位转化
leg_Ib = unique(data(:, 6))/R_Ib*amplification_Ib;   % 提取 Vrb 字符串

% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Ib
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  data_tra(1, Index(i, 1):Index(i, 2)), data_tra(2, Index(i, 1):Index(i, 2))*amplification_Ic  );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes, data_tra(  1, Index(i, 1):Index(i, 2)), data_tra(2, Index(i, 1):Index(i, 2))*amplification_Ic  );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        end
    end

    %%
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$I_{B} = $ " + num2str(leg_Ib) + ' ' + unit_Ib;
    %str = num2str(leg_str) + " V";
    %stc.num1.leg.String = str(end:-1:1);
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northeast';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = 'Collector-Emitter Voltage $V_{CE}$ (V)';
    stc.num1.label.y.String = "Collector Current $I_{C}$ (" + unit_Ic + ')';
    stc.num1.axes.Title.String = name + " $(I_C,\ V_{CE},\ I_B)$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    stc_Ic_Vce_Ib = stc;
%%%%%%%%%

%% 
%{ 
原本是直接拿斜率计算 rO, 但是数据实在不好看, 因此改为了线性拟合 (取 Vce > 0.5V 的数据)

if rOfit == 1
    % 计算 (rO, Vce, Ib) 和 (rO, Ic, Ib)
    % 计算前建议进行滤波, 且 rO 计算时需分组
    rO = zeros(Index(1, 2) - 1, length_Ib);
    data_rO = MyFilter_mean(data, early_window);
    for i = 1:length_Ib
        rO(:, i) = diff(data_rO(Index(i, 1):Index(i, 2), 1))./diff(data_rO(Index(i, 1):Index(i, 2), 2));
    end
    % 计算后的 rO 滤波:
    if 1
        rO_filted = MyFilter_mean(rO, 10);
        rO_filted = MyFilter_mean(0.6*rO + 0.4*rO_filted, 10);
        rO = MyFilter_mean(0.6*rO + 0.4*rO_filted, 5);
    end
    
    % 拟合厄利电压 (排除了 rO 过小的数据, 在最开始的版本是 85 Ohm)
    % 在拟合前丢弃饱和区的 rO 数据 (只保留后面 active 的数据), 减轻对拟合结果的干扰
%rO_Va = MyFilter_mean(0.6*rO + 0.4*rO_filted, 10);  % 再次滤波
    length_onecolumn = size(rO, 1);
    rO_xmin = round(length_onecolumn*1/5);  % 丢弃部分 rO 数据
    %rO_xmin = 1;
    rO_xrange = zeros(length_Ib, 2);
    for i = 1:length_Ib
        rO_xrange(i, :) = [Index(i, 1) + rO_xmin,  Index(i, 2)];    % 计算丢弃部分 rO 数据后的横坐标 index
    end
    rO = rO(rO_xmin:end, :);
    rO_filted = rO_filted(rO_xmin:end, :);
    % 提取最大值进行拟合
    rO_max = zeros(length_Ib, 3);
    for i = 1:length_Ib % 提取 rO max
        % 如果提取 rO 最大值, 会出现 Inf 较多的情况
        rO_Va = MyFilter_mean(0.6*rO + 0.4*rO_filted, 5);  % 再次滤波
        rO_Va(isinf(rO_Va)) = nan;    % 去除 inf 数据
        [rO_max(i, 2), pp] = max(rO_Va(:, i));   % 提取最大值点 (rO, Ic), pp 为临时变量
        pp = Index(i, 2) - pp;
        rO_max(i, 1) = data(pp, 2);
        rO_max(i, 3) = data(pp, 1); % 提取此时的 Vce
    end
    Vce_mean = mean(rO_max(:, 3));
    fit_Va = MyFit_EarlyVoltage(rO_max(:, 1), rO_max(:, 2));    % 进行拟合 rO = (Va + Vce)/Ic or Va/Ic
    V_A = fit_Va.Va;    % 提取 Early Voltage

%}
%% 对 active region 的数据进行线性拟合, 求出 rO
if rOfit == 1
    % 提取数据
    % 找到原数据中. 每一组 Vce > 0.5V 的起始点
    Index_rO = [Index(:, 1) - 1 + find(data(Index(:, 1):Index(i, 2), 1) > 0.5, 1, 'first'), Index(:, 2)];
    i = 1;
    data_for_rO(:, :) = data(Index_rO(i, 1):Index_rO(i, 2), :);
    for i = 2:length_Ib
        data_for_rO = [data_for_rO; data(Index_rO(i, 1):Index_rO(i, 2), :)];
    end
    data_for_rO = data( (data(:, 1) > 0.5), : );
    % 依据 Vrb (I_b) 对数据分组
    Index_rO = zeros(length_Ib, 2);    % 左起始, 右终止
    for i = 1:length_Ib
        Index_rO(i, 1) = find(  round(data_for_rO(:, 6), 4) == round(leg_Vrb(i), 4)  , 1, 'first' );
        % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
        Index_rO(i, 2) = find(  round(data_for_rO(:, 6), 4) == round(leg_Vrb(i), 4)   , 1, 'last' );
        % 找到最后一个
    end
    
    % 数据 (分组) 滤波, 不影响数据 size
    if 1
        windowSize = rO_window;  % 窗口大小
        b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
        a = 1;
        for i = 1:length_Ib
            MyFilter_mean(data_for_rO(Index_rO(i, 1):Index_rO(i, 2), [1 2]), windowSize);
        end
    end
    
    % 对每一组进行线性拟合, 求出 rO 
    rO_Ic_matrix = zeros(length_Ib, 2); % column 1 = rO, column 2 = Ic
    for i = 1:length_Ib
        X_Vce = data_for_rO( Index_rO(i, 1):Index_rO(i, 2), 1 );
        Y_Ic = data_for_rO( Index_rO(i, 1):Index_rO(i, 2), 2 );
        rO_Ic_matrix(i, 2) = mean(  Y_Ic  );
        fit_rO = MyFit_linear(Y_Ic', X_Vce', 0);
        rO_Ic_matrix(i, 1) = fit_rO.k;
    end
    %rO_Ic_matrix(rO_Ic_matrix(:, 1)<=0, :) = nan;    % 丢弃非正的 rO 数据
    % 拟合求 Va, rO = (Va + Vce)/Ic = Va/Ic
    %MyFit_proportional(1./rO_Ic_matrix(:, 2), rO_Ic_matrix(:, 1), 1)
    % x=rO, y=Ic 作拟合
    fit_Ic_gO_propor = MyFit_proportional(1./rO_Ic_matrix(:, 1)', rO_Ic_matrix(:, 2)', 0); % Ic = k(1/rO), k = Va
    fit_Ic_gO_linear = MyFit_linear(1./rO_Ic_matrix(:, 1)', rO_Ic_matrix(:, 2)', 0);     % Ic = k(1/rO) + b, k = Va, b = Ic0
    fit_gO_propor = @(Ic) Ic/fit_Ic_gO_propor.a;
    fit_gO_linear = @(Ic) (Ic - fit_Ic_gO_linear.b)./fit_Ic_gO_linear.k;

    %%
    %%%%%%%%%%%%%%%%% 作图 (1/rO, Ic, Ib)
    unit_gO = 'uS';
    switch unit_gO
        case 'S'
            amplification_gO = 1;
        case 'mS'
            amplification_gO = 1e3;
        case 'uS'
            amplification_gO = 1e6;
    end
    % 作图
        c = MyGet_colors_nok;
        for i = 1:length_Ib
            if i == 1
                stc.(['num', (num2str(i))]) = MyPlot(  rO_Ic_matrix(i, 2)*amplification_Ic,  1./rO_Ic_matrix(i, 1)*amplification_gO  );  % 注意 Ic 单位
                stc.(['num', (num2str(i))]).plot.Color = c{i};
                stc.(['num', (num2str(i))]).plot.plot_1.MarkerSize = 30;
            else
                stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes, rO_Ic_matrix(i, 2)*amplification_Ic,  1./rO_Ic_matrix(i, 1)*amplification_gO  );  % 注意 Ic 单位
                stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
                stc.(['num', (num2str(i))]).plot.plot_1.MarkerSize = 30;
            end
        end
        % 获取 Ic 范围, 作出厄利曲线
        Ic_range = [min(rO_Ic_matrix(:, 2))*1.1, max(rO_Ic_matrix(:, 2))*1.1];  % unit: A 
        tv_Ic = linspace(Ic_range(1), Ic_range(2), 100);  % unit: A 
        % 提取原本的纵坐标 rO 范围, 使视图更清晰
        %rO_range = stc.num1.axes.YLim;
        % 作出 proportional 拟合结果
        stc.(('gO_fit_propo')) = MyPlot_ax(stc.num1.axes, tv_Ic*amplification_Ic, fit_gO_propor(tv_Ic)*amplification_gO);
        i = 1+1;
        stc.(('gO_fit_propo')).plot.plot_1.Color = c{i};
        stc.gO_fit_propo.plot.plot_1.LineStyle = '--';
        % 作出 linear 拟合结果
        stc.(('gO_fit_linear')) = MyPlot_ax(stc.num1.axes, tv_Ic*amplification_Ic, fit_gO_linear(tv_Ic)*amplification_gO);
        i = 1+1;
        stc.(('gO_fit_linear')).plot.plot_1.Color = c{i};
        stc.gO_fit_linear.plot.plot_1.LineStyle = '-';
    % 调整图像属性
        str = "$I_{B} = $ " + num2str(leg_Ib) + ' ' + unit_Ib;
        %str = num2str(leg_str) + " V";
        if rOfit == 1
            %str = [str; "$V_A = $" + num2str(round(fit_Ic_gO_propor.a, 1)) + ' V'];
            %str = [str; "$V_A = $" + num2str(round(fit_Ic_gO_linear.k, 1)) + ' V, ' + "$I_{C0} = $" + num2str(round(fit_Ic_gO_linear.b*amplification_Ic, 2)) + ' ' + unit_Ic ];
            str = [str; "$1/r_O = I_C/V_A$"; "$1/r_O = (I_C - I_{C0})/V_A$"];
        end
        stc.num1.leg.String = str;
        stc.num1.leg.FontSize = 10;
        stc.num1.leg.Location = 'southeast';
        MyFigure_ChangeSize(stc.num1.fig, [700 512]);
        stc.num1.label.x.String = "Collector Current $I_{C}$ (" + unit_Ic + ')';
        %stc.num1. = stc.num1.plot.plot_1.YData*10^6;   % 将单位 S 转换为 uS
        stc.num1.label.y.String = "Early Conductance $\frac{1}{r_O}$ (" + unit_gO + ')';
        %stc.num1.axes.Title.String = name + " $(\frac{1}{r_O},\ I_C,\ I_B)$ ";
        stc.num1.axes.Title.String = "$V_A = $ " + num2str(round(fit_Ic_gO_propor.a, 1)) + ' V  or  ' ...
            + "$V_A = $ " + num2str(round(fit_Ic_gO_linear.k, 1)) + ' V, ' ...
            + "$I_{C0} = $ " + num2str(round(fit_Ic_gO_linear.b*amplification_Ic, 2)) + ' ' + unit_Ic;
        stc.num1.axes.Title.Interpreter = 'latex'; 
        %stc.num1.axes.XLim(1) = 0;
        %stc.num1.axes.XLim(2) = max(data(:, 2));
        %stc.num1.axes.YScale = 'log';
        stc_rO_Ic_Ib = stc;
        stc_rO_Ic_Ib.Va_without_Ic0 = fit_Ic_gO_propor.a;  % unit: V
        stc_rO_Ic_Ib.Va_with_Ic0 = fit_Ic_gO_linear.k;  % unit: V
        stc_rO_Ic_Ib.Ic0 = fit_Ic_gO_linear.b;  % unit: A
    %%%%%%%%%%%%%%%%%
    
    
    %%
%{   
舍弃不要
    %%%%%%%%%%%%%%%%% 作图 (1/rO, Vce, Ib), 1/rO = Ic/(Va + Vce) 不要, 选择 1/rO = (Ic - Ic0)/(Va + Vce)
    % 作图
        c = MyGet_colors_nok;
        for i = 1:length_Ib
            if i == 1
                stc.(['num', (num2str(i))]) = MyPlot(  data(rO_xrange(i, 1):rO_xrange(i, 2), 1),  rO_Va(:, i)  );
                stc.(['num', (num2str(i))]).plot.Color = c{i};
                %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
            else
                stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  data(rO_xrange(i, 1):rO_xrange(i, 2), 1),  rO_Va(:, i)  );
                stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
                %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
            end
        end
    % 调整图像属性
        %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
        %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
        %stc.num1.axes.XLim(1) = 0;
        stc.num1.axes.YLim(1) = 0;
        str = "$I_{B} = $ " + num2str(leg_Ib) + ' ' + unit_Ib;
        %str = num2str(leg_str) + " V";
        stc.num1.leg.String = str;
        stc.num1.leg.FontSize = 10;
        stc.num1.leg.Location = 'northeast';
        MyFigure_ChangeSize(stc.num1.fig, [700 512]);
        stc.num1.label.x.String = 'Collector-Emitter Voltage $V_{CE}$ (V)';
        stc.num1.label.y.String = 'Early Resistance $r_O$ ($\Omega$)';
        stc.num1.axes.Title.String = name + " $(r_O,\ V_{CE},\ I_B)$";
        stc.num1.axes.Title.Interpreter = 'latex';
        %stc.num1.axes.XLim(1) = 0;
        stc.num1.axes.YScale = 'log';
        stc_rO_Vce_Ib = stc;
    %%%%%%%%%%%%%%%%%
%}
end

if rOfit == 0
    %stc_rO_Vce_Ib = 0;
    stc_rO_Ic_Ib = 0;
end

end
