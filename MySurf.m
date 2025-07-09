function stc_MySurf = MySurf(X, Y, Z, flag_drawContourf)
%% 给定数据，作出 3-D surf 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
    % RetainLineEdge：是否保留 surf 时的 EdgeColor，true 或 false
% 输出：图像
% 注：RetainLineEdge 为 true 时，导出的 pdf 图像大小可能剧增，此时建议使用 MyMesh 而不是 MySurf
%%

% 是否作等高线图
if nargin <= 3
    flag_drawContourf = 1;  % 未指定是否 drawContourf, 默认要画
end

    % 创建图窗
        stc_MySurf.fig = figure('Name', 'MyMesh', 'Color', [1 1 1]);
        if flag_drawContourf
            tiledlayout(1, 2, "Padding", "tight")
        end
        stc_MySurf.fig.Colormap = redblue;
        %stc_MySurf.fig.Colormap = cool;
        %stc_MySurf.fig.Colormap = hot;
        %stc_MySurf.fig.Colormap = turbo;
        %stc_MySurf.fig.Colormap = bone;
        % 官方提供的有: parula, turbo, jet, hsv, hot, cool, spring, summer,
        % autumn, winter, gray, bone, copper, pink, lines, colorcube,
        % prism, flag, white, default

    % 作左图并设置样式
        stc_MySurf.axes_left = nexttile;
        stc_MySurf.graph_left = surf(X, Y, Z);
    
        stc_MySurf.axes_left.FontSize = 14;
        stc_MySurf.axes_left.Box = 'on';
        stc_MySurf.axes_left.View = [-35, 25];
        stc_MySurf.axes_left.PlotBoxAspectRatio = [1.1, 1, 0.65];
        stc_MySurf.axes_left.FontName = "Times New Roman";
        stc_MySurf.axes_left.XLimitMethod = 'tight';
        stc_MySurf.axes_left.YLimitMethod = 'tight';
        stc_MySurf.axes_left.ZLimitMethod = 'tight';
        stc_MySurf.colb = colorbar(stc_MySurf.axes_left, "eastoutside"); 
        stc_MySurf.label_left.x = xlabel(stc_MySurf.axes_left, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_left.y = ylabel(stc_MySurf.axes_left, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_left.z = zlabel(stc_MySurf.axes_left, '$z$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.graph_left.FaceColor = "interp";
        stc_MySurf.graph_left.EdgeColor = "none";
        stc_MySurf.light1 = light;            % create a light
        stc_MySurf.light2 = light;            % create a light
        %stc_MySurf.light3 = light;            % create a light
        lightangle(stc_MySurf.light1, 0, -45);  % 设置 light 角度
        lightangle(stc_MySurf.light2, 0, 45);   % 设置 light 角度
        %lightangle(stc_MySurf.light3, 45, 45);   % 设置 light 角度
        lighting gouraud                      % preferred method for lighting curved surfaces
        material dull                         % set material to be dull, no specular highlights

if flag_drawContourf
    % 作右图并设置样式
        stc_MySurf.axes_right = nexttile; 
        [~, stc_MySurf.graph_right] = contourf(X, Y, Z, 10);

        stc_MySurf.axes_right.FontSize = 14;
        stc_MySurf.axes_right.FontName = "Times New Roman";
        stc_MySurf.axes_right.PlotBoxAspectRatio = [1.1, 1, 0.65];
        stc_MySurf.axes_right.SortMethod = "childorder";   % to avoid warning when exporting to pdf
        stc_MySurf.label_right.x = xlabel(stc_MySurf.axes_right, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_right.y = ylabel(stc_MySurf.axes_right, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.graph_right.LineStyle = 'none';

    % 总标题
        stc_MySurf.title = sgtitle(stc_MySurf.fig, '', 'FontSize', 17, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
end

end