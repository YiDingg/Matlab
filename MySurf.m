function stc_MySurf = MySurf(X, Y, Z, UseRedBlue)
% 给定数据，作出 3-D surf 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
    % RetainLineEdge：是否保留 surf 时的 EdgeColor，true 或 false
% 输出：图像
% 注：RetainLineEdge 为 true 时，导出的 pdf 图像大小可能剧增，此时建议使用 MyMesh 而不是 MySurf

    % 创建图窗
        stc_MySurf.fig = figure('Name', 'MyMesh', 'Color', [1 1 1]);
        tiledlayout(1, 2, "Padding", "tight")
        if UseRedBlue
            stc_MySurf.fig.Colormap = redblue;
        end
        if ~UseRedBlue
            stc_MySurf.fig.Colormap = bone;
        end

    % 作左图并设置样式
        stc_MySurf.axes_left = nexttile;
        stc_MySurf.graph_left = surf(X, Y, Z);
    
        stc_MySurf.axes_left.FontSize = 14;
        stc_MySurf.axes_left.Box = 'on';
        stc_MySurf.axes_left.View = [-35, 25];
        stc_MySurf.axes_left.PlotBoxAspectRatio = [1.1, 1, 0.65];
        stc_MySurf.axes_left.FontName = "Times New Roman";
        stc_MySurf.colb = colorbar(stc_MySurf.axes_left, "eastoutside"); 
        stc_MySurf.label_left.x = xlabel(stc_MySurf.axes_left, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_left.y = ylabel(stc_MySurf.axes_left, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_left.z = zlabel(stc_MySurf.axes_left, '$z$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.graph_left.FaceColor = "interp";
        stc_MySurf.graph_left.EdgeColor = "none";


    % 作右图并设置样式
        stc_MySurf.axes_right = nexttile; 
        stc_MySurf.graph_right = contourf(X, Y, Z, 15);

        stc_MySurf.axes_right.FontSize = 14;
        stc_MySurf.axes_right.FontName = "Times New Roman";
        stc_MySurf.axes_right.PlotBoxAspectRatio = [1.1, 1, 0.65];
        stc_MySurf.axes_right.SortMethod = "childorder";   % to avoid warning when exporting to pdf
        stc_MySurf.label_right.x = xlabel(stc_MySurf.axes_right, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MySurf.label_right.y = ylabel(stc_MySurf.axes_right, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
    % 收尾
        stc_MySurf.title = sgtitle(stc_MySurf.fig, 'Figure: MySurf', 'FontSize', 17, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
end