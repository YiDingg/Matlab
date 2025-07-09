function stc = MyPlot_Bode_oneH_omega_2Y(Omega, func_H)
    theta = @(omega) rad2deg(angle(func_H(omega)));
    H_dB = @(omega) 20 * log(abs(func_H(omega)))./log(10);
    
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(2, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    
    
    stc.ax1 = nexttile(stc.layout);
    stc.plot1 = MyPlot_ax(stc.ax1, Omega, H_dB(Omega));
    stc.plot1.axes.XScale = 'log';
    stc.plot1.leg.Visible = 'off';
    stc.plot1.label.x.String = '$\omega$ (rad/s)';
    stc.plot1.label.y.String = 'Magnitude (dB)';
    
    
    stc.ax2 = nexttile(stc.layout);
    stc.plot2 = MyPlot_ax(stc.ax2, Omega, theta(Omega));
    stc.plot2.axes.XScale = 'log';
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = '$\omega$ (rad/s)';
    stc.plot2.label.y.String = 'Phase Angle $(^\circ)$';
end