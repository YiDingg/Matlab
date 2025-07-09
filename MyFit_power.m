function [fitresult, gof, stc] = MyFit_power(X, Y, flag_plot)
[xData, yData] = prepareCurveData( X, Y );

% 设置 fittype 和选项。
ft = fittype( 'power1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
%opts.StartPoint = [0.0012925671730723 -0.531166706531917];
opts.Robust = 'Bisquare';
opts.Algorithm = 'Levenberg-Marquardt';

% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );

% 绘制数据拟合图。
stc = 0;
if flag_plot
    stc = MyPlot(xData, [yData'; fitresult(xData)']);
end


