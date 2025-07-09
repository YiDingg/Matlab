function stc = MyPlot_TheoAndExpe(X, Y_expe, Y_theo)
    stc.fig = figure('Color', [1 1 1]);
    stc.ax = axes('Parent',stc.fig, 'FontSize', 14); 
    c = MyGet_colors;

    % 实验值
    stc.plot_expe = MyPlot_ax(stc.ax, X, Y_expe);
    stc.plot_expe.plot.plot_1.Color = c{6};
    if length(X) <= 9
        stc.plot_expe.plot.plot_1.LineWidth = 0.8;
    else
        stc.plot_expe.plot.plot_1.LineWidth = 0.5;
    end

    % scatter
    stc.sca = MyScatter_ax(stc.ax, X, Y_expe);
    if length(X) <= 10
        stc.sca.scatter.scatter_1.SizeData = 300;
    elseif length(X) <= 20
        stc.sca.scatter.scatter_1.SizeData = 200;
    elseif length(X) <= 30
        stc.sca.scatter.scatter_1.SizeData = 170;
    elseif length(X) <= 40
        stc.sca.scatter.scatter_1.SizeData = 150;
    else
        stc.sca.scatter.scatter_1.SizeData = 100;
    end
    stc.sca.scatter.scatter_1.MarkerEdgeColor = 'r';

    % 理论值
    stc.plot_theo = MyPlot_ax(stc.ax, X, Y_theo);
    stc.plot_theo.plot.plot_1.Color = c{1};
    if length(X) <= 9
        stc.plot_theo.plot.plot_1.LineWidth = 2;
    else
        stc.plot_theo.plot.plot_1.LineWidth = 1.3;
    end

    % 坐标轴
        stc.ax.FontName = "Times New Roman"; % 全局 FontName
        stc.ax.XGrid = 'on';
        stc.ax.YGrid = 'on';
        %stc_MyYYPlot.axes.GridLineStyle = '--';
        stc.ax.XLimitMethod = 'tight';
        stc.ax.YLimitMethod = 'tight';
        stc.ax.Box = 'on';  
        stc.label.x = xlabel(stc.ax, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc.label.y = ylabel(stc.ax, '$y$', 'Interpreter', 'latex', 'FontSize', 15);

    % 标题
        %stc.ax.Title.String = 'Figure: MyPlot';
        stc.ax.Title.FontSize = 17;
        stc.ax.Title.FontWeight = 'bold';
        stc.ax.Title.Interpreter = 'latex';

    % 图例
        stc.leg = legend(stc.ax, 'Location', 'best');
        stc.leg.FontSize = 15;
        stc.leg.Interpreter = "latex";
        stc.leg.String = [ "Experimental curve"; "Raw data"; "Theoretical curve" ];
end