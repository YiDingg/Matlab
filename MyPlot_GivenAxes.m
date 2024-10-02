function stc_MyPlot = MyPlot_GivenAxes(ax, XData, YData)
%% 给定数据，作出 2-D 函数图像（注意输入的是行向量）
% 输入：
    % XData：横坐标，应为 1*n 行向量（共用）或 m 个行向量（m*n 矩阵）
    % YData：每一行代表一条线，应为多个 1*n 行向量，构成 m*n 矩阵
% 输出：图像

%%
% 准备参数
    %{
        MyColors = [
          [0 0 1]   % 蓝色
          [1 0 1]   % 粉色
          [0 1 0]   % 绿色 
          [1 0 0]   % 红色 
          [0 0 0]   % 黑色 
          [0 1 1]   % 青色
          [1 1 0]   % 黄色
        ];
    %}
    
    MyColors = GetMyColors;
    MyLineStyle = num2cell( ...
        [
        "-"  ":" "-." "--" 
        ]' ...
    );
    num_XData = size(XData, 1);
    num_YData = size(YData, 1);
    length_data = size(YData, 2);
    if length_data ~= size(XData, 2)
        XData = XData';
        num_XData = size(XData, 1);
    end
    if length_data >= 100
        Marker = 'none';
        LineWidth = 2;
    else 
        Marker = '.';
        LineWidth = 1.5;
    end

% 创建图窗并作图
    stc_MyPlot.axes = ax; 
    hold(stc_MyPlot.axes, 'on');
    for i = 1:num_YData
        if num_XData == 1
            stc_MyPlot.plot.(['plot_',num2str(i)]) = plot(XData, YData(i,:));
        else 
            stc_MyPlot.plot.(['plot_',num2str(i)]) = plot(XData(i,:), YData(i,:));
        end
        % 设置作图样式
            stc_MyPlot.plot.(['plot_',num2str(i)]).LineWidth = LineWidth;
            stc_MyPlot.plot.(['plot_',num2str(i)]).Marker = Marker;
            stc_MyPlot.plot.(['plot_',num2str(i)]).MarkerSize = 10;
            stc_MyPlot.plot.(['plot_',num2str(i)]).Color = MyColors{i};
            stc_MyPlot.plot.(['plot_',num2str(i)]).LineStyle = MyLineStyle{mod(i-1,4)+1};
    end


% 设置样式
    % 坐标轴
        stc_MyPlot.axes.FontName = "Times New Roman"; % 全局 FontName
        stc_MyPlot.axes.XGrid = 'on';
        stc_MyPlot.axes.YGrid = 'on';
        %stc_MyYYPlot.axes.GridLineStyle = '--';
        stc_MyPlot.axes.XLimitMethod = "padded";
        stc_MyPlot.axes.YLimitMethod = "padded";
        stc_MyPlot.axes.Box = 'on';  
        stc_MyPlot.label.x = xlabel(stc_MyPlot.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyPlot.label.y = ylabel(stc_MyPlot.axes, '$y$', 'Interpreter', 'latex', 'FontSize', 15);

    % 标题
        %stc_MyPlot.axes.Title.String = 'Figure: MyPlot';
        stc_MyPlot.axes.Title.FontSize = 17;
        stc_MyPlot.axes.Title.FontWeight = 'bold';

    % 图例
        stc_MyPlot.leg = legend(stc_MyPlot.axes, 'Location', 'best');
        stc_MyPlot.leg.FontSize = 15;
        stc_MyPlot.leg.String = ['$y_1$'; '$y_2$'; '$y_3$'; '$y_4$'; '$y_5$'; '$y_6$'; '$y_7$'; '$y_8$'; '$y_9$';];
        stc_MyPlot.leg.Interpreter = "latex";

    % 收尾
        hold(stc_MyPlot.axes,'off')
end
