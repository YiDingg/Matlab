function [stc_Ic_Vbe_Vce, stc_Ib_Vbe_Vce, stc_gm_Ic_Vce, stc_gm_Vbe_Vce, stc_Beta_Vbe_Vce, stc_Beta_Ic_Vce, stc_rpi_Ic_Vce, stc_rpi_Vbe_Vce] = MyDataProcessor_BJT_Data23_IcVbeVce_IbVbeVce_gm_rpi_BetaVbeVce(data_Ic, data_Ib, data_window, name, gmfit, gm_window, rpi_window, unit_Ic, unit_Ib, unit_Vbe, unit_Vce)
%%
%{
Input format:
1 (CH2) 2 (CH1)   3      4     5        6
Vbe (V)	Ic (A)	  -	     -	Vrc (V)     -
  x       y       -      -     var      -
%}

%%
% 依据 Vrc (Vce) 对数据分组
leg_Vrc = unique(round(data_Ic(:, 5), 5));   % 提取 Vrc 字符串
length_Vce = length(leg_Vrc);    % 获取 Ib 总组数
Index = zeros(length_Vce, 2);    % 左起始, 右终止
for i = 1:length_Vce
    Index(i, 1) = find(  round(data_Ic(:, 5), 4) == round(leg_Vrc(i), 4)  , 1, 'first' );
    % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
    Index(i, 2) = find(  round(data_Ic(:, 5), 4) == round(leg_Vrc(i), 4)   , 1, 'last' );
    % 找到最后一个
end

% 滤波之前先获得 Beta 数据
data_Beta = data_Ic;
data_Beta(:, 2) = data_Ic(:, 2)./data_Ib(:, 2);

% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Vce
        data_Ic(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Ic(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end

%% 需要下面几个物理量的 (展示) 单位
%unit_Ic = 'mA';
%unit_Vbe = 'mV';
%unit_Vce = 'V';
%Name = 'xxxxxxx';

%amplification_Ic = 0;   % 系数初始化
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

switch unit_Vbe
    case 'V'
        amplification_Vbe = 1;
    case 'mV'
        amplification_Vbe = 1e3;
    case 'uV'
        amplification_Vbe = 1e6;
end

switch unit_Vce
    case 'V'
        amplification_Vce = 1;
    case 'mV'
        amplification_Vce = 1e3;
    case 'uV'
        amplification_Vce = 1e6;
end

%%
%%%%%%%%% (Ic, Vbe, Vce) 图片代码
% 数据处理
Ic =  data_Ic(:, 2)*amplification_Ic;   % Vbe 单位转化
Vbe = data_Ic(:, 1)*amplification_Vbe;   % Vbe 单位转化
Vce = data_Ic(:, 5)*amplification_Vce;   % Vce 单位转化
leg_Vce = unique(data_Ic(:, 5))*amplification_Vce;   % 提取 Vrc 字符串

% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Base-Emitter Voltage $V_{BE}$" + ' (' + unit_Vbe + ')';
    stc.num1.label.y.String = "Collector Current $I_{C}$ (" + unit_Ic + ')';
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (I_C,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = min(Ic);
    %stc.num1.axes.YScale = 'log';
    stc_Ic_Vbe_Vce = stc;
%%%%%%%%%

%% 
%%%%
if gmfit == 1
    % 计算 (gm, Vbe, Vce) 和 (gm, Ic, Vce)
    % 计算前后建议进行滤波, 且计算时需分组
    gm = zeros(Index(1, 2) - 1, length_Vce);
    for i = 1:length_Vce
        % 注意 Ic 和 Vbe 的单位
        gm(:, i) = diff(data_Ic(Index(i, 1):Index(i, 2), 2))./diff(data_Ic(Index(i, 1):Index(i, 2), 1));
    end
    gm = MyFilter_mean(gm, gm_window);
    % 计算后的 gm 滤波:
    if 1
        gm_filted = MyFilter_mean(gm, 8);
        gm_filted = MyFilter_mean(0.6*gm + 0.4*gm_filted, 8);
        gm = MyFilter_mean(0.6*gm + 0.4*gm_filted, 5);
    end
    
    % 拟合 Vt (用 Vce 最大的一组数据来拟合)
    %length_onecolumn = size(gm, 1);
    % 提取最后一组数据进行拟合
    % 这里的 gm 是已经分好组了 (每一列是一组)
    Y_gm = gm(:, end); 
    X_Ic = Ic(  Index(end, 1):(Index(end, 2)-1)  )/amplification_Ic;    % 注意 Ic 的单位
    [fit_Vt, ~, ~] = MyFit_proportional(X_Ic', Y_gm', false);    % 进行拟合 gm = Ic/Vt
    V_T = 1./fit_Vt.a;    % 提取 V_T


%%
%%%%%%%%%%%%%%%%% 作图 (gm, Ic, Vce)
% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  Ic( Index(i, 1):(Index(i, 2)-1) )', gm(:, i)' );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes, Ic( Index(i, 1):(Index(i, 2)-1) )', gm(:, i)' );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
    % 获取 Ic 范围, 作出拟合的 gm-Ic 曲线 (以及 26mV 的曲线)
        gm_fit_26mV = @(Ic) Ic/26e-3;
        Ic_range = stc.num1.axes.XLim/amplification_Ic;  % unit: A 
        tv_x = linspace(Ic_range(1), Ic_range(2), 100);  % unit: A 
        % 提取原本的纵坐标 gm 范围, 使视图更清晰
        gm_range = stc.num1.axes.YLim;
        % 作 26mV 曲线
        stc.(('gm_26mVcurve')) = MyPlot_ax(stc.num1.axes, tv_x*amplification_Ic, gm_fit_26mV(tv_x));
        i = i+1;
        stc.(('gm_26mVcurve')).plot.plot_1.Color = c{i};
        stc.gm_26mVcurve.plot.plot_1.LineStyle = '--';
        stc.num1.axes.YLim = gm_range;
        % 作拟合曲线
        stc.(('gm_fitcurve')) = MyPlot_ax(stc.num1.axes, tv_x*amplification_Ic, fit_Vt(tv_x)');
        i = i+1;
        stc.(('gm_fitcurve')).plot.plot_1.Color = c{i};
        stc.gm_fitcurve.plot.plot_1.LineStyle = '--';
        stc.num1.axes.YLim = gm_range;
% 调整图像属性
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    %str = num2str(leg_str) + " V";
    if gmfit == 1
        stc.num1.leg.String = [str; "$V_T = 26.0$ mV"; "$V_T = $ " + num2str(round(V_T*1000, 1)) + ' mV';];
    else
        stc.num1.leg.String = str;
    end
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'southeast';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Collector Current $I_{C}$ (" + unit_Ic + ')';
    stc.num1.label.y.String = 'Transconductance $g_m$ (S)';
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (g_m,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    %stc.num1.axes.YLim(1) = min(gm, [], 'all');
    stc_gm_Ic_Vce = stc;
    stc_gm_Ic_Vce.V_T = V_T;    % return V_T, 可用于 intrisic gain
    
%%%%%%%%%%%%%%%%%


%%
%%%%%%%%%%%%%%%%% 作图 (gm, Vbe, Vce)
% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  Vbe(  Index(i, 1):(Index(i, 2)-1)  )', gm(:, i)');
            stc.(['num', (num2str(i))]).plot.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  Vbe(  Index(i, 1):(Index(i, 2)-1)  )', gm(:, i)');
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        end
    end
% 调整图像属性
    stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Base-Emitter Voltage $V_{BE}$ (" + unit_Vbe + ')';
    stc.num1.label.y.String = 'Transconductance $g_m$ (S)';
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (g_m,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.YLim(1) = min(gm, [], 'all');
    %stc.num1.axes.YScale = 'log';
    stc_gm_Vbe_Vce = stc;
%%%%%%%%%%%%%%%%%

end

if gmfit == 0
    stc_gm_Vbe_Vce = 0;
    stc_gm_Ic_Vce = 0;
end


%% (Ib, Vbe, Vce)
% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Vce
        data_Ib(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Ib(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end
%%%%%%%%% (Ib, Vbe, Vce) 图片代码
% 数据处理
Ic =  data_Ib(:, 2)*amplification_Ib;    % Ic 单位转化
Vbe = data_Ib(:, 1)*amplification_Vbe;   % Vbe 单位转化
Vce = data_Ib(:, 5)*amplification_Vce;   % Vce 单位转化
leg_Vce = unique(data_Ib(:, 5))*amplification_Vce;   % 提取 Vrc 字符串

% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Base-Emitter Voltage $V_{BE}$" + ' (' + unit_Vbe + ')';
    stc.num1.label.y.String = "Base Current $I_{B}$ (" + unit_Ic + ')';
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (I_B,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = min(Ic);
    stc_Ib_Vbe_Vce = stc;
%%%%%%%%%


%% (beta, Vbe, Vce)
% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Vce
        data_Beta(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Beta(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end
%%%%%%%%% (Ib, Vbe, Vce) 图片代码
% 数据处理
Ic =  data_Beta(:, 2)*1;   % Ic 单位转化
Vbe = data_Beta(:, 1)*amplification_Vbe;   % Vbe 单位转化
Vce = data_Beta(:, 5)*amplification_Vce;   % Vce 单位转化
leg_Vce = unique(data_Beta(:, 5))*amplification_Vce;   % 提取 Vrc 字符串

% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  Vbe( Index(i, 1):Index(i, 2))', Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Base-Emitter Voltage $V_{BE}$" + ' (' + unit_Vbe + ')';
    stc.num1.label.y.String = "DC Current Gain $\beta$ (" + unit_Ic + ')';
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (I_B,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    %stc.num1.axes.YLim(1) = min(Ic);
    stc.num1.axes.YLim(1) = 0;
    stc_Beta_Vbe_Vce = stc;
%%%%%%%%%

%% (beta, Ic, Vce)
data_Beta = data_Ic;
data_Beta(:, 2) = data_Ic(:, 2)./data_Ib(:, 2);
% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Vce
        data_Beta(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Beta(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end
%%%%%%%%% (Ib, Vbe, Vce) 图片代码
% 数据处理
Ic =  data_Beta(:, 2)*1;   % Ic 单位转化
Vbe = data_Beta(:, 1)*amplification_Vbe;   % Vbe 单位转化
Vce = data_Beta(:, 5)*amplification_Vce;   % Vce 单位转化
leg_Vce = unique(data_Beta(:, 5))*amplification_Vce;   % 提取 Vrc 字符串

% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  data_Ic( Index(i, 1):Index(i, 2), 2)'*amplification_Ic, Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  data_Ic( Index(i, 1):Index(i, 2), 2)'*amplification_Ic, Ic(Index(i, 1):Index(i, 2))'  );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northeast';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Collector Current $I_C$" + ' (' + unit_Ic + ')';
    stc.num1.label.y.String = "DC Current Gain $\beta$ ";
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (I_B,\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    %stc.num1.axes.YLim(1) = min(Ic);
    stc.num1.axes.YLim(1) = 0;
    stc_Beta_Ic_Vce = stc;
%%%%%%%%%

%% (1/rpi, Vbe, Vce)
% 计算前后建议进行滤波, 且计算时需分组
    rpi = zeros(Index(1, 2) - 1, length_Vce);
    for i = 1:length_Vce
        % 注意 Ic 和 Vbe 的单位
        rpi(:, i) = diff(data_Ib(Index(i, 1):Index(i, 2), 1))./diff(data_Ib(Index(i, 1):Index(i, 2), 2));
    end
    rpi = MyFilter_mean(rpi, rpi_window);
    % 计算后的 gm 滤波:
    if 1
        rpi_filted = MyFilter_mean(rpi, 8);
        rpi_filted = MyFilter_mean(0.6*rpi + 0.4*rpi_filted, 8);
        rpi = MyFilter_mean(0.6*rpi + 0.4*rpi_filted, 5);
    end

%%%%%%%%% (rpi, Ic, Vce) 图片代码
% 数据处理
leg_Vce = unique(data_Beta(:, 5))*amplification_Vce;   % 提取 Vrc 字符串
% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  data_Ic( Index(i, 1):(Index(i, 2)-1), 2)'*amplification_Ic, 1./rpi(:, i)');
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  data_Ic( Index(i, 1):(Index(i, 2)-1), 2)'*amplification_Ic, 1./rpi(:, i)' );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Collector Current $I_C$" + ' (' + unit_Ic + ')';
    stc.num1.label.y.String = "Base Conductance $1/r_{\pi}$ (S)";
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (1/r_{\pi},\ I_C,\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 0;
    %stc.num1.axes.YScale = 'log';
    %stc.num1.axes.YLim = [10 1e3];
    stc.num1.axes.YLim = [0, 0.02];
    stc_rpi_Ic_Vce = stc;
%%%%%%%%%

%%%%%%%%% (1/rpi, Vbe, Vce) 图片代码
% 作图
    c = MyGet_colors_nok;
    for i = 1:length_Vce
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(  data_Ib( Index(i, 1):(Index(i, 2)-1), 1 )'*amplification_Vbe, 1./rpi(:, i)' );
            stc.(['num', (num2str(i))]).plot.Color = c{i};
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes,  data_Ib( Index(i, 1):(Index(i, 2)-1), 1 )'*amplification_Vbe, 1./rpi(:, i)' );
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
        end
    end
% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{CE} = $ " + num2str(leg_Vce) + ' ' + unit_Vce;
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northwest';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = "Base-Emitter Voltage $V_{BE}$" + ' (' + unit_Vbe + ')';
    stc.num1.label.y.String = "Base Conductance $1/r_{\pi}$ (S)";
    stc.num1.axes.Title.String = name + " $(x,\ y,\ var) = (1/r_{\pi},\ V_{BE},\ V_{CE})$";
    stc.num1.axes.Title.Interpreter = 'latex';
    stc.num1.axes.XLim(1) = 600;
    stc.num1.axes.YScale = 'log';
    %stc.num1.axes.YLim = [10 1e3];
    stc.num1.axes.YLim = [1e-3, 0.1];
    %stc.num1.axes.YLim(1) = min(Ic);
    %stc.num1.axes.YLim(2) = 1e6;
    stc_rpi_Vbe_Vce = stc;
%%%%%%%%%
end