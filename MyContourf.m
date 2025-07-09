function stc = MyContourf(X, Y, Z)
    stc.fig = figure('Name', 'MyContourf', 'Color', [1 1 1]);
    stc.axes = axes('Parent',stc.fig, 'FontSize', 18);
    stc.fig.Colormap = redblue;
    [~, stc.contourf] = contourf(X, Y, Z, 30);

    stc.axes.FontSize = 14;
    stc.axes.FontName = "Times New Roman";
    stc.axes.PlotBoxAspectRatio = [1.1, 1, 0.65];
    stc.axes.SortMethod = "childorder";   % to avoid warning when exporting to pdf
    stc.label.x = xlabel(stc.axes, '$x$', 'Interpreter', 'latex', 'FontSize', 15);
    stc.label.y = ylabel(stc.axes, '$y$', 'Interpreter', 'latex', 'FontSize', 15);
    stc.contourf.LineStyle = 'none';
    %stc.axes.Title.String = 'Figure: MyContourf';
    stc.axes.Title.FontSize = 19;
    stc.axes.Title.FontWeight = 'bold';
    stc.axes.Title.Interpreter = 'latex';
    stc.colb = colorbar(stc.axes, "eastoutside"); 
end