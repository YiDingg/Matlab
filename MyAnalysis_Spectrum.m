function stc = MyAnalysis_Spectrum(voltage, time, plot_time, plot_fig)
%{  
下面是最初的 FFT 代码 (... ~ 2025.03.27)
    % 计算采样频率
    Fs = 1 / mean(diff(time)); % 假设 time 是等间隔采样的
    T = 1/Fs;             % Sampling period       
    N = max(size(time));             % Length of signal
    % 执行傅里叶变换
    Y = fft(voltage);
    % 计算双边频谱 P2 和单边频谱 P1
    P2 = abs(Y).^2 / length(voltage);
    P1 = P2(1:(length(voltage)/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    % 定义单边频率轴
    %f = (0:(length(voltage)/2)-1) * Fs / length(voltage);
    %f = Fs * (0:(length(voltage)/2))/length(voltage); % 频率轴
    if mod(N, 2) == 0    % 偶数个采样点 
        f = linspace(0, Fs/2 - Fs/N, N/2);
    else
        f = linspace(0, Fs/2 - Fs/(2*N), (N+1)/2);
    end
    % 将频谱幅度转为电压
    P1 = P1/max(P1)*max(voltage);   % 这样得到的是 Amplitude, 即 Vpp/2
    % 将 dB 图设置为最大值在 0 dB
    P1_dB = 20*log(P1)/log(10);
    P1_dB = P1_dB - max(P1_dB);
%}

%{
下面是第二版的原始测试代码
    Fs = 500;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = 2000;             % Length of the sampling data
    
    
    disp(['频谱分辨率: ', num2str(Fs/(L - mod(L, 2)))])
    
    t = (0:L-1)*T;        % Time vector
    S = 3 + 0.7*sin(2*pi*50*t) + sin(2*pi*200*t);
    %S = S + 2*randn(size(t));
    figure
    plot(1000*t, S)
    title('Signal Corrupted with Zero-Mean Random Noise')
    xlabel('t (milliseconds)')
    ylabel('X(t)')
    
    Y = fft(S);
    P2 = abs(Y/L);  % the two-sided spectrum
    midpoint = (L + mod(L, 2))/2;
    P1 = P2(1:midpoint+1);   % single-sided spectrum
    P1(2:end-1) = 2*P1(2:end-1);
    
    f = (Fs + mod(L, 2)*Fs/L) * (0:midpoint) / L;
    f_P2 = Fs*(0:L-1)/L;
    plot(f,P1)
    plot(f_P2, P2)
    title('Single-Sided Amplitude Spectrum of X(t)')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
%}

% 下面是第二版 FFT 代码 (2025.03.27 ~ ...)
% 参考了 https://zhuanlan.zhihu.com/p/443376634, 部分代码细节是实验出来的, 原理待探究

    Fs = 1 / mean(diff(time));  % 假设 time 是等间隔采样的            % Sampling frequency                    
    Ts = 1/Fs;                   % Sampling period       
    L = max(size(time));        % Length of the sampling data
    disp(['采样频率：', num2str(Fs), ' Hz']);
    resolution = Fs/(L - mod(L, 2));
    disp(['频谱分辨率: ', num2str(resolution), ' Hz'])  % 这里的 L - mod(L, 2) 是实验出来的 
    disp(['Time range: ', num2str(time(1)), ' to ', num2str(time(end))])

    Y = fft(voltage);   % fast fourier transform
    P2 = abs(Y/L);  % the two-sided spectrum
    midpoint = (L + mod(L, 2)) / 2;   % 实验所得
    P1 = P2(1:(midpoint+1));   % single-sided spectrum
    P1(2:(end-1)) = 2*P1(2:(end-1));
    
    f = (Fs + mod(L, 2)*Fs/L) * (0:midpoint) / L;   % 定义单边频率轴, mod(L, 2)*Fs/L 是实验结论
    P1_dB = 20*log(P1)/log(10);
    P1_dB = P1_dB - max(P1_dB); % 纵轴归一化 (将 dB 图设置为最大值在 0 dB)

    % 保存计算结果
    stc.f = f;
    stc.L = L;
    stc.Fs = Fs;
    stc.Ts = Ts;
    stc.P1 = P1;
    stc.P1_dB = P1_dB;
    stc.P2 = P2;
    stc.resolution = resolution;

if nargin == 3  % 正常作图
    
    % 绘图准备
    stc.fig = figure('Color', [1 1 1]);
    stc.layout = tiledlayout(5, 1, 'Parent', stc.fig);
    stc.layout.TileSpacing = 'compact';
    stc.layout.Padding = 'compact';
    

    i = 1;
    % 绘制信号时域图像
    stc.(['ax',num2str(i)]) = nexttile(stc.layout);
    stc.(['ax',num2str(i)]).Title.String = 'Signal Waveform';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, voltage);
    %stc.plot0.axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';
    if size(plot_time, 1) ~= 1 || size(plot_time, 2) ~= 1 
        xlim(plot_time)
    end
    
    

    i = i+1;
    % 找到幅度最大的三个频率
    [~, index] = sort(P1, 'descend'); % P1 降序排序
    index = index(1:3);
    markersize = 400;
    % 绘制单边频谱 (线性横坐标)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, 2);
    stc.(['ax',num2str(i)]).Title.String = 'Frequency Spectrum';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, P1);
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), P1(index));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Amplitude (V)';
    

    i = i+1;
    % 绘制单边 dB 图 (线性横坐标)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, 3);
    stc.(['ax',num2str(i)]).Title.String = 'Frequency Spectrum';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, P1_dB);
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), P1_dB(index));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Amplitude (dB)';
    
    i = i+1;
    % 绘制单边 dB 图 (对数横坐标)
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, 4);
    stc.(['ax',num2str(i)]).Title.String = 'Frequency Spectrum';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), f, P1_dB  );
    stc.(['scatter',num2str(i)]) = MyScatter_ax(stc.(['ax',num2str(i)]), f(index), P1_dB(index));
    stc.(['scatter',num2str(i)]).scatter.scatter_1.MarkerEdgeColor = 'red';
    stc.(['scatter',num2str(i)]).scatter.scatter_1.SizeData = markersize;
    stc.(['plot',num2str(i)]).axes.XScale = 'log';
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Frequency (Hz)';
    stc.(['plot',num2str(i)]).label.y.String = 'Amplitude (dB)';

    i = i+1;
    % 从频域重建时域信号
    voltage_iff = ifft(Y);
    % 绘制信号重建图像
    stc.(['ax',num2str(i)]) = nexttile(stc.layout, 5);
    stc.(['ax',num2str(i)]).Title.String = 'Reconstructed Signal Waveform';
    stc.(['plot',num2str(i)]) = MyPlot_ax(stc.(['ax',num2str(i)]), time, voltage_iff);
    stc.(['plot',num2str(i)]).leg.Visible = 'off';
    stc.(['plot',num2str(i)]).label.x.String = 'Time (s)';
    stc.(['plot',num2str(i)]).label.y.String = 'Voltage (V)';
    if size(plot_time, 1) ~= 1 || size(plot_time, 2) ~= 1 
        xlim(plot_time)
    end

    MyFigure_ChangeSize(stc.fig, [1024 256*i])

end

end
