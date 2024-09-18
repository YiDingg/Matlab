function MyExport_pdf_docked
    fig_export = gcf; 
    fig_export.WindowStyle = "docked";
    %fig_export.WindowStyle = "modal";
    warning('off', 'MATLAB:Figure:SetPosition');   % mute 在 WindowStyle 为 dock 时设置 position 时的 warning
    export_fig( gcf , '-p0.00','-pdf', ['D:/aa_MyGraphics/', datestr(now, 'yyyy-mm-dd_HH-MM-SS')]);
    fig_export.WindowStyle = "normal";
    warning('on', 'MATLAB:Figure:SetPosition');
end