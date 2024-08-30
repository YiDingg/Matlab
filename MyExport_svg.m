function MyExport_svg
    fig_export = gcf; 
    export_fig( gcf , '-p0.00','-svg', ['C:/Users/13081/Desktop/Test_Matlab/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
    fig_export.WindowStyle = "normal";
    warning('on', 'MATLAB:Figure:SetPosition');
end