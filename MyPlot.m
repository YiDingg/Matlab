function stc_MyPlot = MyPlot(XData, YData)
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
    
% 若输入是两个行向量, 转为列向量
if size(XData, 2) == 1 && size(YData, 2) == 1
    XData = XData';
    YData = YData';
end

    MyColors = MyGet_colors;
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
    if length_data <= 10
        Marker = '.';
        LineWidth = 1.7;
        MarkerSize = 20;
    elseif length_data <= 30
        Marker = '.';
        LineWidth = 1.5;
        MarkerSize = 15;
    elseif length_data <= 60
        Marker = '.';
        LineWidth = 1.5;
        MarkerSize = 10;
    else 
        Marker = 'none';
        LineWidth = 2;
        MarkerSize = 6; % 默认是 6
    end

% 创建图窗并作图
    stc_MyPlot.fig = figure('Name', 'MyPlot', 'Color', [1 1 1]);
    stc_MyPlot.axes = axes('Parent',stc_MyPlot.fig, 'FontSize', 18);   
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
            stc_MyPlot.plot.(['plot_',num2str(i)]).MarkerSize = MarkerSize;
            stc_MyPlot.plot.(['plot_',num2str(i)]).Color = MyColors{i};
            stc_MyPlot.plot.(['plot_',num2str(i)]).LineStyle = MyLineStyle{mod(i-1,4)+1};
    end


% 设置样式
    % 坐标轴
        stc_MyPlot.axes.FontName = "Times New Roman"; % 全局 FontName
        stc_MyPlot.axes.XGrid = 'on';
        stc_MyPlot.axes.YGrid = 'on';
        %stc_MyYYPlot.axes.GridLineStyle = '--';
        stc_MyPlot.axes.XLimitMethod = 'tight';
        stc_MyPlot.axes.YLimitMethod = 'tight';
        stc_MyPlot.axes.Box = 'on';  
        stc_MyPlot.label.x = xlabel(stc_MyPlot.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 18);
        stc_MyPlot.label.y = ylabel(stc_MyPlot.axes, '$y$', 'Interpreter', 'latex', 'FontSize', 18);

    % 标题
        %stc_MyPlot.axes.Title.String = 'Figure: MyPlot';
        stc_MyPlot.axes.Title.FontSize = 19;
        stc_MyPlot.axes.Title.FontWeight = 'bold';
        stc_MyPlot.axes.Title.Interpreter = 'latex';

    % 图例
        stc_MyPlot.leg = legend(stc_MyPlot.axes, 'Location', 'best');
        stc_MyPlot.leg.FontSize = 18;
        stc_MyPlot.leg.String = ['$y_1$'; '$y_2$'; '$y_3$'; '$y_4$'; '$y_5$'; '$y_6$'; '$y_7$'; '$y_8$'; '$y_9$';];
        stc_MyPlot.leg.Interpreter = "latex";
        if num_YData == 1
            stc_MyPlot.leg.Visible = 'off';
        end

    % 收尾
        hold(stc_MyPlot.axes,'off')
end
