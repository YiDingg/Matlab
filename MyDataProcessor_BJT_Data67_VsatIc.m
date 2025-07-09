function stc_satvoltage_Ic = MyDataProcessor_BJT_Data67_VsatIc(data_Vcesat, data_Vbesat, data_window, name, unit_Ic, unit_Vbe, unit_Vce)
switch unit_Vce
    case 'V'
        amplification_Vce = 1;
    case 'mV'
        amplification_Vce = 1e3;
    case 'uV'
        amplification_Vce = 1e6;
end
switch unit_Vbe
    case 'V'
        amplification_Vbe = 1;
    case 'mV'
        amplification_Vbe = 1e3;
    case 'uV'
        amplification_Vbe = 1e6;
end
switch unit_Ic
    case 'A'
        amplification_Ic = 1;
    case 'mA'
        amplification_Ic = 1e3;
    case 'uA'
        amplification_Ic = 1e6;
end

% 依据 Vrb (I_b) 对数据分组
leg_Vrb = unique(data_Vcesat(:, 6));   % 提取 Vrb 字符串
length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
Index = zeros(length_Ib, 2);    % 左起始, 右终止
for i = 1:length_Ib
    Index(i, 1) = find(  round(data_Vcesat(:, 6), 4) == leg_Vrb(i)  , 1, 'first' );
    % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
    Index(i, 2) = find(  round(data_Vcesat(:, 6), 4) == leg_Vrb(i)   , 1, 'last' );
    % 找到最后一个
end


% 数据 (分组) 滤波, 不影响数据 size
if 1
    windowSize = data_window;  % 窗口大小
    b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
    a = 1;
    for i = 1:length_Ib
        data_Vcesat(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Vcesat(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
        data_Vbesat(Index(i, 1):Index(i, 2), [1 2]) = filter(b, a, data_Vbesat(Index(i, 1):Index(i, 2), [1 2]));  % 滤波
    end
end

Ic = zeros(length_Ib, Index(1, 2));
Vce_sat = zeros(length_Ib, Index(1, 2));
Vbe_sat = zeros(length_Ib, Index(1, 2));
for i = 1:length_Ib
    Ic(i, :) = data_Vcesat(Index(i, 1):Index(i, 2), 2)'*amplification_Ic;
    Vce_sat(i, :) = data_Vcesat(Index(i, 1):Index(i, 2), 1)'*amplification_Vce;
    Vbe_sat(i, :) = data_Vbesat(Index(i, 1):Index(i, 2), 1)'*amplification_Vbe;
end
Ic = mean(Ic, 1);
Vce_sat = mean(Vce_sat, 1);
Vbe_sat = mean(Vbe_sat, 1);
stc_satvoltage_Ic = MyPlot(Ic, [Vce_sat; Vbe_sat]);
stc_satvoltage_Ic.label.x.String = "Collector Current $I_C$ (" + unit_Ic + ')';
stc_satvoltage_Ic.label.y.String = "$V_{CE, sat}$ ("  + unit_Vce + ')' + " and $V_{BE, sat}$ ("  + unit_Vbe + ')';
%stc_satvoltage_Ic.axes.YScale = 'log';
stc_satvoltage_Ic.axes.XScale = 'log';
stc_satvoltage_Ic.axes.XLim(1) = 0;
stc_satvoltage_Ic.axes.YLim(1) = 0;
stc_satvoltage_Ic.leg.String = ["$V_{CE, sat}$ ("  + unit_Vce + '), $\beta = 10$'; "$V_{BE, sat}$ ("  + unit_Vbe + '), $\beta = 10$'];
stc_satvoltage_Ic.axes.Title.String = name + " $(x,\ y,\ var) = (V_{sat},\ I_C,\ \beta)$";
MyFigure_ChangeSize(stc_satvoltage_Ic.fig, [700 512]);
end