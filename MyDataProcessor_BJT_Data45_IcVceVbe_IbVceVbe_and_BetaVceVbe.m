function [stc_Ic_Vce_Vbe, stc_Ib_Vce_Vbe, stc_rO_Ic_Vbe, stc_Beta_Vce_Vbe] = MyDataProcessor_BJT_Data45_IcVceVbe_IbVceVbe_and_BetaVceVbe(data_Ic, data_Ib, data_window, name, unit_Ic, unit_Ib, unit_Vce, unit_Vbe)
%%
%{
Input format:
1 (CH2)  2 (CH1)       3      4   5   6 
 x        y            -      -   -  var 
Vce (V)	 Ic/Ib (A)	   -	  -	  -  Vrb (V)
%}


switch unit_Vbe
    case 'V'
        amplification_Vbe = 1;
    case 'mV'
        amplification_Vbe = 1e3;
    case 'uV'
        amplification_Vbe = 1e6;
end

switch unit_Vce
    case 'V'
        amplification_Vce = 1;
    case 'mV'
        amplification_Vce = 1e3;
    case 'uV'
        amplification_Vce = 1e6;
end

data_Ib(:, 1) = data_Ib(:, 1)*amplification_Vce;    % 转换 Vce 单位
data_Ib(:, 6) = data_Ib(:, 6)*amplification_Vbe;    % 转换 Vbe 单位
data_Ic(:, 1) = data_Ic(:, 1)*amplification_Vce;    % 转换 Vce 单位
data_Ic(:, 6) = data_Ic(:, 6)*amplification_Vbe;    % 转换 Vbe 单位

% 作出 Ic 曲线图
[stc_Ic_Vce_Vbe, stc_rO_Ic_Vbe] = MyDataProcessor_BJT_Data1_IcVceIb(data_Ic, data_window, name, true, 20, 1, unit_Ic, 'A');
stc_Ic_Vce_Vbe.num1.label.y.String = "Collector Current $I_C$ (" + unit_Ic + ')';
stc_Ic_Vce_Vbe.num1.axes.Title.String = name + " $(I_{C},\ V_{CE},\ V_{BE})$";
% 转化 Vbe 单位的 str
str_var = stc_Ic_Vce_Vbe.num1.leg.String;
str_var = replace(str_var, 'I_{B}', 'V_{BE}');
str_var = replace(str_var, 'A', unit_Vbe);
stc_Ic_Vce_Vbe.num1.leg.String = str_var;
str = [str_var, "$1/r_O = I_C/V_A$", "$1/r_O = (I_C - I_{C0})/V_A$"];
stc_rO_Ic_Vbe.num1.leg.String = str;
% 转化 Vce 单位的 str
str_x = stc_Ic_Vce_Vbe.num1.label.x.String;
str_x = replace(str_x, '(V)', "(" + unit_Vce + ")");
stc_Ic_Vce_Vbe.num1.label.x.String = str_x;


% 作出 Ib 曲线图
unit_Ib = 'uA';
[stc_Ib_Vce_Vbe, ~] = MyDataProcessor_BJT_Data1_IcVceIb(data_Ib, data_window, name, false, 0, 1, unit_Ib, 'A');
stc_Ib_Vce_Vbe.num1.label.y.String = "Base Current $I_B$ (" + unit_Ib + ')';
stc_Ib_Vce_Vbe.num1.axes.Title.String = name + " $(I_{B},\ V_{CE},\ V_{BE})$";
stc_Ib_Vce_Vbe.num1.leg.String = str_var;
stc_Ib_Vce_Vbe.num1.label.x.String = str_x;
stc_Ib_Vce_Vbe.num1.axes.YLim(2) = data_Ib(end, 2)*1.3*10^6;    % 调整 Ib 纵坐标范围, data_Ib 的 unit 是 A, 图中的纵坐标单位是 unit_Ib = 'uA'

% 计算 beta 并作图
beta = data_Ic(:, 2)./data_Ib(:, 2);
data_beta = data_Ic;
data_beta(:, 2) = beta;
[stc_Beta_Vce_Vbe, ~] = MyDataProcessor_BJT_Data1_IcVceIb(data_beta, data_window, name, false, 0, 1, 'A', 'A');
stc_Beta_Vce_Vbe.num1.label.y.String = "DC Current Gain $\beta$";
stc_Beta_Vce_Vbe.num1.axes.Title.String = name + " $(\beta,\ V_{CE},\ V_{BE})$";
stc_Beta_Vce_Vbe.num1.leg.String = str_var;
stc_Beta_Vce_Vbe.num1.label.x.String = str_x;
end