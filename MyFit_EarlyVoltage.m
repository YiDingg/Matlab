function [fitresult, gof] = MyFit_EarlyVoltage(Ic, rO)
%CREATEFIT(X,Y)
%  创建一个拟合。
%
%  要进行 '无标题拟合 1' 拟合的数据:
%      X 输入: X
%      Y 输出: Y
%  输出:
%      fitresult: 表示拟合的拟合对象。
%      gof: 带有拟合优度信息的结构体。
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 12-Mar-2025 16:42:15 自动生成


%% 拟合: '无标题拟合 1'。
% 通常第一个数据都是边界值, 异常概率较大, 因此舍去
[xData, yData] = prepareCurveData( Ic(2:end), rO(2:end) );

% 设置 fittype 和选项。
%ft = fittype(['(Va + ' num2str(Vce_mean) ')/x'], 'independent', 'x', 'dependent', 'y' );
ft = fittype('Va/x', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = 0.1;
opts.Robust = 'LAR';
opts.StartPoint = 0.5;
opts.Upper = 2000;
excludedPoints = yData < 85;
%opts.Exclude = excludedPoints;

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );
end