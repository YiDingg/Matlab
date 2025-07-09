function [stc1, stc2] = MyDataProcessor_Inductor_NoResonantFrequency(data, unit, flag_export)
%{
data: 5*n 矩阵 (5 行多列)
    frequency
    Phase_deg
    Z
    R_s
    X_s
%}

ex = flag_export;

% 找到谐振频率 (假设 data 已经过滤波处理)
    disp('Warning: resonant frequency > 10 MHz')
    f_0 = 0;

% 找到 1KHz 感值
    Index = data(1, :) > 1e3;
    f = data(1, Index(end));
    X_s = data(5, Index(end));
    L_1KHz = X_s./(2*pi*f);  % 单位 H

% 构建 L-Rs 和 L-Rs-Cp 模型
    C_p = 1/(L_1KHz*(2*pi*f_0)^2);
    f = data(1, :);
    X_s =  data(5, :);
    L_lr = X_s./(2*pi*f);
    %L_lr = MyFilter_mean(L_lr, wind);
    L_lrc = X_s./( (2*pi*f) + X_s.*C_p.*(2*pi.*f).^2 );
    %L_lrc = MyFilter_mean(L_lrc, wind);

    switch unit
        case 'pH'
            multiplier = 10^12;
        case 'nH'
            multiplier = 10^9;
        case 'uH'
            multiplier = 10^6;
        case 'mH'
            multiplier = 10^3;
        case 'H'
            multiplier = 10^0;
    end
   
% 作输出准备
    str_R = [
    'DCR_100Hz'
    'Rs_1KHz  '
    'Rs_10KHz '
    'Rs_100KHz'
    'Rs_1MHz  '
    ];
    str_L = [
    'L_100Hz '
    'L_1KHz  '
    'L_10KHz '
    'L_100KHz'
    'L_1MHz  ' 
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
    L_out = X_s(Index_out)./(2*pi*data(1, Index_out));
    R_out = data(4, Index_out);
    % 将 R_out 保留 3 位有效数字
    R_out = MyGet_SignificantDigits(R_out, 4);
   
% 输出相关结果

    disp(' ')
    disp('L-Cp-Rs model: ')
    disp(['C_p = ', num2str(C_p*10^12, '%.2f'), ' pF'])
    disp(['using ', num2str(L_1KHz*multiplier), ' ', unit])
    disp(' ')
    for i = 1:length(Index_out)
        disp([str_L(i, :), ' = ', num2str(L_out(i)*multiplier, '%.2f'), ' ', unit])
    end
    disp(' ')
    for i = 1:length(Index_out)
        disp([str_R(i, :), ' = ', num2str(R_out(i)), ' Ohm'])
    end
    disp(' ')


% 作图 1
    stc1 = MyPlot_Inductor(f, L_lr*multiplier);
    %stc1 = MyPlot_Inductor_2models(f, L_lr*multiplier, L_lrc*multiplier); 
    stc1.label.y.String = ['Inductance $L$ (', unit, ')'];
    f_max = x_end;
    xlim([100, f_max])
    L_min = min(abs(L_lr));
    L_max = max(abs(L_lr));
    ylim(stc1.axes, [0.9*L_min*multiplier, 1.01*L_max*multiplier])

% 作图 2
    stc2 = MyYYPlot_ImpedanceAndResistance(data(1, :), abs(data(3, :)), data(2, :), abs(data(4, :)), abs(data(5, :)));
    xlim(stc2.ax1, [100, x_end])
    xlim(stc2.ax2, [100, x_end])
    
% 调整图 2 纵坐标范围
    lg = logspace(-8, 8, 17);
  
    yyaxis(stc2.ax1, 'left'); 
    ylim_max = lg(find(max(data(3, :))./lg < 1, 1));
    ylim_min = lg(find(min(data(3, :))./lg < 1, 1) - 1);
    ylim(stc2.ax1, [ylim_min, ylim_max]);

    yyaxis(stc2.ax2, 'left'); 
    ylim_max = lg(find(max(abs(data(4, :)))./lg < 1, 1));
    ylim_min = lg(find(min(abs(data(4, :)))./lg < 1, 1) - 1);
    ylim(stc2.ax2, [ylim_min, ylim_max]);

    yyaxis(stc2.ax2, 'right'); 
    ylim_max = lg(find(max(abs(data(5, :)))./lg < 1, 1));
    ylim_min = lg(find(min(abs(data(5, :)))./lg < 1, 1) - 1);
    ylim(stc2.ax2, [ylim_min, ylim_max]);

% 保存 pdf
    if ex
        MyExport_pdf_docked % 保存图 2
    end
        MyFigure_ChangeSize_2048x512(stc1.fig);
    if ex
        MyExport_pdf_modal % 保存图 1
    end
end