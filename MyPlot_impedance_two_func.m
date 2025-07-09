function stc = MyPlot_impedance_two_func(Omega, func_Z_actual, func_Z_ideal)
    theta1 = @(omega) rad2deg(angle(func_Z_actual(omega)));
    Z_abs_1 = @(omega) 20 * log(abs(func_Z_actual(omega)))./log(10);
    theta2 = @(omega) rad2deg(angle(func_Z_ideal(omega)));
    Z_abs_2 = @(omega) 20 * log(abs(func_Z_ideal(omega)))./log(10);
    
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    
    stc.ax1 = nexttile(stc.layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyPlot_ax(stc.ax1, Omega, [Z_abs_1(Omega); Z_abs_2(Omega); ]);
    stc.plot1.axes.XScale = 'log';
    %stc.plot1.leg.Visible = 'off';
    stc.plot1.leg.String = ["Actual impedance"; "Ideal impedance";];
    stc.plot1.label.x.String = '$\omega$ (rad/s)';
    stc.plot1.label.y.String = '$|Z|$ (dB)';
    c = MyGet_colors;
    %stc.plot1.plot.plot_2.Color = c{5};
    
    
    stc.ax2 = nexttile(stc.layout);
    stc.ax2.Title.Interpreter = 'latex';
    stc.plot2 = MyPlot_ax(stc.ax2, Omega, [theta1(Omega); theta2(Omega)]);
    stc.plot2.axes.XScale = 'log';
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = '$\omega$ (rad/s)';
    stc.plot2.label.y.String = '$\arg Z\ (^\circ)$';
    stc.ax2.YTick = -180:45:180;
    %stc.plot2.plot.plot_2.Color = c{5};

end