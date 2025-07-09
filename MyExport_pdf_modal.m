function fig_re = MyExport_pdf_modal(fig, name)
% 当 MyExport_pdf 导出失色时，可以使用本函数以导出原色图片；使用 MyExport_pdf 导出 MyYYPlot 图像时若报错
% "无法处理含有多个坐标轴的对象"，也可使用本函数进行导出。
% 本函数调用了 altmany-export_fig 文件夹内的 export_fig 函数，而 export_fig 调用了
% altmany-export_fig 文件夹内的多个函数，因此使用本函数时，需要将 altmany-export_fig 文件夹添加到 path 中
% 2025.03.16 bug 记录：fig 导出后会变成 "已删除的 Figure 句柄", 经过排查, 是
% fig_export.WindowStyle = "modal" 一句导致的 (导出后我们手动关闭了图窗, 应该是这时被删除了)
% 尝试过给一个返回值, 但不起作用
% 尝试过 return, 无效果
    export_name = ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')];
    if nargin == 0
        fig = gcf;
    elseif nargin == 1   % 输入了特定的 fig
        figure(fig);
    elseif nargin == 2   % 输入了特定的 fig, 以及导出的文件名
        figure(fig);
        %export_name = export_name + '__' + name;
        export_name = ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), '__', name, ];
    end
    fig_re = fig;
    fig_export = gcf; 
    fig_export.WindowStyle = 'modal';
    export_fig( fig_export , '-p0.00','-pdf', export_name);
end