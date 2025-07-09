function stc_MyPlot = MyPlot3(XData, YData, ZData)
% 给定数据，作出 3-D 函数图像（注意输入的是行向量）
% 输入：
    % XData：横坐标，应为 1*n 行向量（共用）或 m 个行向量（m*n 矩阵）
    % YData：每一行代表一条线，应为多个 1*n 行向量，构成 m*n 矩阵
    % ZData：每一行代表一条线，应为多个 1*n 行向量，构成 m*n 矩阵
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
    
    MyColors = MyGet_colors;
    MyLineStyle = num2cell( ...
        [
        "-"  "--" "-." ":"
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

% 创建图窗
    stc_MyPlot.fig = figure('Name', 'MyPlot3', 'Color', [1 1 1]);
    stc_MyPlot.axes = axes('Parent', stc_MyPlot.fig,  'FontSize', 14);   
    % 提前 hold on 会导致作出二维图像

% 作图
for i = 1:num_YData
    if num_XData == 1
        stc_MyPlot.plot.(['plot_',num2str(i)]) = plot3(XData, YData(i,:), ZData(i,:));
    else 
        stc_MyPlot.plot.(['plot_',num2str(i)]) = plot3(XData(i,:), YData(i,:), ZData(i,:));
    end
    if i == 1
         hold(stc_MyPlot.axes, 'on');
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
        stc_MyPlot.axes.ZGrid = 'on';
        %stc_MyYYPlot.axes.GridLineStyle = '--';
        stc_MyPlot.axes.XLimitMethod = "padded";
        stc_MyPlot.axes.YLimitMethod = "padded";
        stc_MyPlot.axes.ZLimitMethod = "padded";
        stc_MyPlot.axes.Box = 'on';  
        stc_MyPlot.label.x = xlabel(stc_MyPlot.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyPlot.label.y = ylabel(stc_MyPlot.axes, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyPlot.label.z = zlabel(stc_MyPlot.axes, '$z$', 'Interpreter', 'latex', 'FontSize', 15);

    % 标题
        stc_MyPlot.axes.Title.String = '';
        stc_MyPlot.axes.Title.FontSize = 17;
        stc_MyPlot.axes.Title.FontWeight = 'bold';

    % 图例
        stc_MyPlot.leg = legend(stc_MyPlot.axes, 'Location', 'best');
        stc_MyPlot.leg.FontSize = 15;
        stc_MyPlot.leg.String = ['$z_1$';'$z_2$';'$z_3$';'$z_4$';'$z_5$'];
        stc_MyPlot.leg.Interpreter = "latex";

% 收尾
    hold(stc_MyPlot.axes,'off')
end
