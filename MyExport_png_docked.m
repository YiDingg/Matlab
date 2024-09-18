function MyExport_png_docked(quality)
    fig_export = gcf; 
    fig_export.WindowStyle = "docked";
    %fig_export.WindowStyle = "modal";
    warning('off', 'MATLAB:Figure:SetPosition');   % mute 在 WindowStyle 为 dock 时设置 position 时的 warning
    export_fig( gcf , '-p0.02','-png' , ['-r', num2str(quality)] , '-painters' , ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
    fig_export.WindowStyle = "normal"; 
    warning('on', 'MATLAB:Figure:SetPosition');
end