function MyExport_pdf_modal
% 当 MyExport_pdf 导出失色时，可以使用本函数以导出原色图片；使用 MyExport_pdf 导出 MyYYPlot 图像时若报错
% "无法处理含有多个坐标轴的对象"，也可使用本函数进行导出。
% 本函数调用了 altmany-export_fig 文件夹内的 export_fig 函数，而 export_fig 调用了
% altmany-export_fig 文件夹内的多个函数，因此使用本函数时，需要将 altmany-export_fig 文件夹添加到 path 中
    fig_export = gcf; 
    fig_export.WindowStyle = "modal";
    export_fig( gcf , '-p0.00','-pdf', ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
end