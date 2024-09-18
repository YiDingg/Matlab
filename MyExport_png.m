function MyExport_png(quality)
    fig_export = gcf; 
    fig_export.WindowStyle = "modal";   % 避免导出时丢失 colormap 
    export_fig( gcf , '-p0.02','-png' , ['-r', num2str(quality)] , '-painters' , ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
    fig_export.WindowStyle = "normal"; 
end