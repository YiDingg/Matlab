function [stc1, stc2] = MyDataProcessor_Capacitor_NoResonantFrequency(data, unit, Export)
%{
data: 5*n 矩阵 (5 行多列)
    frequency
    Phase_deg
    Z
    R_s
    X_s
%}

% 找到谐振频率 (假设 data 已经过滤波处理)
    disp('Warning: resonant frequency > 10 MHz')
    f_0 = 0;

% 找到 1KHz 容值
    Index = data(1, :) > 1e3;
    f = data(1, Index(end));
    X_s = data(5, Index(end));
    C_1KHz = 1./(-2*pi*f*X_s);  % 单位 H

% 仅构建 C-Rs 模型
    L_s = 1/(C_1KHz*(2*pi*f_0)^2);
    f = data(1, :);
    X_s =  data(5, :);
    C_cr = 1./(-2*pi*f.*X_s);
    %L_lr = MyFilter_mean(L_lr, wind);
    %C_clr = 1./(-2*pi*f.*X_s + (2*pi*f).^2 *L_s);
    %L_lrc = MyFilter_mean(L_lrc, wind);

    switch unit
        case 'pF'
            multiplier = 10^12;
        case 'nF'
            multiplier = 10^9;
        case 'uF'
            multiplier = 10^6;
        case 'mF'
            multiplier = 10^3;
        case 'F'
            multiplier = 10^0;
    end
   
% 作输出准备
    str_R = [
    'Rs_100Hz '
    'Rs_1KHz  '
    'Rs_10KHz '
    'Rs_100KHz'
    'Rs_1MHz  '
    ];
    str_C = [
    'C_100Hz '
    'C_1KHz  '
    'C_10KHz '
    'C_100KHz'
    'C_1MHz  ' 
    ];

% 判断横坐标范围
    if data(1, end) > 8*10^6        % 说明结尾是 10MHz
        x_end = 10e6;
    elseif data(1, end) > 4*10^6    % 说明结尾是 5MHz
        x_end = 5e6;
    elseif data(1, end) > 0.8*10^6  % 说明结尾是 1MHz
        x_end = 1e6;
    elseif data(1, end) > 80*10^3  % 说明结尾是 100KHz
        x_end = 100e3;
    end

% 找到需要输出的值
    for i = 2:6
        x = find(data(1, :) > 10^i, 1);
        if x
            Index_out(i-1) = x;
        end
    end
    f_0 = x_end;
    Index_out = Index_out(0.8*f_0 > data(1, Index_out));
    C_out = 1./(-2*pi*data(1, Index_out).*X_s(Index_out));
    R_out = data(4, Index_out);
    % 将 R_out 保留适当有效数字
    R_out = MyGet_SignificantDigits(R_out, 4);
   
% 输出相关结果

    disp(' ')
    disp('C-Ls-Rs model: ')
    disp(['L_s = ', num2str(L_s*10^9, '%.2f'), ' nH'])
    disp(['using ', num2str(C_1KHz*multiplier), ' ', unit])
    disp(' ')
    for i = 1:length(Index_out)
        disp([str_C(i, :), ' = ', num2str(C_out(i)*multiplier, '%.2f'), ' ', unit])
    end
    disp(' ')
    for i = 1:length(Index_out)
        disp([str_R(i, :), ' = ', num2str(R_out(i)), ' Ohm'])
    end
    disp(' ')


% 作图 1
    stc1 = MyPlot_Capacitor(f, C_cr*multiplier); 
    stc1.label.y.String = ['Capacitance $C$ (', unit, ')'];
    f_max = x_end;
    xlim([100, f_max])
    C_min = min(C_cr(data(1, :)<f_max));
    C_max = max(C_cr(data(1, :)<f_max));
    ylim([0.9*C_min*multiplier, 1.01*C_max*multiplier])

% 作图 2
    stc2 = MyYYPlot_ImpedanceAndResistance(data(1, :), abs(data(3, :)), data(2, :), abs(data(4, :)), abs(data(5, :)));
    xlim(stc2.ax1, [100, x_end])
    xlim(stc2.ax2, [100, x_end])
    stc2.plot1.leg.Location = 'northeast';
    stc2.plot2.leg.Location = 'northeast';
    stc2.plot1.leg.Visible = 'off';
    stc2.plot2.leg.Visible = 'off';
    
% 调整图 2 纵坐标范围
    lg = logspace(-15, 8, 24);
  
    yyaxis(stc2.ax1, 'left'); 
    ylim_max = lg(find(max(data(3, :))./lg < 1, 1));
    ylim_min = lg(find(min(abs(data(3, :)))./lg < 1, 1) - 1);
    ylim(stc2.ax1, [ylim_min, ylim_max]);

    yyaxis(stc2.ax2, 'left'); 
    ylim_max = lg(find(max(abs(data(4, :)))./lg < 1, 1));
    ylim_min = lg(find(min(abs(data(4, :)))./lg < 1, 1) - 1);
    ylim(stc2.ax2, [ylim_min, ylim_max]);

    yyaxis(stc2.ax2, 'right'); 
    ylim_max = lg(find(max(abs(data(5, :)))./lg < 1, 1));
    if min(abs(data(5, :))) < lg(1)
        ylim_min = lg(1);
    else
        ylim_min = lg(find(min(abs(data(5, :)))./lg < 1, 1) - 1);
    end
    
    ylim(stc2.ax2, [ylim_min, ylim_max]);

% 保存 pdf
    windowSize = [800 730];

    MyFigure_ChangeSize(stc2.fig, windowSize);
    if Export
        MyExport_pdf_modal % 保存图 2
    end
    MyFigure_ChangeSize(stc1.fig, windowSize);
    if Export
        MyExport_pdf_modal % 保存图 1
    end
end