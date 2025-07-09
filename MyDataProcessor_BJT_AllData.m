function stc = MyDataProcessor_BJT_AllData(stc_data)
%{
函数调用示例 (2025.04.23)
clc, clear, close all
stc_data.name = 'SS8050';
stc_data.R_Ib_low = 1e3;
stc_data.R_Ib_high = 10e3;
stc_data.unit_Ic = 'mA';
stc_data.unit_Ib = 'uA';
stc_data.unit_Vce = 'V';
stc_data.unit_Vbe = 'V';
stc_data.data_window = 10;
stc_data.rO_window = 100;

% 一共有 7 个部分
stc_data.IcVceIb.data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num1 (Ic, Vce, Ib大), R_Ib=1K.txt");

stc_data.IcVceIb_3D.data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num3 (Ic, Vce, Ib 小 3D), R_Ib=10K.txt");

stc_data.IcVceIb_IbVceIb.data_Ic = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num2 (Ic, Vce, Ib小), R_Ib=10K.txt");
stc_data.IcVceIb_IbVceIb.data_Ib = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num4 (Ib, Vce, Ib小), R_Ib=10K.txt");

stc_data.VcesatIcBeta10_VbesatIcBeta10.data_Vcesat = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num5 (Vce_sat, Ic, Ib 大).txt");
stc_data.VcesatIcBeta10_VbesatIcBeta10.data_Vbesat = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num6 (Vbe_sat, Ic, Ib 大).txt");

stc_data.IcVceVbe_IbVceVbe.data_Ic = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num8 (Ic, Vce, Vbe 大).txt");
stc_data.IcVceVbe_IbVceVbe.data_Ib = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num7 (Ib, Vce, Vbe 大).txt");

stc_data.IcVceVbe_3D.data = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num88 (Ic, Vce, Vbe 大 3D).txt");

stc_data.IcVbeVce_IbVbeVce.data_Ic = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num9 (Ic, Vbe, Vce 大).txt");
stc_data.IcVbeVce_IbVbeVce.data_Ib = readmatrix("D:\aa_MyExperimentData\Raw data backup\[Experiment] 20250314_1800 NPN SS8050, num10 (Ib, Vbe, Vce 大).txt");

% 部分保存格式错误的数据, 进行修正

% stc_data.IcVceIb_IbVceIb.data_Ib
if 1    % 保存格式错误, 挑选一部分数据
    data_Ib = stc_data.IcVceIb_IbVceIb.data_Ib;
    % 依据 Vrb (I_b) 对数据分组
    leg_Vrb = unique(data_Ib(:, 6));   % 提取 Vrb 字符串
    length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
    Index = zeros(length_Ib, 2);    % 左起始, 右终止
    for i = 1:length_Ib
        Index(i, 1) = find(  round(data_Ib(:, 6), 4) == leg_Vrb(i)  , 1, 'first' );
        % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
        Index(i, 2) = find(  round(data_Ib(:, 6), 4) == leg_Vrb(i)   , 1, 'last' );
        % 找到最后一个
    end
    
    % 挑选部分数据
    tv = size(Index, 1);
    tv = round(linspace(1, tv, 11));
    new_Index = Index(tv(1), 1):Index(tv(1), 2);
    for i = 2:length(tv)
        new_Index = [new_Index, Index(tv(i), 1):Index(tv(i), 2)];
    end
    data_Ib = data_Ib(new_Index, :);
    stc_data.IcVceIb_IbVceIb.data_Ib = data_Ib;
end

% stc_data.IcVceIb_IbVceIb.data_Ic
if 1    % 保存格式错误, 挑选一部分数据
    data_Ic = stc_data.IcVceIb_IbVceIb.data_Ic;
    % 依据 Vrb (I_b) 对数据分组
    leg_Vrb = unique(data_Ic(:, 6));   % 提取 Vrb 字符串
    length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
    Index = zeros(length_Ib, 2);    % 左起始, 右终止
    for i = 1:length_Ib
        Index(i, 1) = find(  round(data_Ic(:, 6), 4) == leg_Vrb(i)  , 1, 'first' );
        % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
        Index(i, 2) = find(  round(data_Ic(:, 6), 4) == leg_Vrb(i)   , 1, 'last' );
        % 找到最后一个
    end
    
    % 挑选部分数据
    % 依据 Vrb (I_b) 对数据分组
    leg_Vrb = unique(data_Ic(:, 6));   % 提取 Vrb 字符串
    length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
    Index = zeros(length_Ib, 2);    % 左起始, 右终止
    for i = 1:length_Ib
        Index(i, 1) = find(  round(data_Ic(:, 6), 4) == leg_Vrb(i)  , 1, 'first' );
        % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
        Index(i, 2) = find(  round(data_Ic(:, 6), 4) == leg_Vrb(i)   , 1, 'last' );
        % 找到最后一个
    end
    i = 1;
    new_Index = round(linspace(Index(i, 1), Index(i, 2), 201), 0);
    for i = 2:length(tv)
        new_Index = [new_Index, round(linspace(Index(i, 1), Index(i, 2), 201), 0)];
    end
    data_Ic = data_Ic(new_Index, :);
    stc_data.IcVceIb_IbVceIb.data_Ic = data_Ic;
end

% stc_data.IcVbeVce_IbVbeVce.data_Ib
% Ib 的单位错了, 需要转换一下
stc_data.IcVbeVce_IbVbeVce.data_Ib(:, 2) = stc_data.IcVbeVce_IbVbeVce.data_Ib(:, 2)/100;  % 10Ohm 错误, 1K 正确

stc_fig = MyDataProcessor_BJT_AllData(stc_data)
%MyDataProcessor_BJT_AllData_figExport(stc_fig)
%}


    export = 0;
    % 总参数赋值
        name = stc_data.name;
        R_Ib_low = stc_data.R_Ib_low;
        R_Ib_high = stc_data.R_Ib_high;
        unit_Ic = stc_data.unit_Ic;
        unit_Ib = stc_data.unit_Ib;
        unit_Vce = stc_data.unit_Vce;
        unit_Vbe = stc_data.unit_Vbe;
        data_window = stc_data.data_window;
        rO_window = stc_data.rO_window;
    % 第一部分: No.1 (Ic, Vce, Ib 大)
    if isfield(stc_data, 'IcVceIb')
        %stc.stc_Ic_Vce_Ib_big = MyDataProcessor_BJT_Data1_IcVceIb(stc_data.IcVceIb.data, data_window, name, rO_calcu, rO_window, R_Ib, unit_Ic, unit_Ib);
        stc.stc_Ic_Vce_Ib_big = MyDataProcessor_BJT_Data1_IcVceIb(stc_data.IcVceIb.data, data_window, name, false, 1, R_Ib_low, unit_Ic, 'mA');
        if export
            MyExport_pdf(stc.stc_Ic_Vce_Ib_big.num1.fig)
        end
    end

    % 第二部分: No.3 (Ic, Vce, Ib 小 3D)
    if isfield(stc_data, 'IcVceIb_3D')
        %stc_Ic_Vce_Ib_3D = MyDataProcessor_BJT_Data1_IcVceIb_3D(data, name, R_Ib, unit_Ic, unit_Ib);
        stc.stc_Ic_Vce_Ib_3D = MyDataProcessor_BJT_Data1_IcVceIb_3D(stc_data.IcVceIb_3D.data, name, R_Ib_high, unit_Ic, 'uA');
        if export
            MyExport_pdf_modal(stc.stc_Ic_Vce_Ib_3D.fig)  % 用 modal 以防颜色丢失
        end
    end
        
    % 第三部分: No.2 (Ic, Vce, Ib 小) No.4 (Ib, Vce, Ib 小) 和 (1/rO, Ic, Ib), (beta, Vce, Ib 小)
    if isfield(stc_data, 'IcVceIb_IbVceIb')
        %[stc_Ic_Vce_Ib, stc_Ib_Vce_Ib, stc_rO_Ic_Ib, stc_Beta_Vce_Ib] = MyDataProcessor_BJT_Data18_IcVceIb_IbVceIb_BetaVceIb(data_Ic, data_Ib, data_window, name, rO_calcu, rO_window, R_Ib, unit_Ic, unit_Ib);
        [stc.stc_Ic_Vce_Ib, stc.stc_Ib_Vce_Ib, stc.stc_rO_Ic_Ib, stc.stc_Beta_Vce_Ib] = ...
            MyDataProcessor_BJT_Data18_IcVceIb_IbVceIb_BetaVceIb(...
                stc_data.IcVceIb_IbVceIb.data_Ic, stc_data.IcVceIb_IbVceIb.data_Ib, ...
                data_window, name, true, rO_window, R_Ib_high, unit_Ic, unit_Ib...
            );
        if export
            MyExport_pdf(stc.stc_Ic_Vce_Ib.num1.fig)
            MyExport_pdf(stc.stc_Ib_Vce_Ib.num1.fig)
            MyExport_pdf(stc.stc_rO_Ic_Ib.num1.fig)
            MyExport_pdf(stc.stc_Beta_Vce_Ib.num1.fig)
        end
    end
        
    % 第四部分: No.5 (Vce_sat, Ic, beta 大) 和 No.6 (Vbe_sat, Ic, beta 大)
    if isfield(stc_data, 'VcesatIcBeta10_VbesatIcBeta10')
       %stc.stc_Vsat_Ic = MyDataProcessor_BJT_Data67_VsatIc(data_Vcesat, data_Vbesat, 5, name, unit_Ic, unit_Vbe, unit_Vce);
       stc.stc_Vsat_Ic = MyDataProcessor_BJT_Data67_VsatIc(stc_data.VcesatIcBeta10_VbesatIcBeta10.data_Vcesat, stc_data.VcesatIcBeta10_VbesatIcBeta10.data_Vbesat, 5, name, 'mA', 'mV', 'mV');
       if export
           MyExport_pdf(stc.stc_Vsat_Ic.num1.fig)
       end
    end

    % 第五部分: No.7 (Ib, Vce, Vbe 大) No.8 (Ic, Vce, Vbe 大) 和 (1/rO, Vce, Vbe) (beta, Vce, Vbe)
    % 以及 (gmrO, Vce, Vbe)
    flag_gmrO = false;
    if isfield(stc_data, 'IcVceVbe_IbVceVbe')
        %[stc_Ic_Vce_Vbe, stc_Ib_Vce_Vbe, stc_Beta_Vce_Vbe] = MyDataProcessor_BJT_Data45_IcVceVbe_IbVceVbe_and_BetaVceVbe(data_Ic, data_Ib, data_window, name, unit_Ic, unit_Ib, unit_Vce, unit_Vbe)
        [stc.stc_Ic_Vce_Vbe, stc.stc_Ib_Vce_Vbe, stc.stc_rO_Ic_Vbe, stc.stc_Beta_Vce_Vbe] = MyDataProcessor_BJT_Data45_IcVceVbe_IbVceVbe_and_BetaVceVbe(stc_data.IcVceVbe_IbVceVbe.data_Ic, stc_data.IcVceVbe_IbVceVbe.data_Ib, 5, name, unit_Ic, 'mA', unit_Vce, unit_Vbe);
        if export
            MyExport_pdf(stc.stc_Ic_Vce_Vbe.num1.fig)
            MyExport_pdf(stc.stc_Ib_Vce_Vbe.num1.fig)
            MyExport_pdf(stc.stc_Beta_Vce_Vbe.num1.fig)
        end
        % 提取拟合到的 Va 和 Ic0, 为 gmrO 作准备
        Va_without_Ic0 = stc.stc_rO_Ic_Vbe.Va_without_Ic0;
        Va_with_Ic0 = stc.stc_rO_Ic_Vbe.Va_with_Ic0;
        Ic0 = stc.stc_rO_Ic_Vbe.Ic0;
        flag_gmrO = true;
    end
        
    % 第六部分: No.88 (Ic, Vce, Vbe 大 3D)
    if isfield(stc_data, 'IcVceVbe_3D')
        stc.stc_Ic_Vce_Vbe_3D = MyDataProcessor_BJT_Data88_IcVceVbe_3D(stc_data.IcVceVbe_3D.data, name, R_Ib_low, unit_Ic, unit_Ib);
        if export
            MyExport_pdf_modal(stc.stc_Ic_Vce_Vbe_3D.fig)  % 用 modal 以防颜色丢失
        end
    end
    % 第七部分: No.9 (Ic, Vbe, Vce 大) No.10 (Ib, Vbe, Vce 大) 以及
    % (gm, Vbe, Vce), (gm, Ic, Vce), (Beta, Vbe, Vce), (Beta, Ic, Vce), (rpi, Vbe, Vce), (rpi, Ic, Vce)
    if isfield(stc_data, 'IcVbeVce_IbVbeVce')
        [ ...
         stc.stc_Ic_Vbe_Vce, stc.stc_Ib_Vbe_Vce, stc.stc_gm_Ic_Vce, stc.stc_gm_Vbe_Vce,...
         stc.stc_Beta_Vbe_Vce, stc.stc_Beta_Ic_Vce, stc.stc_rpi_Ic_Vce, stc.stc_rpi_Vbe_Vce...
        ] ...
        = MyDataProcessor_BJT_Data23_IcVbeVce_IbVbeVce_gm_rpi_BetaVbeVce...
          (...
            stc_data.IcVbeVce_IbVbeVce.data_Ic, stc_data.IcVbeVce_IbVbeVce.data_Ib, data_window, name, 1, 15, ...
            2, unit_Ic, 'mA', 'mV', unit_Vce...
          );
        if export
            MyExport_pdf(stc.stc_Ic_Vbe_Vce.num1.fig)
            MyExport_pdf(stc.stc_gm_Ic_Vce.num1.fig)
            MyExport_pdf(stc.stc_gm_Vbe_Vce.num1.fig)
            MyExport_pdf(stc.stc_Beta_Vbe_Vce.num1.fig)
            MyExport_pdf(stc.stc_Beta_Ic_Vce.num1.fig)
            MyExport_pdf(stc.stc_rpi_Ic_Vce.num1.fig)
            MyExport_pdf(stc.stc_rpi_Vbe_Vce.num1.fig)
        end
    end
    Vt = stc.stc_gm_Ic_Vce.V_T; % 提取拟合到的 Vt, 为 gmrO 作准备
    

    %%
    % 第部分:  计算并作出 gmrO (intrisic gain), (gmrO, Vce, Vbe)
    line = '---------------------------------------';
    disp(line)
    disp("  V_T' = " + num2str(Vt*1000) + ' mV')
    disp("  V_A' = " + num2str(Va_without_Ic0) + ' V  (without I_C0)')
    disp("  intrisic gain = " + num2str(Va_without_Ic0/Vt))
    disp(line)
        if 0
            unit_Ic = 'mA';
        % 依据 Vrb (I_b) 对数据分组
        data = stc_data.IcVceIb.data;
        leg_Vrb = unique(round(data(:, 6), 5));   % 提取 Vrb 字符串
        length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
        Index = zeros(length_Ib, 2);    % 左起始, 右终止
        for i = 1:length_Ib
            Index(i, 1) = find(  round(data(:, 6), 4) == round(leg_Vrb(i), 4)  , 1, 'first' );
            % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
            Index(i, 2) = find(  round(data(:, 6), 4) == round(leg_Vrb(i), 4)   , 1, 'last' );
            % 找到最后一个
        end
        
        switch unit_Ic
            case 'A'
                amplification_Ic = 1;
            case 'mA'
                amplification_Ic = 1e3;
            case 'uA'
                amplification_Ic = 1e6;
        end
        
            gain_intrisic = @(Ic) Va_with_Ic0 / Vt *  Ic./(Ic-Ic0);
            Ic_min = 1e-6;
            Ic_max = data(end, 2);
            tv_Ic = logspace(log(Ic_min)/log(10), log(Ic_max)/log(10), 100);
            stc = MyPlot(tv_Ic*amplification_Ic, gain_intrisic(tv_Ic));
            stc.axes.XLim(1) = 1e-6*amplification_Ic;
            stc.axes.YLim = [0 8000];
            stc.axes.XScale = 'log';
        end
end

























