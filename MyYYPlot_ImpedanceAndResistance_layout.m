function stc = MyYYPlot_ImpedanceAndResistance_layout(layout, X, Z_abs, Phase_deg, Rs_abs, Xs_abs)
    Y_1 = [Z_abs; Phase_deg];
    Y_2 = [Rs_abs; Xs_abs];
    stc.ax1 = nexttile(layout);
    stc.ax1.Title.Interpreter = 'latex';
    stc.plot1 = MyYYPlot_ax(stc.ax1, [X; X], Y_1);
    stc.plot1.label.x.Visible = 'off';
    
    stc.ax2 = nexttile(layout);
    stc.ax2.Title.Interpreter = 'latex';
    stc.plot2 = MyYYPlot_ax(stc.ax2, [X; X], Y_2);

    stc.plot1.axes.XScale = 'log';
    stc.plot1.axes.YScale = 'log';
    yyaxis(stc.ax2, 'left');
    stc.plot2.axes.XScale = 'log';
    stc.plot2.axes.YScale = 'log';
    yyaxis(stc.ax2, 'right');
    stc.plot2.axes.YScale = 'log';
    
    stc.plot2.label.y_left.String = 'Absulote Series Resistance $|R_s|\ (\Omega)$';
    stc.plot2.label.y_right.String = 'Absulote Series Reactance $|X_s|\ (\Omega)$';
    stc.plot2.label.x.String = 'Frequency $f$ (Hz)';
    stc.plot2.leg.Location = 'northwest';
    stc.plot2.leg.String = ["Series Resistance $|R_s|\ (\Omega)$"; "Series Reactance $|X_s|\ (\Omega)$"];
    
    
    stc.plot1.p_right.LineStyle = ':';
    stc.plot1.label.y.String = 'Impedance ($\Omega) and Phase';
    stc.plot1.label.y_left.String = 'Impedance ($\Omega$)';
    stc.plot1.label.y_right.String = 'Phase ($^\circ$)';
    stc.plot1.label.x.Visible = 'off';
    stc.plot1.leg.Location = 'northwest';
    stc.plot1.leg.String = ["Impedance $|Z|$ ($\Omega$)"; "Phase $\theta$ ($^\circ$)"];
    %yyaxis(stc.plot1.axes, 'right');
    %stc.plot1.axes.YLimitMethod = 'tight';
    
    if X(end) > 8*10^6        % 说明结尾是 10MHz
        XTick_array = logspace(0, 7, 8);
        XLabel_str = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz";  "10 MHz"];
    elseif X(end) > 4*10^6    % 说明结尾是 5MHz
        XTick_array = [logspace(0, 6, 7), 5*10^6];
        XLabel_str = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz";  "5 MHz"];
    else                      % 说明结尾是 1MHz 或其它
        XTick_array = logspace(0, 6, 7);
        XLabel_str = ["1 Hz"; "10 Hz"; "100 Hz";  "1 KHz";  "10 KHz";  "100 KHz";  "1 MHz"];
    end

    YTick_array = logspace(-4, 10, 15);
    YLabel_str = ...
    [
        "$10^{-4}$"; "$10^{-3}$"; "$10^{-2}$"; "$10^{-1}$"; "$10^{0}$"; 
        "$10^{1}$"; "$10^{2}$"; "$10^{3}$"; "$10^{4}$"; "$10^{5}$"; "$10^{6}$"; "$10^{7}$"; 
        "$10^{8}$"; "$10^{9}$"; "$10^{10}$"; 
    ];

    yyaxis(stc.ax1, 'right');
    stc.ax1.YTick = -180:15:180;
    stc.ax1.XTick = XTick_array;
    stc.ax1.XTickLabel = XLabel_str;

    yyaxis(stc.ax1, 'left');
    stc.ax1.XTick = XTick_array;
    stc.ax1.XTickLabel = XLabel_str;
    stc.ax1.YTick = YTick_array;
    stc.ax1.YTickLabel = YLabel_str;


    yyaxis(stc.ax2, 'left');
    stc.ax2.XTick = XTick_array;
    stc.ax2.XTickLabel = XLabel_str;
    stc.ax2.YTick = YTick_array;
    stc.ax2.YTickLabel = YLabel_str;
    yyaxis(stc.ax2, 'right');
    stc.ax2.YTick = YTick_array;
    stc.ax2.YTickLabel = YLabel_str;

    yyaxis(stc.ax2, 'left');
    ylimdata = stc.ax2.YLim;
    yyaxis(stc.ax2, 'right');
    stc.ax2.YLim = [min(ylimdata(1), stc.ax2.YLim(1)), max(ylimdata(2), stc.ax2.YLim(2))];
    ylimdata = stc.ax2.YLim;
    yyaxis(stc.ax2, 'left');
    stc.ax2.YLim = ylimdata;
end
