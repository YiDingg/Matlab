function [fitresult, stc, gof] = MyFit_proportional(X, Y, drawfig)
    % 数据处理与拟合
        [xData, yData] = prepareCurveData( X, Y );
        % 设置 fittype 和选项。
        ft = fittype( 'a*x', 'independent', 'x', 'dependent', 'y' );
        % 加一些 options, 避免出现拟合异常 (20250424 遇到)
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        %opts.Algorithm = 'Levenberg-Marquardt';
        opts.Display = 'Off';
        opts.Robust = 'Bisquare';
        opts.StartPoint = 50;
        %opts.Lower = 1;
        %opts.Upper = 1000;
        % 对数据进行模型拟合。
        [fitresult, gof] = fit( xData, yData, ft, opts);

    stc = 0;
    if drawfig
        stc = MyPlot_FitAndRaw(fitresult, X, Y);
        %stc.label.x.String = '$I_M$ (mA)';
        %stc.label.y.String = '$B$ (mT)';
        stc.ax.Title.String = [
            %'$y = $', num2str(fitresult.p1, '%.2e'), '$x + $',  num2str(fitresult.p2, '%.2e'), ...
            "$y = $ " + num2str(fitresult.a, '%.4f') + ' $x$, ' + ...
            '$R^2$ = ' + num2str(gof.rsquare, '%.4f') + ', SSE = ' + num2str(gof.sse, '%.2e') + ', RMSE = ' +  num2str(gof.rmse, '%.2e')
            ];
        disp('y = ax')
        disp(['a = ', num2str(fitresult.a, '%.4e')])
        disp(['R^2  = ', num2str(gof.rsquare, '%.7f')])
        disp(['SSE  = ', num2str(gof.sse, '%.5e')])
        disp(['RMSE = ', num2str(gof.rmse, '%.5e')])
    end
end