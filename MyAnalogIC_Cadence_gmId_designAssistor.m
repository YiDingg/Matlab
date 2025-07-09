function stc = MyAnalogIC_Cadence_gmId_designAssistor(stc)
%{
1. 需要先运行函数 MyAnalogIC_Cadence_gmId_designPreparation()
2. stc.obej_array 中的值为 0 或 nan 都表示此参数不设置 objective, 此时 coefficient 为 0, 不贡献得分
3. (2025.05.29) eta 的映射关系, 除 gm*rO 定义为 p = log3(eta + 1), 剩余的参数都定义为 p = ln(eta + 1)
3. (2025.05.30) 修改了 transientFreq 的 eta 映射关系
3. (2025.05.30) 修改了 currentDensity 的 eta 映射关系
4. performance = exp( a1*p1 + a2*p2 + ... )
%}

%%
disp('-------------------------------------------------------------------')
disp('------------------------- Design Assistor -------------------------')

% 检查参数
    if ~isfield(stc, 'weight_array')
        warning("[Warning] weight coefficients undefined, using default weight_array.")
        stc.weight_array = zeros(size(stc.obej_array)) + 1; % 默认系数全为 1
    end
    if ~isfield(stc, 'obej_array')
        error("[Error] objective values undefined, define stc.obej_array first!")
    end

% 将 stc.obej_array 标准化, 输入为 0 或 nan 的转化为默认值
    stc.obej_bool = logical(zeros(size(stc.obej_array)) + 1);
    for i = 1:length(stc.obej_array)
        if (stc.obej_array(i) == 0 || isnan(stc.obej_array(i)))
            % co = MyAnalogIC_Cadence_gmId_parameterDefinitions(stc.definedParameters{i});
            co = stc.definedParameters_polarity(i);
            stc.obej_bool(i) = 0;
            stc.obej_array(i) = 0;
            stc.weight_array(i) = 0;
            if co == -1
                stc.obej_array(i) = inf;
            end
        end
    end
    
% 提取 bool 矩阵
    stc.zBoolMatrix = logical(zeros(size(stc.grid_X)) + 1);
    for i = 1:length(stc.obej_array)    % 注意 length 是 obj 的而不是 definedPara 的
        co = stc.definedParameters_polarity(i);
        stc.(stc.definedParameters{i}).zBool = co*stc.(stc.definedParameters{i}).zData >= co*stc.obej_array(i);
        stc.zBoolMatrix = stc.zBoolMatrix & stc.(stc.definedParameters{i}).zBool;
    end
    stc.zBoolMatrix_nonZero_index = find(stc.zBoolMatrix);
    tv = size(stc.grid_X);
    stc.num_totalPoints = tv(1)*tv(2);
    stc.num_satisfyingObjectives = length(stc.zBoolMatrix_nonZero_index);
    %disp(['Points satisfying objectives = ', num2str(stc.num_satisfyingObjectives), '/',num2str(stc.num_totalPoints), ' = ', num2str(stc.num_satisfyingObjectives/stc.num_totalPoints*100, '%.4f'), ' %'])
    %disp(stc.zBoolMatrix_nonZero_index)
    
% 由 eta 计算 p
performance = zeros(size(stc.grid_X)) + 1;    % e^0
for i = 1:length(stc.obej_array) % 注意 length 是 obj 的而不是 definedPara 的
    eta_func = stc.(stc.definedParameters{i}).eta_func;
    eta = eta_func(stc.(stc.definedParameters{i}).zData, stc.obej_array(i));
    if stc.obej_bool(i) == 0
        eta = zeros(size(stc.grid_X)); 
    end
    if strcmp(stc.definedParameters{i}, 'selfGain')
        p = log(eta + 1)/log(3);
    elseif strcmp(stc.definedParameters{i}, 'transientFreq')
        p = log(eta + 1)/log(10);
    elseif strcmp(stc.definedParameters{i}, 'currentDensity')
        p = log(eta + 1)/log(10);
    else
        p = log(eta + 1);
    end
    performance = performance .* exp( stc.weight_array(i).*p );
    stc.(stc.definedParameters{i}).eta = eta;
    stc.(stc.definedParameters{i}).p = p;
    %stc.(stc.definedParameters{i}).p
    stc.performance = performance;
end

% 作出总得分图像

    fig_size = [512*3, 512*1.5];
if 0
    stc.fig_performance = MySurf(stc.grid_X, stc.grid_Y*10^6, performance, 1);
    stc.fig_performance.label_left.x.String = 'Current Efficiency $\frac{g_m}{I_D}$ (S/A) ';
    stc.fig_performance.label_left.y.String = 'Channel Length $L$ (um)';
    stc.fig_performance.label_left.z.String = 'Performance Scores';
    stc.fig_performance.label_right.x.String = 'Current Efficiency $\frac{g_m}{I_D}$ (S/A) ';
    stc.fig_performance.label_right.y.String = 'Channel Length $L$ (um)';
    MyFigure_ChangeSize(fig_size, stc.fig_performance.fig)
end

% 作出满足所有限制条件的总得分图
    performance_satisfyingBool = performance.*stc.zBoolMatrix;
    performance_satisfyingBool(performance_satisfyingBool == 0) = nan;
    stc.performance_satisfyingBool = performance_satisfyingBool;
    stc.fig_performance_bool = MySurf(stc.grid_X, stc.grid_Y*10^6, performance.*stc.zBoolMatrix, 1);
    stc.fig_performance_bool.label_left.x.String = 'Current Efficiency $\frac{g_m}{I_D}$ (S/A) ';
    stc.fig_performance_bool.label_left.y.String = 'Channel Length $L$ (um)';
    stc.fig_performance_bool.label_left.z.String = 'Performance Scores';
    stc.fig_performance_bool.label_right.x.String = 'Current Efficiency $\frac{g_m}{I_D}$ (S/A) ';
    stc.fig_performance_bool.label_right.y.String = 'Channel Length $L$ (um)';
    MyFigure_ChangeSize(fig_size, stc.fig_performance_bool.fig)
    % scatter 作出最大值
        [value, index] = max(stc.performance_satisfyingBool, [], 'all');
        stc.maxPerformance_value = value;
        stc.maxPerformance_index = index;
        hold(stc.fig_performance_bool.axes_left, 'on');
        scatter3(stc.fig_performance_bool.axes_left, stc.grid_X(index), stc.grid_Y(index)*10^6, stc.performance_satisfyingBool(index), 'green', 'filled', SizeData=100);
        hold(stc.fig_performance_bool.axes_left, 'off');
        hold(stc.fig_performance_bool.axes_right, 'on');
        scatter3(stc.fig_performance_bool.axes_right, stc.grid_X(index), stc.grid_Y(index)*10^6, stc.performance_satisfyingBool(index), 'green', 'filled', SizeData=100);
        hold(stc.fig_performance_bool.axes_right, 'off');

% 获取 best point 相关信息
    stc.bestPoint.index = index;
    stc.bestPoint.parameters = stc.definedParameters;
    for i = 1:length(stc.definedParameters)
        %stc.bestPoint.parameters{i, 2} = stc.selfGain.zData(index);
        stc.bestPoint.parameters(i, 2) = stc.(stc.definedParameters{i}).zData(index);
    end
    stc.bestPoint.parameters = ["index", num2str(index); "gm/Id", num2str(stc.grid_X(index)); "L", num2str(stc.grid_Y(index)); stc.bestPoint.parameters];


% 输出最终结果：
    disp(['Points satisfying objectives = ', num2str(stc.num_satisfyingObjectives), '/',num2str(stc.num_totalPoints), ' = ', num2str(stc.num_satisfyingObjectives/stc.num_totalPoints*100, '%.4f'), ' %'])
    disp(['Best point: ', 'gm/Id  = ', num2str(stc.grid_X(index)), ', length = ', num2str(stc.grid_Y(index)*10^6), ' um'])
    disp('Parameters of the best point = ')
    disp(stc.bestPoint.parameters)
    if 0
        disp('Their indexes are:')
        disp(stc.zBoolMatrix_nonZero_index)
    end
    
end