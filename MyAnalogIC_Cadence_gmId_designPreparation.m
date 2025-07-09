function stc = MyAnalogIC_Cadence_gmId_designPreparation(deviceName, flag_plot, eta_definition_num)
    if nargin <= 1  
        flag_plot = 1;  % 未指定是否作图, 默认要作
    end
    if nargin <= 2
        eta_definition_num = 1; % 未指定 eta_definitio_num, 默认取 1
        warning("[Warning] eta functions undefined, using default performanceDefinition_1.")
    end
    % 获取晶体管原始数据
    stc = MyAnalogIC_Cadence_gmId_readData_morePara(deviceName, 0); 
    %stc.definedParameters = fieldnames(stc);
    stc.fieldNames = fieldnames(stc); % 更新字段
    %stc.data_polarity = data_polarity;
    stc.num_definedParameters = length(stc.definedParameters);
    
    % 赋予 eta 定义
    switch eta_definition_num
        case 1; stc = MyAnalogIC_Cadence_gmId_etaDefinition_1(stc); % 常规 eta
        % case 2; stc = MyAnalogIC_Cadence_gmId_performanceDefinition_2(stc);   
    end
    
    % 计算横纵坐标范围
    i = 1;
    X = stc.(stc.definedParameters{i}).data_left(:, 1);    % 只取第一列
    Y = stc.(stc.definedParameters{i}).secondVarible;
    [grid_X, grid_Y] = meshgrid(X, Y);
    stc.grid_X = grid_X;
    stc.grid_Y = grid_Y;
    stc.range_X = [min(X), max(X)];
    stc.range_Y = [min(Y), max(Y)];
    % 给出 parameters 的范围

    %disp(stc.parametersRange)

    % 作出各参数的单独图像
    stc.parameterRanges = [];
    for i = 1:length(stc.definedParameters)
        Z = stc.(stc.definedParameters{i}).data_right;
        grid_Z = Z';
        stc.(stc.definedParameters{i}).zData = grid_Z;
        stc.parameterRanges = [stc.parameterRanges; stc.definedParameters{i}, num2cell([min(Z, [], 'all'), max(Z, [], 'all')])];
        if strcmp(stc.definedParameters{i}, 'rout')
            % rout 在 high gm/Id 处过于高, 不利于展示结果, 改为作 log 图
            stc.(stc.definedParameters{i}).zData_log10  = log10(grid_Z);
            stc.(stc.definedParameters{i}).mysurf = MySurf(grid_X, grid_Y, log10(grid_Z), 0);
            %stc.(stc.definedParameters{i}).mysurf = MyMesh(grid_X, grid_Y, log10(grid_Z), 0);
        else
            stc.(stc.definedParameters{i}).mysurf = MySurf(grid_X, grid_Y, grid_Z, 0);
            %stc.(stc.definedParameters{i}).mysurf = MyMesh(grid_X, grid_Y, grid_Z, 0);
        end
        
        if flag_plot
            stc.(stc.definedParameters{i}).mysurf.fig.Visible = 'on';
        else
            stc.(stc.definedParameters{i}).mysurf.fig.Visible = 'off';
            %disp([num2str(i), ' = off'])
        end
        %{
            if strcmp(stc.definedParameters{i}, 'currentDensity') ...
            || strcmp(stc.definedParameters{i}, 'transientFreq')
                        stc.(stc.definedParameters{i}).mysurf.axes.ZScale = 'log';
        end
        %}
    end


    if 1
        % 作出总 contourf 图
        stc_array = [];
        str_array = [];
        for i = 1:length(stc.definedParameters)
            stc_array = [stc_array, stc.(stc.definedParameters{i}).mysurf.graph_left];
            str_array = [str_array; "stc." + (stc.definedParameters{i}) + '.mysurf'];
        end
        switch stc.num_definedParameters
            case 1
                layout_matrix = [1 1];
            case 2
                layout_matrix = [1 2];
            case 3
                layout_matrix = [1 3];
            case {4, 5, 6}
                layout_matrix = [2 3];
            case {7, 8, 9}
                layout_matrix = [3 3];
        end
        stc.figcat = MyFigure_figcat(stc_array, str_array, 0, layout_matrix);
        MyFigure_ChangeSize(1.5*[256*3 + 256/4*3, 256*2], stc.figcat.fig)
    end
    
    for i = 1:length(stc.definedParameters)
        stc.figcat.(['ax', num2str(i)]).Title.String = stc.definedParameters{i};
    end
    % stc.sgtitle = sgtitle(stc.figcat, char(deviceName), 'FontSize', 17, 'FontWeight', 'bold', 'FontName', 'Times New Roman');    % 总标题

    % 输出各参数范围
    disp(['range of X (gm/Id) = ', num2str(stc.range_X(1)), ' to ', num2str(stc.range_X(2))])
    disp(['range of Y (L)     = ', num2str(stc.range_Y(1)), ' to ', num2str(stc.range_Y(2))])
    disp('Defined performance parameters and the ranges = ')
    disp(stc.parameterRanges)
    
end
