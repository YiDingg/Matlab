function stc_MyYYPlot = MyYYPlot(X_1, X_2, Y_1, Y_2)
% 给定数据，作出双纵轴 2-D 函数图像
% 输入格式：MyYYPlot([X_1; X_2], [Y_1; Y_2])

    % 准备参数
        MyColor = [
          [0 0 1]   % 蓝色
          [1 0 1]   % 粉色
          [0 1 0]   % 绿色 
          [1 0 0]   % 红色 
          [0 0 0]   % 黑色 
          [0 1 1]   % 青色
        ];
        %{
        X_1 = X1_X2(1, :);
        X_2 = X1_X2(2, :);
        Y_1 = Y1_Y2(1, :);
        Y_2 = Y1_Y2(2, :);
        %}
        if length(X_1) >= 100
            Marker_1 = 'none';
            LineWidth_1 = 2;
        elseif length(X_1) < 100
            Marker_1 = '.';
            LineWidth_1 = 1.5;
        end
        if length(X_2) >= 100
            Marker_2 = 'none';
            LineWidth_2 = 2;
        elseif length(X_2) < 100
            Marker_2 = '.';
            LineWidth_2 = 1.5;
        end
        pad_rate = 0.1;

    % 创建图窗
        stc_MyYYPlot.fig = figure('Name', 'MyYYPlot', 'Color', [1, 1, 1]);
        stc_MyYYPlot.axes = axes('Parent', stc_MyYYPlot.fig, 'FontSize', 17);   
        hold(stc_MyYYPlot.axes, 'on');
        
    % 作图
        % 作出 p_left
            yyaxis(stc_MyYYPlot.axes, "left")
            stc_MyYYPlot.p_left = plot(X_1, Y_1);
        % 设置 p_left 样式
            stc_MyYYPlot.p_left.LineWidth = LineWidth_1;
            stc_MyYYPlot.p_left.Marker = Marker_1;
            stc_MyYYPlot.p_left.MarkerSize = 10;
            stc_MyYYPlot.p_left.Color = MyColor(1, :);
            stc_MyYYPlot.label.y_left = ylabel(stc_MyYYPlot.axes, '$y_1$', 'Interpreter', 'latex', 'FontSize', 17);
            stc_MyYYPlot.axes.YColor = MyColor(1, :);   % 左侧蓝色
            stc_MyYYPlot.axes.YLimitMethod = 'tight';
            range = stc_MyYYPlot.axes.YLim(2) - stc_MyYYPlot.axes.YLim(1);
            stc_MyYYPlot.axes.YLim(1) = stc_MyYYPlot.axes.YLim(1) - pad_rate*range;
            stc_MyYYPlot.axes.YLim(2) = stc_MyYYPlot.axes.YLim(2) + pad_rate*range;
            stc_MyYYPlot.axes.TickLabelInterpreter = 'latex';

        % 作出 p_right
            yyaxis(stc_MyYYPlot.axes, "right")
            stc_MyYYPlot.p_right = plot(X_2, Y_2);
        % 设置 p_right 样式
            stc_MyYYPlot.p_right.LineWidth = LineWidth_2;
            stc_MyYYPlot.p_right.Marker = Marker_2;
            stc_MyYYPlot.p_right.MarkerSize = 10;
            stc_MyYYPlot.p_right.Color = MyColor(2, :);
            stc_MyYYPlot.label.y_right = ylabel(stc_MyYYPlot.axes, '$y_2$', 'Interpreter', 'latex', 'FontSize', 17);
            stc_MyYYPlot.axes.YColor = MyColor(2, :);  % 右侧粉色
            stc_MyYYPlot.axes.YLimitMethod = 'tight';
            range = stc_MyYYPlot.axes.YLim(2) - stc_MyYYPlot.axes.YLim(1);
            stc_MyYYPlot.axes.YLim(1) = stc_MyYYPlot.axes.YLim(1) - pad_rate*range;
            stc_MyYYPlot.axes.YLim(2) = stc_MyYYPlot.axes.YLim(2) + pad_rate*range;

    % 设置其他样式
        % 坐标轴
            stc_MyYYPlot.axes.FontName = "Times New Roman"; % 全局 FontName
            stc_MyYYPlot.label.x = xlabel(stc_MyYYPlot.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 17);
            stc_MyYYPlot.axes.XGrid = 'on';
            stc_MyYYPlot.axes.YGrid = 'on';
            stc_MyYYPlot.axes.GridColor = 'black';
            %stc_MyYYPlot.axes.GridLineStyle = '--';
            stc_MyYYPlot.axes.XLimitMethod = "tight";
            stc_MyYYPlot.axes.Box = 'on';

        % 标题
            stc_MyYYPlot.axes.Title.String = '';
            stc_MyYYPlot.axes.Title.FontSize = 19;
            stc_MyYYPlot.axes.Title.FontWeight = "bold";
            stc_MyYYPlot.axes.Title.Interpreter = 'latex';
        
        
        % 图例
            stc_MyYYPlot.leg = legend(stc_MyYYPlot.axes, 'Location', 'best');
            stc_MyYYPlot.leg.FontSize = 17;
            stc_MyYYPlot.leg.String = ['$y_1$'; '$y_2$'];
            stc_MyYYPlot.leg.Interpreter = "latex";

    % 收尾
        yyaxis(stc_MyYYPlot.axes, "left")
        hold(stc_MyYYPlot.axes, 'on')
end
