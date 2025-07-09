function [fitresult, gof] = FitHaiMuHuoZi(Xdata, B)
%CREATEFIT(XDATA,B)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: Xdata
%      Y 输出: B
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 26-Nov-2024 23:20:30 自动生成


%% 拟合: '无标题拟合 1'。
[xData, yData] = prepareCurveData( Xdata, B );

% 设置 fittype 和选项。
ft = fittype( '0.16625308*10^(-6)*((0.011025+(x+a/2-b)^2)^(-1.5)+(0.011025+(x-a/2-b)^2)^(-1.5))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0.05 -0.01];
opts.StartPoint = [0.105 0.005];
opts.TolFun = 1e-11;
opts.TolX = 1e-11;
opts.Upper = [0.15 0.01];

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );



