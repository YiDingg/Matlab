function mymesh = MyMesh(X, Y, Z, UseRedBlue)
% 给定数据，作出 3-D mesh 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
% 输出：图像

    mymesh.fig = figure('Name','MyMesh','Color',[1 1 1]);
    tiledlayout(1,2)

    % 作图 1 并设置样式
    mymesh.p1 = nexttile;
    mymesh.p1.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    mesh(X,Y,Z);
    mymesh.p1.View = [-35 25];
    
    mymesh.p1.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        mymesh.p1.Colormap = redblue;
    end
    if ~UseRedBlue
        mymesh.p1.Colormap = bone;
    end
    colorbar(mymesh.p1,"eastoutside"); 
    
    %title(mymesh.p1,'(a)','Interpreter','latex')
    xlabel(mymesh.p1,'$x$ axis','Interpreter','latex')
    ylabel(mymesh.p1,'$y$ axis','Interpreter','latex')
    zlabel(mymesh.p1,'$z$ axis','Interpreter','latex')

    % 作图 2 并设置样式
    mymesh.p2 = nexttile; 
    mymesh.p2.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    contourf(X,Y,Z,12);

    mymesh.p2.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        mymesh.p2.Colormap = redblue;
    end
    if ~UseRedBlue
        mymesh.p2.Colormap = bone;
    end

    %title(mymesh.p2,'(b)','Interpreter','latex'); 
    xlabel(mymesh.p2,'$x$ axis','Interpreter','latex')
    ylabel(mymesh.p2,'$y$ axis','Interpreter','latex')
    zlabel(mymesh.p2,'$z$ axis','Interpreter','latex')
end