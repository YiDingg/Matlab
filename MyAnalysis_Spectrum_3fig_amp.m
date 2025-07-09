function stc = MyAnalysis_Spectrum_3fig_amp(voltage, time, plot_time)
    if nargin == 2  % 未输入 plot_time
        plot_time = [min(time), max(time)];
    end

    stc = MyAnalysis_Spectrum(voltage, time, plot_time, 0); % 调用原始函数
    f = stc.f;
    P1 = stc.P1;
    P1_dB = stc.P1_dB;

    % 绘图准备
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(3, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    

    % 绘制信号时域图像
    stc.ax0 = nexttile(stc.layout);
    stc.ax0.Title.String = "Signal waveform" + ' (sampling frequency = ' + num2str(stc.Fs, '%.2e') + ')';
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

    % 绘制单边 amp 图 (线性横坐标)
    stc.ax1 = nexttile(stc.layout, 2);
    stc.ax1.Title.String = "Frequency spectrum" + ' (spectral resolution = ' + num2str(stc.resolution) + ' Hz)';
    stc.plot1 = MyPlot_ax(stc.ax1, f, P1);
    stc.scatter1 = MyScatter_ax(stc.ax1, f(index), P1(index));
    stc.scatter1.scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.scatter1.scatter.scatter_1.SizeData = markersize;
    stc.plot1.leg.Visible = 'off';
    stc.plot1.label.x.String = 'Frequency (Hz)';
    stc.plot1.label.y.String = 'Amplitude (V)';
    stc.ax1.YLim(1) = 0;

    % 绘制单边 amp 图 (对数横坐标)
    stc.ax4 = nexttile(stc.layout, 3);
    %stc.ax4.Title.String = 'Frequency Spectrum';
    stc.plot4 = MyPlot_ax(stc.ax4, f, P1);
    stc.scatter4 = MyScatter_ax(stc.ax4, f(index), P1(index));
    stc.scatter4.scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.scatter4.scatter.scatter_1.SizeData = markersize;
    stc.plot4.axes.XScale = 'log';
    stc.plot4.leg.Visible = 'off';
    stc.plot4.label.x.String = 'Frequency (Hz)';
    stc.plot4.label.y.String = 'Amplitude (V)';
    stc.ax4.YLim(1) = 0;


    MyFigure_ChangeSize(stc.fig, [1024, 256*3])

end
