function stc = MyFigure_figcat(stc_array, str_array, flag_originalVisible, layout_matrix)
%{
输入 surf 图时会自动变为二维图

生成 str_array 的示例代码:
    str_array = [];
    for i = 1:5
        str_array = [str_array; 'stc', num2str(i)];
    end
%}
    if nargin <= 2  % 未输入 flag_originalVisible, 默认为 1
        flag_originalVisible = 1;
    end
    if nargin <= 3  % 未输入 layout_matrix
        layout_matrix = [1, 1];
        layout_matrix(1) = length(stc_array);
    end
    stc.fig = figure;
    stc.fig.Colormap = redblue;
    stc.tiledlayout = tiledlayout(stc.fig, layout_matrix(1), layout_matrix(2)); 
    stc.tiledlayout.Padding = 'compact';   % 减少子图间距
    stc.tiledlayout.TileSpacing = 'compact';
    for i = 1:length(stc_array)
        % stc_array(i).Visible = 'off';
        eval(str_array(i, :) + " = stc_array(" + num2str(i) + ');'); % 赋值
        nexttile(i)
        %stc.(['ax', num2str(i)]) = nexttile(i); 
        %tv = [str_array(i, :), '.Parent = gca;'];
        if flag_originalVisible
            stc_array(i).Parent.Parent.Visible = 'on';
        else
            stc_array(i).Parent.Parent.Visible = 'off';
        end
        eval(['ax', num2str(i), ' = gca;']);    % ax1 = gca;
        eval(['copyobj(stc_array(', num2str(i), '), ax', num2str(i),');']);     % copyobj(stc1, ax);
        % eval(['ax.Children = ', 'stc', num2str(i)]);   % 报错: 子级只能设置为自身的排列
        % eval(['stc', num2str(i), '.Parent = gca;']);   % 此句可用, 但是会丢失原图像
        title(['subwindow ', num2str(i)]);
        colorbar; 
        eval(['stc.ax', num2str(i), ' = ax', num2str(i),';']);      % stc.ax1 = ax1;
        eval(["stc.ax" + num2str(i) + ".Title.Interpreter = 'latex';"]); % stc.ax1.Title.Interpreter = 'latex';
        
        if 0    % 调整横纵坐标范围
            eval(["stc.ax" + num2str(i) + ".XLimitMethod = 'tight';"]); % stc.ax1.XLimitMethod = 'tight'
            eval(["stc.ax" + num2str(i) + ".YLimitMethod = 'tight';"]); % stc.ax1.YLimitMethod = 'tight'
        end
    end
    % 返回结果
    stc.stc_array = stc_array;
end