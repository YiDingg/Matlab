function stc = MyDataProcessor_NMOS_Rds_Vgs(data, R_sense)
% data: Vds Id Vgs Vrd Vrg

% 在滤波前提取 Vrd
    leg_str = unique(data(:, 4));
    
% 数据滤波
    data = MyFilter_mean(data, 3);
    if 1
        windowSize = 3;  % 窗口大小
        b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
        a = 1;
        data = filter(b, a, data);  % 滤波
    end
    data = data';
    
    
    %MyPlot(data(1, :), data(2, :));
    
    
% 利用 Vrg 的极大极小值对数据进行分组
    if 0
        index_max = MyArrayProcessor_findLocalMinimum(-data(1, :)');
        index_max = [index_max; length(data(1, :))];
        
        index_min = MyArrayProcessor_findLocalMinimum(data(1, :)');
        index_min = [1; index_min(3:end)];
    end
% 利用 Vrd 对数据进行分组 (先滤波再分组, 降低转换影响)
    for i = 1:length(leg_str)
        x = find(round(data(4, :), 4) == leg_str(i));
        index_min(i) = x(1);
        index_max(i) = x(end);
    end

% 从 Vrd 得到 Vds
    %Vds = Vrd - Id*R_sense
    % data1 = data3 - data2*R_sense
    V_DS = data(3, :) - data(2, :)*R_sense;
    R_DS = V_DS./data(2, :);

% 作图
    c = MyGet_colors_nok;
    s = MyGet_LineStyle_str;
    len = length(index_max);
    
    for i = 1:len
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(data(3, index_min(i):index_max(i)), R_DS(index_min(i):index_max(i)));
            stc.(['num', (num2str(i))]).plot.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes, data(3, index_min(i):index_max(i)), R_DS(index_min(i):index_max(i)));
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
            %stc.(['num', (num2str(i))]).plot.plot_1.LineStyle = s{mod(i, 4) + 1};

            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        end
    end

% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = -100;
    stc.num1.axes.YScale = 'log';
    str = "$V_{rd} = $ " + num2str(leg_str) + " V";
    %str = num2str(leg_str) + " V";
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northeast';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = 'Gate-Source Voltage $V_{GS}$ (V)';
    stc.num1.label.y.String = 'Drain-Source Resistance $R_{DS}$ ($\Omega$)';
end