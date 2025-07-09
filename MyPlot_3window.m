function stc = MyPlot_3window(X, Y_1, Y_2, Y_3)

    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(1, 3, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    stc.ax1 = nexttile(stc.layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyPlot_ax(stc.ax1, X, Y_1);
    %stc.plot1.label.x.Visible = 'off';
    stc.plot1.label.y.String = '$y$ ()';

    stc.ax2 = nexttile(stc.layout);
    stc.ax2.Title.Interpreter = 'latex';
    if Y_2 ~= 0
        stc.plot2 = MyPlot_ax(stc.ax2, X, Y_2);
        %stc.plot2.axes.XScale = 'log';
        %stc.plot2.leg.Visible = 'off';
        stc.plot2.label.x.String = '$x$ ()';
        stc.plot2.label.y.String = '$y$ ()';
        %stc.ax2.YTick = -180:45:180;
        %stc.plot2.plot.plot_2.Color = c{5};
    end

    stc.ax3 = nexttile(stc.layout);
    stc.ax3.Title.Interpreter = 'latex';
    stc.plot3 = MyPlot_ax(stc.ax3, X, Y_3);
    %stc.plot3.label.x.Visible = 'off';
    stc.plot3.label.y.String = '$y$ ()';
end