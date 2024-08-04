function stc_MyPlot = MyPlot(XData, YData, XYLabel)
% 给定数据，作出 2-D 函数图像（注意输入的是行向量！）
% 输入：
    % XData：横坐标，应为 1*n 行向量（共用）
    % YData：每一行代表一条线，应为多个 1*n 行向量，构成 m*n 矩阵
    % XYLabel：[xlabel; ylabel]
% 输出：图像

    % 准备参数
    MyColor = [
      [0 0 1]   % 蓝色
      [1 0 1]   % 粉色
      [0 1 0]   % 绿色 
      [1 0 0]   % 红色 
      [0 0 0]   % 黑色 
      [0 1 1]   % 青色
    ];
    m = length(YData(:,1));
    %si = size(XData);

    % 创建图窗
    stc_MyPlot.fig = figure('Name','MyPlot','Color',[1 1 1]);
    stc_MyPlot.axes = axes('Parent',stc_MyPlot.fig);   
    hold(stc_MyPlot.axes,'on');

    % 作图
    for i = 1:1:m
        line = plot(XData, YData(i,:));
        % 设置样式
        line.LineWidth = 1.3;
        line.Marker = '.';
        line.MarkerSize = 7;
        line.Color = MyColor(i,:);
    end

    % 设置样式
    % title(stc_myplot.axes,'Title here, $y = f(x)$','Interpreter','latex')
    xlabel(stc_MyPlot.axes, XYLabel(1,:),'Interpreter','latex')
    ylabel(stc_MyPlot.axes, XYLabel(2,:),'Interpreter','latex')
    % stc_myplot.axes.GridLineStyle = '--';
    % Myle = legend(stc_myplot.axes,'$y_1 = sin(x)$','$y_2 = cos(x)$','$y_3 = cos(\frac{x^2}{5})$','Interpreter', 'latex', 'Location', 'best');
    stc_MyPlot.leg = legend(stc_MyPlot.axes, 'Location', 'best');
    stc_MyPlot.leg.FontSize = 11;
    stc_MyPlot.leg.FontName = "TimesNewRoman";
    grid(stc_MyPlot.axes,"on") % show the grid
    axis(stc_MyPlot.axes,"padded") % show the axis
    % set(stc_myplot.axes, 'YLimitMethod','padded', 'XLimitMethod','padded')
            
    % 收尾
    hold(stc_MyPlot.axes,'on')
end
