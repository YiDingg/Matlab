function stc = MyPlot_Capacitor_2models(f, C_cr, C_clr)
    stc = MyPlot(f, [C_cr; C_clr]);
    %ylim([1.85 2.05])
    %xlim([100, 30e3])
    stc.axes.XScale = 'log';
    stc.axes.XTick = logspace(0, 8, 9);
    stc.axes.XTickLabel = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz";  "10 MHz";  "100 MHz"];
    stc.label.x.String = 'Frequency $f$ (Hz)';
    stc.label.y.String = 'Capacitance $C$ (xxxxxxxxxxxxx)';
    stc.leg.String = ["$C$-$R_s$ Model, $C = \frac{1}{-\omega X_s}$"; "$C$-$L_s$-$R_s$ Model, $C = \frac{1}{- \omega X_s + \omega^2 L}$";];
    stc.leg.Location = 'northeast';
    stc.axes.YMinorTick = 'on';
end