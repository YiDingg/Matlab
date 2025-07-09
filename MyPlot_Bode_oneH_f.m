function MyPlot_Bode_oneH_f(F, H_f)
    H_dB = @(F) 20 * log(abs(H_f(F)))./log(10);
    theta = @(F) rad2deg(angle(H_f(F)));

    stc = MyYYPlot([F; F], [H_dB(F); theta(F)]);
    stc.axes.XScale = 'log';
    stc.leg.Visible = 'off';
    
    stc.label.x.String = '$f$ (Hz)';
    stc.label.y_left.String = 'Magnitude (dB)';
    stc.label.y_right.String = 'Phase Angle $(^\circ)$';
end