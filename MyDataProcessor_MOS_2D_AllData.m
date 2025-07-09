function stc_fig = MyDataProcessor_MOS_2D_AllData(stc)
%{
函数调用示例 (20250424):
clc, clear, close all
stc.data1_Id_Vds_Vgs = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250423_2129 NMOS 2N7000 (onsemi, KH32), current level high (0~125mA), data num1 (Id, Vds, Vgs).txt");
data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250423_2129 NMOS 2N7000 (onsemi, KH32), current level high (0~125mA), data num2 (Id, Vgs, Vds).txt");
data = (data(1:501, :) + data(502:1002, :) + data(1003:1503, :))/3;
stc.data2_Id_Vgs_Vds = data;

stc.name = '2N7000';
stc.data_window = 10;
stc.rO_fit = 1;
stc.rO_window = 10;
stc.unit_Id = 'mA';
stc.gm_fit = 1;
stc.gm_window = 10;
stc.Ron_max = 20;

stc_fig = MyDataProcessor_MOS_2D_AllData(stc);
%MyDataProcessor_MOS_2D_AllData_figExport(stc_fig)
%}
    % 总参数赋值
        name = stc.name;
        data_window = stc.data_window;
        rO_fit = stc.rO_fit;
        rO_window = stc.rO_window;
        unit_Id = stc.unit_Id;
        gm_fit = stc.gm_fit;
        gm_window = stc.gm_window;
        Ron_max = stc.Ron_max;
        gmId_max = stc.gmId_max;
    if isfield(stc, 'data1_Id_Vds_Vgs')
        [stc_fig.stc_Id_Vds_Vgs, stc_fig.stc_rO_Id_Vgs, stc_fig.stc_Ron_Id_Vgs] = MyDataProcessor_MOS_Data1_IdVdsVgs(stc.data1_Id_Vds_Vgs, data_window, name, rO_fit, rO_window, unit_Id, Ron_max);
    end
    if isfield(stc, 'data2_Id_Vgs_Vds')
        [stc_fig.stc_Id_Vgs_Vds, stc_fig.stc_gm_Id_Vds, stc_fig.stc_gm_Vgs_Vds, stc_fig.stc_gm_IdVgs_yyplot] = MyDataProcessor_MOS_Data2_IdVgsVds_gmVgsVds_gmIdVds(stc.data2_Id_Vgs_Vds, data_window, name, gm_fit, gm_window, unit_Id, gmId_max);
    end
end