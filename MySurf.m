function MySurf(X, Y, Z, RetainLineEdge)
% 给定数据，作出 3-D mesh 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
    % RetainLineEdge：是否保留 surf 时的 EdgeColor，true 或 false
% 输出：图像
% 注：RetainLineEdge 为 true 时，导出的 pdf 图像大小可能剧增，此时建议使用 MyMesh 而不是 MySurf

    figure('Name','MyMesh','Color',[1 1 1]);
    tiledlayout(1,2)

    % 作图 1 并设置样式
    p1 = nexttile;
    p1.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    sf = surf(X,Y,Z);

    sf.FaceColor = "interp";
    if RetainLineEdge
        sf.EdgeColor = "interp";
    end
    if ~RetainLineEdge
        sf.EdgeColor = "none";
    end
    p1.View = [-35 30];
    p1.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        p1.Colormap = redblue;
    end
    if ~UseRedBlue
        p1.Colormap = bone;
    end
    colorbar(p1,"eastoutside"); 
    

    title(p1,'(a)','Interpreter','latex')
    xlabel(p1,'$x$ axis','Interpreter','latex')
    ylabel(p1,'$y$ axis','Interpreter','latex')
    zlabel(p1,'$z$ axis','Interpreter','latex')

    % 作图 2 并设置样式
    p2 = nexttile; 
    p2.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    contourf(X,Y,Z,12);

    p2.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        p2.Colormap = redblue;
    end
    if ~UseRedBlue
        p2.Colormap = bone;
    end

    title(p2,'(b)','Interpreter','latex'); 
    xlabel(p2,'$x$ axis','Interpreter','latex')
    ylabel(p2,'$y$ axis','Interpreter','latex')
    zlabel(p2,'$z$ axis','Interpreter','latex')
end