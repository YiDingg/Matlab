function [para, stc, fitresult, gof] = MyFit_linear(X, Y, drawfig)
    % 数据处理与拟合
        [xData, yData] = prepareCurveData( X, Y );
        % 设置 fittype 和选项。
        ft = fittype( 'poly1' );
        % 对数据进行模型拟合。
        [fitresult, gof] = fit( xData, yData, ft );
        % y = k*x + b = p1*x + p2
    para.k = fitresult.p1;
    para.b = fitresult.p2;
    stc = 0;
    if drawfig
        stc = MyPlot_FitAndRaw(fitresult, X, Y);
        stc.leg.String = ["Raw data"; 'Fitted $y$ = ', num2str(para.k, '%.2e'), ' $x$ + ', num2str(para.b, '%.2e')];
        %stc.label.x.String = '$I_M$ (mA)';
        %stc.label.y.String = '$B$ (mT)';
        stc.ax.Title.String = [
            %'$y = $', num2str(para.k, '%.2e'), '$x + $',  num2str(para.b, '%.2e'), ...
            '$R^2$ = ', num2str(gof.rsquare, '%.4f'), ', SSE = ', num2str(gof.sse, '%.2e'), ', RMSE = ',  num2str(gof.rmse, '%.2e'),
            ];
        disp('y = kx + b')
        disp(['k = ', num2str(para.k, '%.4e')])
        disp(['b = ', num2str(para.b, '%.4e')])
        disp(['R^2  = ', num2str(gof.rsquare, '%.7f')])
        disp(['SSE  = ', num2str(gof.sse, '%.5e')])
        disp(['RMSE = ', num2str(gof.rmse, '%.5e')])
    end
end