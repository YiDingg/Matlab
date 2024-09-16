function MyExport_svg
    fig_export = gcf; 
    fig_export.WindowStyle = "normal";
    export_fig( gcf , '-p0.00','-svg', ['C:/Users/13081/Desktop/Test_Matlab/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
end