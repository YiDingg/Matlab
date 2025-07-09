function stc = MyPlot_2window(X_1, Y_1, X_2, Y_2, flag_landscape)

    stc.fig = figure('Color', [1 1 1]);
    if flag_landscape
        stc.layout = tiledlayout(1, 2, 'Parent', stc.fig);
    else
        stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    end
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    stc.ax1 = nexttile(stc.layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyPlot_ax(stc.ax1, X_1, Y_1);
    %stc.plot1.axes.XScale = 'log';
    %stc.plot1.leg.Visible = 'off';
    %stc.plot1.leg.Location = 'southeast';
    %stc.plot1.leg.Visible = 'off';
    %stc.plot1.leg.String = ["Actual impedance"; "Ideal impedance";];
    %stc.plot1.label.x.String = '$x$ ()';
    %stc.plot1.label.x.Visible = 'off';
    %stc.plot1.axes.XTickLabel = '';
    stc.plot1.label.y.String = '$y$ ()';
    %c = MyGet_colors;
    %stc.plot1.plot.plot_2.Color = c{5};
    

        stc.ax2 = nexttile(stc.layout);
        stc.ax2.Title.Interpreter = 'latex';
    if 1
        stc.plot2 = MyPlot_ax(stc.ax2, X_2, Y_2);
        %stc.plot2.axes.XScale = 'log';
        %stc.plot2.leg.Visible = 'off';
        stc.plot2.label.x.String = '$x$ ()';
        stc.plot2.label.y.String = '$y$ ()';
        %stc.ax2.YTick = -180:45:180;
        %stc.plot2.plot.plot_2.Color = c{5};
    end

end