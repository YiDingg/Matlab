function stc_MyScatter = MyScatter3(ax, XData, YData, ZData)
%%
% 输入：
    % XData, YData, ZData: 应为 1*n 或 n*1 向量
% 输出：图像

%%  
% 准备工作
    MyColors = MyGet_colors;
    length_data = numel(ZData);
    Marker = '.';
    MarkerSize = 40;
    if length_data >= 200
        MarkerSize = 25;
    end

% 创建图窗并作图
    %stc_MyScatter.fig = figure('Name', 'Myscatter', 'Color', [1 1 1]);
    stc_MyScatter.axes = ax;   
    stc_MyScatter.scatter3 = scatter3(XData, YData, ZData);
        
        % 设置作图样式
        stc_MyScatter.scatter3.Marker = Marker;
        stc_MyScatter.scatter3.SizeData = MarkerSize;
        stc_MyScatter.scatter3.MarkerEdgeColor = MyColors{2};
        stc_MyScatter.scatter3.MarkerFaceColor = MyColors{2};

% 设置其它样式
    % 坐标轴
        stc_MyScatter.axes.FontName = "Times New Roman"; % 全局 FontName
        stc_MyScatter.axes.XGrid = 'on';
        stc_MyScatter.axes.YGrid = 'on';
        stc_MyScatter.axes.XLimitMethod = "padded";
        stc_MyScatter.axes.YLimitMethod = "padded";
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