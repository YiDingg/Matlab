function MyExport_pdf(fig, name)
% 本函数调用了 altmany-export_fig 文件夹内的 export_fig 函数，而 export_fig 调用了
% altmany-export_fig 文件夹内的多个函数，因此使用本函数时，需要将 altmany-export_fig 文件夹添加到 path 中
    export_name = ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')];
    if nargin == 1   % 输入了特定的 fig
        figure(fig);
    elseif nargin == 2   % 输入了特定的 fig, 以及导出的文件名
        figure(fig);
        %export_name = export_name + '__' + name;
        export_name = ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS'), '__', name, ];
    end
    fig_export = gcf; 
    fig_export.WindowStyle = "normal";
    export_fig( gcf , '-p0.00','-pdf', export_name);
end