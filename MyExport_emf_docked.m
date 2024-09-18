function MyExport_svg_docked
    fig_export = gcf; 
    fig_export.WindowStyle = "docked";
    %fig_export.WindowStyle = "modal";
    warning('off', 'export_fig:exportgraphics');   % mute警告: In Matlab R2020a+ you can also use exportgraphics(hFigure,filename) for simple file export
    warning('off', 'MATLAB:Figure:SetPosition');   % mute 在 WindowStyle 为 dock 时设置 position 时的 warning
    export_fig( gcf , '-p0.00','-emf', ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
    fig_export.WindowStyle = "normal";
    warning('on', 'MATLAB:Figure:SetPosition');
end