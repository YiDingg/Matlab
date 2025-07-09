function stc = MyPlot_twoY(X, Y)
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
   
    stc.ax1 = nexttile(stc.layout);
    stc.plot1 = MyPlot_ax(stc.ax1, X, Y(1, :));
    %stc.plot1.axes.XScale = 'log';
    stc.plot1.leg.Visible = 'off';
    stc.plot1.label.x.String = '';
    stc.plot1.label.y.String = '$y_1$';
    
    
    stc.ax2 = nexttile(stc.layout);
    stc.plot2 = MyPlot_ax(stc.ax2, X, Y(2, :));
    %stc.plot2.axes.XScale = 'log';
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = '$x$';
    stc.plot2.label.y.String = '$y_2$';
end