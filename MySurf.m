function stc_MySurf = MySurf(X, Y, Z, UseRedBlue, RetainLineEdge)
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
        stc_MySurf.fig = figure('Name','MyMesh','Color',[1 1 1]);
        tiledlayout(1,2,"Padding","tight")
        if UseRedBlue
            stc_MySurf.fig.Colormap = redblue;
        end
        if ~UseRedBlue
            stc_MySurf.fig.Colormap = bone;
        end

    % 作左图并设置样式
        stc_MySurf.axes_left = nexttile;
        stc_MySurf.graph_left = surf(X,Y,Z);
    
        stc_MySurf.axes_left.View = [-35 25];
        stc_MySurf.axes_left.PlotBoxAspectRatio = [1.1 1 0.65];
        stc_MySurf.axes_left.FontName = "Times New Roman";
        stc_MySurf.colb = colorbar(stc_MySurf.axes_left,"eastoutside"); 
        stc_MySurf.label.x = xlabel(stc_MySurf.axes_left,'$x$','Interpreter','latex');
        stc_MySurf.label.y = ylabel(stc_MySurf.axes_left,'$y$','Interpreter','latex');
        stc_MySurf.label.z = zlabel(stc_MySurf.axes_left,'$z$','Interpreter','latex');
        stc_MySurf.graph_left.FaceColor = "interp";
        if RetainLineEdge
            stc_MySurf.graph_left.EdgeColor = "interp";
        end
        if ~RetainLineEdge
            stc_MySurf.graph_left.EdgeColor = "none";
        end

    % 作右图并设置样式
        stc_MySurf.axes_right = nexttile; 
        stc_MySurf.graph_right = contourf(X,Y,Z,15);

        stc_MySurf.axes_right.FontName = "Times New Roman";
        stc_MySurf.axes_right.PlotBoxAspectRatio = [1.1 1 0.65];
        stc_MySurf.axes_right.SortMethod = "childorder";   % to avoid warning when exporting to pdf
        xlabel(stc_MySurf.axes_right,'$x$','Interpreter','latex')
        ylabel(stc_MySurf.axes_right,'$y$','Interpreter','latex')
        zlabel(stc_MySurf.axes_right,'$z$','Interpreter','latex')
    % 收尾
        stc_MySurf.title = sgtitle(stc_MySurf.fig, 'Figure: MyMesh');
        stc_MySurf.title.FontName = 'Times New Roman';  % sgtitle 无法设置字体
        stc_MySurf.title.FontSize = 13;
end