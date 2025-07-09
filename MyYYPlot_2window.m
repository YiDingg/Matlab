function stc = MyYYPlot_2window(X, Y_1, Y_2)
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    stc.ax1 = nexttile(stc.layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyYYPlot_ax(stc.ax1, [X; X], Y_1);
    stc.plot1.label.x.Visible = 'off';
    
    stc.ax2 = nexttile(stc.layout);
    stc.ax2.Title.Interpreter = 'latex';
    stc.plot2 = MyYYPlot_ax(stc.ax2, [X; X], Y_2);
end
