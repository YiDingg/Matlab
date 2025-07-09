function [fitresult, gof, stc] = MyFit_sqrt(X, Y, flag_plot)
[xData, yData] = prepareCurveData( X, Y );

ft = fittype( 'sqrt(A*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
%opts.Robust = 'Bisquare';
opts.StartPoint = 0.2;
opts.Lower = 1e-3;
opts.Upper = 2;
% 对数据进行模型拟合。
[fitresult, gof] = fit( xData, yData, ft, opts );

% 绘制数据拟合图。
stc = 0;
if flag_plot
    stc = MyPlot(xData, [yData'; fitresult(xData)']);
end


