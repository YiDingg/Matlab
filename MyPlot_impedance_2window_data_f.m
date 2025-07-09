function stc = MyPlot_impedance_2window_data_f(F, Z_data)
    Z_dB = 20 * log(abs(Z_data))./log(10);
    theta = rad2deg(angle(Z_data));
    
    %stc.label.x.String = '$f$ (Hz)';
    %stc.label.y_left.String = 'Magnitude (dB)';
    %stc.label.y_right.String = 'Phase $(^\circ)$';

    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    
    stc.ax1 = nexttile(stc.layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyPlot_ax(stc.ax1, F, Z_dB);
    stc.plot1.axes.XScale = 'log';
    %stc.plot1.leg.Visible = 'off';
    %stc.plot1.leg.String = ["Actual impedance"; "Ideal impedance";];
    stc.plot1.label.x.String = '$f$ (Hz)';
    stc.plot1.label.y.String = 'Magnitude (dB)';
    c = MyGet_colors;
    %stc.plot1.plot.plot_2.Color = c{5};
    
    
    stc.ax2 = nexttile(stc.layout);
    stc.ax2.Title.Interpreter = 'latex';
    stc.plot2 = MyPlot_ax(stc.ax2, F, theta);
    stc.plot2.axes.XScale = 'log';
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = '$f$ (Hz)';
    stc.plot2.label.y.String = 'Phase ($^\circ$)';
    %stc.ax2.YTick = -180:45:180;
    %stc.plot2.plot.plot_2.Color = c{5};

end