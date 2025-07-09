function stc = MyOscilloscope_MSO2202A_Read_TwoCh
    stc.stc_CH1 = MyOscilloscope_MSO2202A_Read_OneCh(1);
    stc.stc_CH2 = MyOscilloscope_MSO2202A_Read_OneCh(2);
    stc.myplot = MyPlot(stc.stc_CH2.time', [stc.stc_CH1.data'; stc.stc_CH2.data']);
    stc.myplot.plot.plot_1.Color = '#FFB90F';
    stc.myplot.plot.plot_2.Color = 'b';
    stc.myplot.plot.plot_2.LineStyle = '-';
    stc.myplot.leg.String = ["CH 1"; "CH 2"];
    stc.myplot.label.x.String = 'Time (s)';
    stc.myplot.label.y.String = 'Voltage (V)';
    MyFigure_ChangeSize_2048x512(stc.myplot.fig);
end