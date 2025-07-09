function stc = MyPlot_Inductor_2models(f, L_lr, L_lrc)
    stc = MyPlot(f, [L_lr; L_lrc]);
    %ylim([1.85 2.05])
    %xlim([100, 30e3])
    stc.axes.XScale = 'log';
    stc.axes.XTick = logspace(0, 8, 9);
    stc.axes.XTickLabel = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz";  "10 MHz";  "100 MHz"];
    stc.label.x.String = 'Frequency $f$ (Hz)';
    stc.label.y.String = 'Inductance $L$ (xxxxxxxxxxxxx)';
    stc.leg.String = ["$L$-$R_s$ Model, $L = \frac{X_s}{\omega}$"; "$L$-$C_p$-$R_s$ Model, $L = \frac{X_s}{\omega + X_s \omega^2 C_p}$";];
    stc.leg.Location = 'northeast';
end