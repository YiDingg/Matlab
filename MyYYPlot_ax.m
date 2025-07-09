function stc = MyYYPlot_ax(ax, X, Y)
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
        X_1 = X(1, :);
        X_2 = X(2, :);
        Y_1 = Y(1, :);
        Y_2 = Y(2, :);
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
        stc.axes = ax; 
        set(stc.axes, 'Fontsize', 17)
        hold(stc.axes, 'on');
        
    % 作图
        % 作出 p_left
            yyaxis(stc.axes, "left")
            stc.p_left = plot(X_1, Y_1);
        % 设置 p_left 样式
            stc.p_left.LineWidth = LineWidth_1;
            stc.p_left.Marker = Marker_1;
            stc.p_left.MarkerSize = 10;
            stc.p_left.Color = MyColor(1, :);
            stc.label.y_left = ylabel(stc.axes, '$y_1$', 'Interpreter', 'latex', 'FontSize', 17);
            stc.axes.YColor = MyColor(1, :);   % 左侧蓝色
            stc.axes.YLimitMethod = 'tight';
            range = stc.axes.YLim(2) - stc.axes.YLim(1);
            %stc.axes.YLim(1) = stc.axes.YLim(1) - pad_rate*range;
            %stc.axes.YLim(2) = stc.axes.YLim(2) + pad_rate*range;
            stc.axes.TickLabelInterpreter = 'latex';

        % 作出 p_right
            yyaxis(stc.axes, "right")
            stc.p_right = plot(X_2, Y_2);
        % 设置 p_right 样式
            stc.p_right.LineWidth = LineWidth_2;
            %stc.p_right.LineStyle = '-.';
            stc.p_right.Marker = Marker_2;
            stc.p_right.MarkerSize = 10;
            stc.p_right.Color = MyColor(2, :);
            stc.label.y_right = ylabel(stc.axes, '$y_2$', 'Interpreter', 'latex', 'FontSize', 17);
            stc.axes.YColor = MyColor(2, :);  % 右侧粉色
            stc.axes.YLimitMethod = 'tight';
            range = stc.axes.YLim(2) - stc.axes.YLim(1);
            %stc.axes.YLim(1) = stc.axes.YLim(1) - pad_rate*range;
            %stc.axes.YLim(2) = stc.axes.YLim(2) + pad_rate*range;

    % 设置其他样式
        % 坐标轴
            stc.axes.FontName = "Times New Roman"; % 全局 FontName
            stc.label.x = xlabel(stc.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 17);
            stc.axes.XGrid = 'on';
            stc.axes.YGrid = 'on';
            stc.axes.GridColor = 'black';
            %stc_MyYYPlot.axes.GridLineStyle = '--';
            stc.axes.XLimitMethod = "tight";
            stc.axes.Box = 'on';

        % 标题
            stc.axes.Title.String = '';
            stc.axes.Title.FontSize = 19;
            stc.axes.Title.FontWeight = "bold";
        
        
        % 图例
            stc.leg = legend(stc.axes, 'Location', 'best');
            stc.leg.FontSize = 17;
            stc.leg.String = ['$y_1$'; '$y_2$'];
            stc.leg.Interpreter = "latex";

    % 收尾
        yyaxis(stc.axes, "left")
        hold(stc.axes, 'on')
end
