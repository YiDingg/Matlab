function stc = MyAnalysis_Spectrum_4fig(voltage, time, plot_time)
    if nargin == 2  % 未输入 plot_time
        plot_time = range(time);
    end

    stc = MyAnalysis_Spectrum(voltage, time, plot_time, 0); % 调用原始函数
    f = stc.f;
    P1 = stc.P1;
    P1_dB = stc.P1_dB;

    % 绘图准备
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(4, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    

    % 绘制信号时域图像
    stc.ax0 = nexttile(stc.layout);
    stc.ax0.Title.String = 'Signal Waveform';
    stc.plot0 = MyPlot_ax(stc.ax0, time, voltage);
    %stc.plot0.axes.XScale = 'log';
    stc.plot0.leg.Visible = 'off';
    stc.plot0.label.x.String = 'Time (s)';
    stc.plot0.label.y.String = 'Voltage (V)';
    xlim(plot_time)

    

    % 找到幅度最大的三个频率
    [~, index] = sort(P1, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;
    % 绘制单边频谱 (线性横坐标)
    stc.ax1 = nexttile(stc.layout, 2);
    stc.ax1.Title.String = 'Frequency Spectrum';
    stc.plot1 = MyPlot_ax(stc.ax1, f, P1);
    stc.scatter1 = MyScatter_ax(stc.ax1, f(index), P1(index));
    stc.scatter1.scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.scatter1.scatter.scatter_1.SizeData = markersize;
    stc.plot1.leg.Visible = 'off';
    stc.plot1.label.x.String = 'Frequency (Hz)';
    stc.plot1.label.y.String = 'Amplitude';
    

    % 绘制单边 dB 图 (线性横坐标)
    stc.ax2 = nexttile(stc.layout, 3);
    stc.ax2.Title.String = 'Frequency Spectrum';
    stc.plot2 = MyPlot_ax(stc.ax2, f, P1_dB);
    stc.scatter2 = MyScatter_ax(stc.ax2, f(index), P1_dB(index));
    stc.scatter2.scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.scatter2.scatter.scatter_1.SizeData = markersize;
    stc.plot2.leg.Visible = 'off';
    stc.plot2.label.x.String = 'Frequency (Hz)';
    stc.plot2.label.y.String = 'Amplitude (dB)';
    
   

    % 绘制单边 dB 图 (对数横坐标)
    stc.ax3 = nexttile(stc.layout, 4);
    stc.ax3.Title.String = 'Frequency Spectrum';
    stc.plot3 = MyPlot_ax(stc.ax3, f, P1_dB  );
    stc.scatter3 = MyScatter_ax(stc.ax3, f(index), P1_dB(index));
    stc.scatter3.scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.scatter3.scatter.scatter_1.SizeData = markersize;
    stc.plot3.axes.XScale = 'log';
    stc.plot3.leg.Visible = 'off';
    stc.plot3.label.x.String = 'Frequency (Hz)';
    stc.plot3.label.y.String = 'Amplitude (dB)';
    

    MyFigure_ChangeSize(stc.fig, [1024 1024])

end
