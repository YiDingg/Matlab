function [stc_Ic_Vce_Ib, stc_Ib_Vce_Ib, stc_rO_Ic_Ib, stc_Beta_Vce_Ib] = MyDataProcessor_BJT_Data18_IcVceIb_IbVceIb_BetaVceIb(data_Ic, data_Ib, data_window, name, gOfit, rO_window, R_Ib, unit_Ic, unit_Ib)
    %% (Ic, Vce, Ib) 和 (gO, Ic, Ib)
    [stc_Ic_Vce_Ib, stc_rO_Ic_Ib] = MyDataProcessor_BJT_Data1_IcVceIb(data_Ic, data_window, name, gOfit, rO_window, R_Ib, unit_Ic, unit_Ib);
    
    %% (Ib, Vce, Ib)
    [stc_Ib_Vce_Ib, ~] = MyDataProcessor_BJT_Data1_IcVceIb(data_Ib, data_window, name, false, false, R_Ib, unit_Ib, unit_Ib);
    stc_Ib_Vce_Ib.num1.label.y.String = "Actual Base Current $I_B$ (" + unit_Ib + ')';
    stc_Ib_Vce_Ib.num1.axes.Title.String = name + " $(I_{B,actual},\ V_{CE},\ I_B)$";
    switch unit_Ib
        case 'A'
            amplification_Ib = 1;
        case 'mA'
            amplification_Ib = 1e3;
        case 'uA'
            amplification_Ib = 1e6;
    end
    leg_Vrb = unique(round(data_Ic(:, 6), 5));   % 提取 Vrb 字符串
    stc_Ib_Vce_Ib.num1.axes.YLim(2) = max(leg_Vrb)/R_Ib*amplification_Ib;

    %% (Beta, Vce, Ib)
    data_Beta = data_Ic;
    data_Beta(:, 2) = data_Ic(:, 2)./data_Ib(:, 2);
    stc_Beta_Vce_Ib = MyDataProcessor_BJT_Data1_IcVceIb(data_Beta, data_window, name, false, false, R_Ib, 'A', unit_Ib);
    stc_Beta_Vce_Ib.num1.label.y.String = "DC Current Gain $\beta$";
    stc_Beta_Vce_Ib.num1.axes.Title.String = name + " $(\beta,\ V_{CE},\ I_B)$";
    stc_Beta_Vce_Ib.num1.leg.Location = 'southeast';
end