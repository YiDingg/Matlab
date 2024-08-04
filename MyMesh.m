function stc_MyMesh = MyMesh(X, Y, Z, UseRedBlue)
% 给定数据，作出 3-D mesh 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
% 输出：图像

    stc_MyMesh.fig = figure('Name','MyMesh','Color',[1 1 1]);
    tiledlayout(1,2,"Padding","tight")

    % 作图 1 并设置样式
    stc_MyMesh.p1 = nexttile;
    stc_MyMesh.p1.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    mesh(X,Y,Z);
    stc_MyMesh.p1.View = [-35 25];
    
    stc_MyMesh.p1.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        stc_MyMesh.p1.Colormap = redblue;
    end
    if ~UseRedBlue
        stc_MyMesh.p1.Colormap = bone;
    end
    colorbar(stc_MyMesh.p1,"eastoutside"); 
    
    %title(mymesh.p1,'(a)','Interpreter','latex')
    xlabel(stc_MyMesh.p1,'$x$ axis','Interpreter','latex')
    ylabel(stc_MyMesh.p1,'$y$ axis','Interpreter','latex')
    zlabel(stc_MyMesh.p1,'$z$ axis','Interpreter','latex')

    % 作图 2 并设置样式
    stc_MyMesh.p2 = nexttile; 
    stc_MyMesh.p2.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    contourf(X,Y,Z,12);

    stc_MyMesh.p2.PlotBoxAspectRatio = [1.1 1 0.65];
    if UseRedBlue
        stc_MyMesh.p2.Colormap = redblue;
    end
    if ~UseRedBlue
        stc_MyMesh.p2.Colormap = bone;
    end

    %title(mymesh.p2,'(b)','Interpreter','latex'); 
    xlabel(stc_MyMesh.p2,'$x$ axis','Interpreter','latex')
    ylabel(stc_MyMesh.p2,'$y$ axis','Interpreter','latex')
    zlabel(stc_MyMesh.p2,'$z$ axis','Interpreter','latex')
end