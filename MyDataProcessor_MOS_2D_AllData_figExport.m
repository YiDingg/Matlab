function MyDataProcessor_MOS_2D_AllData_figExport(stc_fig)
    names = fieldnames(stc_fig);
    n = length(names);
    for i = 1:n
        if ~isnumeric(stc_fig.(names{i}))    % 不是 fig 而是默认的 0
            if isequal(names{i}, 'stc_gm_IdVgs_yyplot') % YYplot, 不能用普通格式导出
                MyExport_pdf_modal(stc_fig.(names{i}).fig, names{i})
            elseif isfield(stc_fig.(names{i}), 'fig')
                MyExport_pdf(stc_fig.(names{i}).fig, names{i})
            else
                MyExport_pdf(stc_fig.(names{i}).num1.fig, names{i})
            end
        end
    end
end