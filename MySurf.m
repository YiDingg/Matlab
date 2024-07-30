function MySurf(X, Y, Z)
% 给定数据，作出 3-D mesh 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
% 输出：图像

    figure('Name','MyMesh','Color',[1 1 1]);
    tiledlayout(1,2)

    % 作图 1 并设置样式
    p1 = nexttile;
    sf = surf(X,Y,Z);

    sf.FaceColor = "interp";
    sf.EdgeColor = "none";
    p1.View = [-35 30];
    p1.PlotBoxAspectRatio = [1.1 1 0.65];
    p1.Colormap = bone;
    colorbar(p1,"eastoutside"); 
    

    title(p1,'(a)','Interpreter','latex')
    xlabel(p1,'$x$ axis','Interpreter','latex')
    ylabel(p1,'$y$ axis','Interpreter','latex')
    zlabel(p1,'$z$ axis','Interpreter','latex')

    % 作图 2 并设置样式
    p2 = nexttile; 
    contourf(X,Y,Z,12);

    p2.PlotBoxAspectRatio = [1.1 1 0.65];
    p2.Colormap = bone;

    title(p2,'(b)','Interpreter','latex'); 
    xlabel(p2,'$x$ axis','Interpreter','latex')
    ylabel(p2,'$y$ axis','Interpreter','latex')
    zlabel(p2,'$z$ axis','Interpreter','latex')
end