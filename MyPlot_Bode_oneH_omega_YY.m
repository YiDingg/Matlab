function stc = MyPlot_Bode_oneH_omega_YY(Omega, func_H)
    H_dB = @(omega) 20 * log(abs(func_H(omega)))./log(10);
    theta = @(omega) rad2deg(angle(func_H(omega)));

    stc = MyYYPlot([Omega; Omega], [H_dB(Omega); theta(Omega)]);
    stc.axes.XScale = 'log';
    stc.leg.Visible = 'off';
    
    stc.label.x.String = '$\omega$ (rad/s)';
    stc.label.y_left.String = 'Magnitude (dB)';
    stc.label.y_right.String = 'Phase Angle $(^\circ)$';
end