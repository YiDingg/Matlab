function stc = MyPlot_FitAndRaw(fit, X, Y)
    stc.fig = figure('Color', [1 1 1]);
    stc.ax = axes('Parent',stc.fig, 'FontSize', 14); 
    stc.sca = MyScatter_ax(stc.ax, X, Y);
    if length(X) <= 10
        stc.sca.scatter.scatter_1.CData = 300;
        stc.sca.scatter.scatter_1.SizeData = 300;
    elseif length(X) <= 20
        stc.sca.scatter.scatter_1.CData = 200;
        stc.sca.scatter.scatter_1.SizeData = 200;
    elseif length(X) <= 50
        stc.sca.scatter.scatter_1.CData = 150;
        stc.sca.scatter.scatter_1.SizeData = 1500;
    elseif length(X) <= 100
        stc.sca.scatter.scatter_1.CData = 100;
        stc.sca.scatter.scatter_1.SizeData = 100;
    elseif length(X) <= 500
        stc.sca.scatter.scatter_1.CData = 70;
        stc.sca.scatter.scatter_1.SizeData = 70;
    elseif length(X) <= 1000
        stc.sca.scatter.scatter_1.CData = 40;
        stc.sca.scatter.scatter_1.SizeData = 40;
    else
        stc.sca.scatter.scatter_1.CData = 30;
        stc.sca.scatter.scatter_1.SizeData = 30;
    end
    stc.sca.scatter.scatter_1.MarkerEdgeColor = 'r';
    
    x_ra = (max(X) - min(X));
    x_array = linspace(min(X) - 0.05*x_ra, max(X) + 0.05*x_ra, 500);
    stc.pl = MyPlot_ax(stc.ax, x_array, fit(x_array)');
    if length(X) <= 9
        stc.pl.plot.plot_1.LineWidth = 2;
    else
        stc.pl.plot.plot_1.LineWidth = 1;
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
        stc.leg.String = ["Raw data"; "Fitted curve"];
end