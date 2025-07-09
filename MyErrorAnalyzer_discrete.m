function stc_error = MyErrorAnalyzer_discrete(Y, Y_hat, num_Var)
%%
% 输入：
%   Y, Y_hat: n*1, 1*n 或 n*m 矩阵
%   num_Var: 自变量个数, 用于计算调整 R2
% 输出：拟合优度结构体
% Refer to https://yidingg.github.io/YiDingg/#/Notes/Else/GoodnessOfFit for
% more details.
%%

    % 检查传入参数
    if isvector(Y) && size(Y, 1) ~= 1
        Y = Y';     % 转为行向量
    end
    if isvector(Y_hat) && size(Y_hat, 1) ~= 1
        Y_hat = Y_hat';     % 转为行向量
    end
    
    % 数据准备
    stc_error.Y = Y;
    stc_error.Y_hat = Y_hat;
    stc_error.num_var = num_Var; 
    stc_error.DataSize = size(Y);       DataSize = size(Y);
    stc_error.DataLength = numel(Y);   DataLength = numel(Y);
    stc_error.Y_bar = mean(Y, 'all');          Y_bar = mean(Y, 'all'); 
    stc_error.Y_hat_bar = mean(Y_hat, 'all');  Y_hat_bar = mean(Y_hat, 'all');
    stc_error.Residual = Y - Y_hat;     Residual = Y - Y_hat;
    
    % 基本参数
    stc_error.SSR = sum( (Y_hat - Y_bar).^2, 'all');
    stc_error.SSE = sum( (Y - Y_hat).^2, 'all');
    stc_error.SST = sum( (Y - Y_bar).^2, 'all');

    % 作出残差分布图
    %stc_error.fig = figure('Name', 'MyErrorAnalyzer_discrete', 'Color', [1 1 1]);
    %stc_error.axes = axes('FontSize', 14);   
    if isvector(Y)
        stc_error.ResidualScatter = MyScatter(1:DataLength, Residual);
        stc_error.ResidualScatter.scatter.scatter_1.MarkerEdgeColor = 'r';
        stc_error.ResidualScatter.scatter.scatter_1.CData = 30;
    else
        % 将矩阵转为行向量
        stc_error.XData = zeros(1, stc_error.DataLength);
        stc_error.YData = zeros(1, stc_error.DataLength);
        stc_error.ZData = zeros(1, stc_error.DataLength);
        d = DataSize(2);
        for i = 0:DataSize(1)-1
            stc_error.XData(1 + i*d : (i+1)*d) = 1:d;
            stc_error.YData(1 + i*d : (i+1)*d) = i;
            stc_error.ZData(1 + i*d : (i+1)*d) = Residual(i+1, :);
        end
        % 作出三维图
        stc_error.axes_3 = subplot(3, 1, [2 3]);
            %stc_error.ResidualScatter = MyScatter3_GivenAxes(stc_error.axes, stc_error.XData, stc_error.YData, stc_error.ZData);
            stc_error.ResidualScatter_xyz = scatter3(stc_error.XData, stc_error.YData, stc_error.ZData, 25,  abs(stc_error.ZData), '.');
            % 作出参考面
            hold on
            stc_error.surf = surf(zeros(size(stc_error.Residual)), 'FaceColor', [0.3 0.3 0.3], 'FaceAlpha', 0.7, 'LineStyle', 'none', 'FaceLighting', 'gouraud');
            hold off
            % 扩展平面
            stc_error.surf.XData(1:d:end) = stc_error.surf.XData(1:d:end) - 10;
            stc_error.surf.XData(d:d:end) = stc_error.surf.XData(d:d:end) + 10;
            stc_error.surf.YData(1:d) = stc_error.surf.YData(1:d) - 10;
            stc_error.surf.YData(end-d+1:end) = stc_error.surf.YData(end-d+1:end) + 10;
            xlim([1 - stc_error.XData(d)*0.05, stc_error.XData(d)*1.05]);
            ylim([1 - stc_error.YData(end)*0.05, stc_error.YData(end)*1.05]);
        % 作出二维图
        stc_error.axes_2 = subplot(3, 1, 1);
            stc_error.ResidualScatter_yz = scatter(1:DataLength ,stc_error.ZData, 25,  abs(stc_error.ZData), '.'); 
            yline(0, 'LineWidth', 1, 'Color', 'k');
    end

    % 拟合优度指标
    stc_error.MyR2 = stc_error.SSE / stc_error.SST; % 1 - R^2, R^2 即 R Squared, 也称决定系数
    stc_error.MyR2_adj = stc_error.MyR2*( DataLength - 1 )/(DataLength - num_Var - 1);    % 1-R^2_adj, R^2_adj 即 Adjusted R Squared, 也称调整决定系数
    varepsilon = 1e-10; % 防止除数为零
    stc_error.MAPE = mean( abs( (Y - Y_hat)./max(varepsilon, abs(Y)) ), 'all'); % MAPE, Mean Absolute Percentage Error, 平均绝对百分比误差
    stc_error.MyMAPE = mean( abs( (Y - Y_hat)./sqrt(1 + Y.^2)) , 'all');   % MyMAPE, My Mean Absolute Percentage Error, 自定义的平均绝对百分比误差
    stc_error.RMSE = sqrt( stc_error.SSE / DataLength ); % RMSE, Root Mean Square Error, 均方根误差
    stc_error.fitness = stc_error.RMSE / (1 - stc_error.MyR2);   % 同时考虑 R Square 和 RMSE 的指标
    stc_error.fitness_adj = stc_error.RMSE  / (1 - stc_error.MyR2_adj);   % 同时考虑 Adjusted R Square 和 RMSE 的指标
    stc_error.RMSLE = sqrt(mean( (log(1 + Y) - log(1 + Y_hat)).^2 , 'all'));   % RMSLE, Root Mean Squared Logarithmic Error, 均方对数误差

    % 输出结果
    disp('------------------------------------------------------------------')
    disp(['Data size:     ',        num2str(stc_error.DataSize(1)), ' * ',  num2str(stc_error.DataSize(2))])
    disp(['Y_bar        = ',       num2str(stc_error.Y_bar, '%.8f')])
    disp(['Y_hat_bar    = ',       num2str(stc_error.Y_hat_bar, '%.8f')])
    disp('  ')
    disp(['R2         = ',              num2str(1-stc_error.MyR2, '%.10f')]);
    disp(['R2_adj     = ',          num2str(1-stc_error.MyR2_adj, '%.10f')]);
    disp(['MyR2         = ',              num2str(stc_error.MyR2, '%.10f')]);
    disp(['MyR2_adj     = ',          num2str(stc_error.MyR2_adj, '%.10f')]);
    disp(['MAPE         = ',            num2str(stc_error.MAPE, '%.10f')]);
    disp(['MyMAPE       = ',    num2str(stc_error.MyMAPE, '%.10f')]);
    disp(['RMSE         = ',    num2str(stc_error.RMSE, '%.10f')]);
    disp(['fitness      = ',    num2str(stc_error.fitness, '%.10f')]);
    disp(['fitness_adj  = ',    num2str(stc_error.fitness_adj, '%.10f')]);
    disp(['RMSLE        = ',    num2str(stc_error.RMSLE, '%.10f')]);
    disp('------------------------------------------------------------------')

end