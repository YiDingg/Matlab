function stc = MyDataProcessor_OpAmp_ACGain_10Hzto1MHz(data, flag_using_51kOhm_10nF)
% data: 1    2     3    4
%       f  angle  Vin  Vout
%%
% 读取数据
f           = data(:, 1)';
InputPhase  = data(:, 2)';
V_in_abs    = data(:, 3)';     % AC INPUT, 为参考相位
V_out_abs   = data(:, 4)';     % TP2

V_out_phase = - InputPhase;

% 读取电阻电容值
if flag_using_51kOhm_10nF % 51 kOhm + 10 nF
    R_9 = 51e3;
    C_3 = 10e-8;
else % 1 MOhm + 1 nF
    R_9 = 1e6;
    C_3 = 1e-9;
end

% 对数据后半段进行滤波
if 1
    index = floor(length(f)*0.75):length(f);
    window = 20;
    InputPhase(index) = MyFilter_mean(InputPhase(index), window);
    V_in_abs(index) = MyFilter_mean(V_in_abs(index), window);
    V_out_phase(index) = MyFilter_mean(V_out_phase(index), window);
end

% 再对数据整体进行滤波
window = 3;
InputPhase = MyFilter_mean(InputPhase, window);
V_in_abs = MyFilter_mean(V_in_abs, window);
V_out_phase = MyFilter_mean(V_out_phase, window);

% 将模长和相位转化为复数表达
R_1 = 100;
v_acin = V_in_abs;
v_TP2 = V_out_abs .* (cosd(V_out_phase) + 1j*sind(V_out_phase));

% 求解并作出 A_v 波特图
A_v = ( 1 + R_9/R_1 + 1./(1j*2*pi.*f*R_1*C_3) ) .* (- v_TP2./v_acin);
A_v_abs = abs(A_v);
A_v_dB = 20*log(A_v_abs)/log(10);
A_v_phase = MyArcTheta_complex_deg(A_v) - 360;
stc = MyYYPlot(f, f, A_v_dB, A_v_phase);
stc.axes.XScale = 'log';

% 调整图像属性
ylim([0 120])
%xlim([2e2, 2e5])
stc.axes.XTick = logspace(1, 6, 6);
stc.axes.XTickLabel = ["10 Hz", "100 Hz", "1 kHz", "10 kHz", "100 kHz", "1 MHz"];
yyaxis('right');
ylim([-180 0])
YTick = -180:22.5:0;
stc.axes.YTick = YTick;
stc.axes.YTickLabel =  num2str(YTick', '%.1f');
stc.axes.XScale = 'log';
stc.leg.String = ["Gain $A_v$ (dB)"; "Phase $\varphi\ (^\circ)$"];
stc.label.x.String = 'Frequency $f$';
stc.label.y_left.String = 'Open-Loop Small-Signal Gain $A_v$ (dB)';
stc.label.y_right.String = 'Output Phase Shift $\varphi\ (^\circ)$';

% 返回结果
stc.f = f;
stc.A_v = A_v;
stc.A_v_abs = A_v_abs;
stc.A_v_dB = A_v_dB;
stc.A_v_phase = A_v_phase;

end