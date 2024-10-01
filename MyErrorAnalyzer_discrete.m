function stc_error = MyErrorAnalyzer_discrete(Y, Y_hat, num_var)
    stc_error.size_Y = size(Y);
    length_Y = length(Y); stc_error.length_Y = length_Y;

    % 数据准备
    stc_error.Y_bar = mean(Y); Y_bar = mean(Y); 
    stc_error.Y_hat_bar = mean(Y_hat);


    % 残差分布
    ResidualError = Y - Y_hat; stc_error.ResidualError = Y - Y_hat;
    stc_error.ResidualScatter = scatter(1:length(Y), ResidualError, 30, 'blue.');
    
    % 相对平均值误差 RME
    stc_error.RME = abs( (Y_bar - stc_error.Y_hat_bar)/Y_bar );
    % 决定系数 R^2
    stc_error.R2 = 1 - sum( (Y - Y_hat).^2 ) ./ sum( (Y - Y_bar).^2 );
    % 调整决定系数 R^2_{adjust}
    stc_error.R2_adj = 1 - (1 - stc_error.R2)*( length_Y - 1 )/(length_Y - num_var - 1); 
    % 平均标准绝对残差 RS_standard (SRS)
    stc_error.RS_standard = 1 /(length_Y * abs(Y_bar)) * sum( abs(ResidualError) );
    % 平均标准平方残差 RSS_standard (SRSS)
    stc_error.RSS_standard =  1 /(length_Y * Y_bar^2) * sum( ResidualError.^2 );

    disp(['Data size: ', num2str(stc_error.size_Y(1)), ' * ',  num2str(stc_error.size_Y(2))])
    disp(['Y_bar     = ', num2str(stc_error.Y_bar, '%.8f')])
    disp(['Y_hat_bar = ', num2str(stc_error.Y_hat_bar, '%.8f')])
    disp(['RME = ', num2str(stc_error.RME, '%.10f')]);
    disp(['R2 = ', num2str(stc_error.R2, '%.10f')]);
    disp(['R2_adj = ', num2str(stc_error.R2_adj, '%.10f')]);
    disp(['RS_standard = ', num2str(stc_error.RS_standard, '%.10f')]);
    disp(['RSS_standard = ', num2str(stc_error.RSS_standard, '%.10f')]);
end