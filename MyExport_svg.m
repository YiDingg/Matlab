function MyExport_svg
    fig_export = gcf; 
    fig_export.WindowStyle = "normal";
    export_fig( gcf , '-p0.00','-svg', ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
end