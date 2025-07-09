function stc = MyDataProcessor_NMOS_Id_Vds(data)
% data: Vds Id Vgs Vrd Vrg

% 在滤波前提取 Vrg
    leg_str = unique(data(:, 5));
    
% 数据滤波
    %data = MyFilter_mean(data, 20);
    if 1
        windowSize = 20;  % 窗口大小
        b = (1/windowSize) * ones(1, windowSize);  % 滤波器系数
        a = 1;
        data = filter(b, a, data);  % 滤波
    end
    data = data';
    
    
    %MyPlot(data(1, :), data(2, :));
    
    
% 利用 Vrd 的极大极小值对数据进行分组
    if 0
        index_max = MyArrayProcessor_findLocalMinimum(-data(1, :)');
        index_max = [index_max; length(data(1, :))];
        
        index_min = MyArrayProcessor_findLocalMinimum(data(1, :)');
        index_min = [1; index_min(3:end)];
    end
% 利用 Vrg 对数据进行分组 (先滤波再分组, 降低转换影响)
    index_min = zeros(size(leg_str));
    index_max = zeros(size(leg_str));
    for i = 1:length(leg_str)
        x = find(round(data(5, :), 4) == round(leg_str(i), 4));
        index_min(i) = x(1);
        index_max(i) = x(end);
    end

% 作图
    c = MyGet_colors_nok;
    len = length(index_max);
    
    for i = 1:len
        if i == 1
            stc.(['num', (num2str(i))]) = MyPlot(data(1, index_min(i):index_max(i)), data(2, index_min(i):index_max(i)));
            stc.(['num', (num2str(i))]).plot.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        else
            stc.(['num', (num2str(i))]) = MyPlot_ax(stc.num1.axes, data(1, index_min(i):index_max(i)), data(2, index_min(i):index_max(i)));
            stc.(['num', (num2str(i))]).plot.plot_1.Color = c{i};
            %stc.(['num', (num2str(i))]).leg.String(i) = cellstr(num2str(leg_str(i, :)));
        end
    end

% 调整图像属性
    %stc.num1.axes.XLim(1) = 0 - stc.num1.axes.XLim(2)*0.001;
    %stc.num1.axes.YLim(1) = 0 - stc.num1.axes.YLim(2)*0.01;
    %stc.num1.axes.XLim(1) = 0;
    stc.num1.axes.YLim(1) = 0;
    str = "$V_{GS} = $ " + num2str(leg_str) + " V";
    %str = num2str(leg_str) + " V";
    stc.num1.leg.String = str;
    stc.num1.leg.FontSize = 10;
    stc.num1.leg.Location = 'northeast';
    MyFigure_ChangeSize(stc.num1.fig, [700 512]);
    stc.num1.label.x.String = 'Drain-Source Voltage $V_{DS}$ (V)';
    stc.num1.label.y.String = 'Drain-Source Current $I_{D}$ (A)';
end
