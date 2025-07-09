function stc = MyPlot_Bode_fourH_omega_2Y(Omega, func_H1, func_H2, func_H3, func_H4)
    theta1 = @(omega) rad2deg(angle(func_H1(omega)));
    H_dB1 = @(omega) 20 * log(abs(func_H1(omega)))./log(10);
    theta2 = @(omega) rad2deg(angle(func_H2(omega)));
    H_dB2 = @(omega) 20 * log(abs(func_H2(omega)))./log(10);
    theta3 = @(omega) rad2deg(angle(func_H3(omega)));
    H_dB3 = @(omega) 20 * log(abs(func_H3(omega)))./log(10);
    theta4 = @(omega) rad2deg(angle(func_H4(omega)));
    H_dB4 = @(omega) 20 * log(abs(func_H4(omega)))./log(10);
    
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    
    stc.ax1 = nexttile(stc.layout);
    stc.plot1 = MyPlot_ax(stc.ax1, Omega, [H_dB1(Omega); H_dB2(Omega);  H_dB3(Omega); H_dB4(Omega);]);
    stc.plot1.axes.XScale = 'log';
    %stc.plot1.leg.Visible = 'off';
    stc.plot1.label.x.String = '$\omega$ (rad/s)';
    stc.plot1.label.y.String = 'Magnitude (dB)';
    c = MyGet_colors;
    %stc.plot1.plot.plot_2.Color = c{5};
    
    
    stc.ax2 = nexttile(stc.layout);
    stc.plot2 = MyPlot_ax(stc.ax2, Omega, [theta1(Omega); theta2(Omega); theta3(Omega); theta4(Omega)]);
    stc.plot2.axes.XScale = 'log';
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = '$\omega$ (rad/s)';
    stc.plot2.label.y.String = 'Phase Angle $(^\circ)$';
    %stc.plot2.plot.plot_2.Color = c{5};
end