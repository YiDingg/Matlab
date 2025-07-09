function stc_MyMesh = MyMesh(X, Y, Z, flag_drawContourf)
%% 给定数据，作出 3-D mesh 图像
% 输入：
    % X：横坐标，应为 m*n 矩阵
    % Y：纵坐标，应为 m*n 矩阵
    % Z：竖坐标，应为 m*n 矩阵
    % UseRedBlue：是否使用 RedBlue 颜色数组
% 输出：图像
%%

% 是否作等高线图
if nargin <= 3
    flag_drawContourf = 1;  % 未指定是否 drawContourf, 默认要画
end

    % 创建图窗
        stc_MyMesh.fig = figure('Name', 'MyMesh', 'Color', [1 1 1]);
        if flag_drawContourf
            tiledlayout(1, 2, "Padding", "tight")
        end
        %if UseRedBlue
        stc_MyMesh.fig.Colormap = redblue;
        %end
        %if ~UseRedBlue
            %stc_MyMesh.fig.Colormap = hot;
        %end

    % 作左图并设置样式
        stc_MyMesh.axes_left = nexttile;
        stc_MyMesh.graph_left = mesh(X, Y, Z);
        
        stc_MyMesh.axes_left.FontSize = 14;
        stc_MyMesh.axes_left.Box = 'on';
        stc_MyMesh.axes_left.View = [-35, 25];
        stc_MyMesh.axes_left.PlotBoxAspectRatio = [1.1, 1, 0.65];
        stc_MyMesh.axes_left.FontName = "Times New Roman";
        stc_MyMesh.axes_left.XLimitMethod = 'tight';
        stc_MyMesh.axes_left.YLimitMethod = 'tight';
        stc_MyMesh.axes_left.ZLimitMethod = 'tight';
        %stc_MyMesh.axes_left.SortMethod = "childorder";   % to avoid warning when exporting to pdf
        stc_MyMesh.colb = colorbar(stc_MyMesh.axes_left, "eastoutside"); 
        stc_MyMesh.label_left.x = xlabel(stc_MyMesh.axes_left, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyMesh.label_left.y = ylabel(stc_MyMesh.axes_left, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyMesh.label_left.z = zlabel(stc_MyMesh.axes_left, '$z$', 'Interpreter', 'latex', 'FontSize', 15);

if flag_drawContourf
    % 作右图并设置样式
        stc_MyMesh.axes_right = nexttile; 
        [~, stc_MyMesh.graph_right] = contourf(X,Y,Z, 30);

        stc_MyMesh.axes_right.FontSize = 14;
        stc_MyMesh.axes_right.FontName = "Times New Roman";
        stc_MyMesh.axes_right.PlotBoxAspectRatio = [1.1 1 0.65];
        stc_MyMesh.axes_right.SortMethod = "childorder";   % to avoid warning when exporting to pdf
        stc_MyMesh.label_right.x = xlabel(stc_MyMesh.axes_right, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyMesh.label_right.y = ylabel(stc_MyMesh.axes_right, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
        stc_MyMesh.graph_right.LineStyle = 'none';
        %stc_MyMesh.graph_right.LineColor = 'flat';  % 类似与 interp, 但会使图像文件增大

    % 总标题
        stc_MyMesh.title = sgtitle(stc_MyMesh.fig, '', 'FontSize', 17, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
end

end