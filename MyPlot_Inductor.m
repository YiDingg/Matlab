function stc = MyPlot_Inductor(f, L)
    stc = MyPlot(f, L);
    %ylim([1.85 2.05])
    %xlim([100, 30e3])
    stc.axes.XScale = 'log';
    stc.axes.XTick = logspace(0, 8, 9);
    stc.axes.XTickLabel = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz";  "10 MHz";  "100 MHz"];
    stc.label.x.String = 'Frequency $f$ (Hz)';
    stc.label.y.String = 'Inductance $L$ (xxxxxxxxxxxxx)';
end