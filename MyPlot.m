function MyPlot(XData, YData, XYLabel)
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
    Myfigure = figure('NumberTitle','off','Name','MyPlot','Color',[1 1 1]);
    Myaxes = axes('Parent',Myfigure);   
    hold(Myaxes,'on');

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
    % title(Myaxes,'Title here, $y = f(x)$','Interpreter','latex')
    xlabel(Myaxes, XYLabel(1,:),'Interpreter','latex')
    ylabel(Myaxes, XYLabel(2,:),'Interpreter','latex')
    % Myaxes.GridLineStyle = '--';
    % Myle = legend(Myaxes,'$y_1 = sin(x)$','$y_2 = cos(x)$','$y_3 = cos(\frac{x^2}{5})$','Interpreter', 'latex', 'Location', 'best');
    Myle = legend(Myaxes, 'Location', 'best');
    Myle.FontSize = 11;
    Myle.FontName = "TimesNewRoman";
    grid(Myaxes,"on") % show the grid
    axis(Myaxes,"padded") % show the axis
    % set(Myaxes, 'YLimitMethod','padded', 'XLimitMethod','padded')
            
    % 收尾
    hold(Myaxes,'on')
end
