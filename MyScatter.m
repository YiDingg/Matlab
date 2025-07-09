function stc_MyScatter = MyScatter(XData, YData)
%% 给定数据，作出 2-D 函数图像（注意输入的是行向量）
% 输入：
    % XData：横坐标，应为 1*n 行向量（共用）或 m 个行向量（m*n 矩阵）
    % YData：每一行代表一条线，应为多个 1*n 行向量，构成 m*n 矩阵
% 输出：图像

%%  
% 准备工作
    MyColors = MyGet_colors;
    num_XData = size(XData, 1);
    num_YData = size(YData, 1);
    length_data = size(YData, 2);
    if length_data ~= size(XData, 2)
        XData = XData';
        num_XData = size(XData, 1);
    end
    Marker = '.';
    MarkerSize = 40;
    if length_data >= 100
        MarkerSize = 25;
    end

% 创建图窗并作图
    stc_MyScatter.fig = figure('Name', 'Myscatter', 'Color', [1 1 1]);
    stc_MyScatter.axes = axes('FontSize', 14);   
    hold(stc_MyScatter.axes, 'on');

    for i = 1:num_YData
        if num_XData == 1
            stc_MyScatter.scatter.(['scatter_',num2str(i)]) = scatter(XData, YData(i,:));
        else
            stc_MyScatter.scatter.(['scatter_',num2str(i)]) = scatter(XData(i,:), YData(i,:));
        end
        
        % 设置作图样式
        stc_MyScatter.scatter.(['scatter_',num2str(i)]).Marker = Marker;
        stc_MyScatter.scatter.(['scatter_',num2str(i)]).SizeData = MarkerSize;
        stc_MyScatter.scatter.(['scatter_',num2str(i)]).MarkerEdgeColor = MyColors{i};
        stc_MyScatter.scatter.(['scatter_',num2str(i)]).MarkerFaceColor = MyColors{i};
    end

% 设置其它样式
    % 坐标轴
        stc_MyScatter.axes.FontName = "Times New Roman"; % 全局 FontName
        stc_MyScatter.axes.XGrid = 'on';
        stc_MyScatter.axes.YGrid = 'on';
        stc_MyScatter.axes.XLimitMethod = 'tight';
        stc_MyScatter.axes.YLimitMethod = 'tight';
        stc_MyScatter.axes.Box = 'on';  
        stc_MyScatter.label.x = xlabel(stc_MyScatter.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyScatter.label.y = ylabel(stc_MyScatter.axes, '$y$', 'Interpreter', 'latex', 'FontSize', 15);

    % 标题
        %stc_MyScatter.axes.Title.String = 'Figure: Myscatter';
        stc_MyScatter.axes.Title.FontSize = 17;
        stc_MyScatter.axes.Title.FontWeight = 'bold';

    % 图例
        stc_MyScatter.leg = legend(stc_MyScatter.axes, 'Location', 'best');
        stc_MyScatter.leg.FontSize = 15;
        stc_MyScatter.leg.String = ['$y_1$'; '$y_2$'; '$y_3$'; '$y_4$'; '$y_5$'; '$y_6$'; '$y_7$'; '$y_8$'; '$y_9$';];
        stc_MyScatter.leg.Interpreter = "latex";

    % 收尾
        hold(stc_MyScatter.axes,'off')
end

function rgbColor = MyHex2rgb(hexColor)
    %hexColor = cell(hexColor);
    rgbColor = sscanf(hexColor, '#%2x%2x%2x', [1,3])/255;
end