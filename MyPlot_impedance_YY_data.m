function stc = MyPlot_impedance_YY_data(F, Z_f_data)
    Z_dB = 20 * log(abs(Z_f_data))./log(10);
    theta = rad2deg(angle(Z_f_data));

    stc = MyYYPlot([F; F], [Z_dB; theta]);
    %stc.axes.XScale = 'log';
    %stc.axes.YScale = 'log';
    stc.leg.Visible = 'off';
    
    stc.label.x.String = '$f$ (Hz)';
    stc.label.y_left.String = 'Magnitude (dB)';
    stc.label.y_right.String = 'Phase $(^\circ)$';
end