function MyExport_pdf
% 本函数调用了 altmany-export_fig 文件夹内的 export_fig 函数，而 export_fig 调用了
% altmany-export_fig 文件夹内的多个函数，因此使用本函数时，需要将 altmany-export_fig 文件夹添加到 path 中
    fig_export = gcf; 
    fig_export.WindowStyle = "normal";
    export_fig( gcf , '-p0.00','-pdf', ['C:/Users/13081/Desktop/Test_Matlab/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
end