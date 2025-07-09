function  MyInvertingBuck_VoltageRange(Buck, V_in_inv, V_out_inv, V_in_inv_range)
% buck 参数:
    % [V_in_min, V_in_max, V_out_min, Delta_V]
    V_in_min = Buck(1);
    V_in_max = Buck(2);
    V_out_min = Buck(3);
    Delta_V = Buck(4);
% 展示 buck 参数
    disp('------------------------------------------------')
    disp('Buck Parameters:')
    disp(['V_in_buck from ', num2str(V_in_min, '%.1f'), ' V to ', num2str(V_in_max, '%.1f'), ' V'])
    disp(['V_out > ',  num2str(V_out_min, '%.1f'), ' V'])
    disp(['Delta_V > ',  num2str(Delta_V, '%.1f'), ' V'])
% 计算 inverting 中的电压范围
    disp(' ')
    disp('Inverting Configuration:')
    disp(['V_in - V_out  >  ', num2str(V_in_min, '%.1f'), ' V'])
    disp(['V_in - V_out  <  ', num2str(V_in_max, '%.1f'), ' V'])
    disp(['V_in          >  ', num2str(Delta_V, '%.1f'), ' V'])
    disp(['V_out         <  ', num2str(-V_out_min, '%.1f'), ' V'])
% 给定输入电压 V_in_inv 时
    %V_in_inv = +5; 
    disp(' ')
    disp(['Configure V_in_inv = ', num2str(V_in_inv, '%.1f'), ' V'])
    %{
    disp(['V_out  <  ', num2str(V_in_inv - V_in_min, '%.1f'), ' V'])
    disp(['V_out  >  ', num2str(V_in_inv - V_in_max, '%.1f'), ' V'])
    disp(['V_out  <  ', num2str(-V_out_min, '%.1f'), ' V'])
    %}
    Max = min( V_in_inv - V_in_min, -V_out_min);
    Min = V_in_inv - V_in_max;
    disp(['V_out from ', num2str(Min, '%.1f'), ' V to ', num2str(Max, '%.1f'), ' V'])
    
% 给定输出电压 V_out_inv 时
    %V_out_inv = -12; 
    disp(' ')
    disp(['Configure V_out_inv = ', num2str(V_out_inv, '%.1f'), ' V'])
    %{
    disp(['V_in   >  ', num2str(V_in_min + V_out_inv, '%.1f'), ' V'])
    disp(['V_in   <  ', num2str(V_in_max + V_out_inv, '%.1f'), ' V'])
    disp(['V_in   >  ', num2str(Delta_V, '%.1f'), ' V'])
    %}
    Max = V_in_max + V_out_inv;
    Min = max(V_in_min + V_out_inv, Delta_V);
    disp(['V_in from ', num2str(Min, '%.1f'), ' V to ', num2str(Max, '%.1f'), ' V'])
    
% 给定输入电压范围 V_in_inv_range 和输出电压 V_out_inv 时
    %V_in_inv_range = [3 12]; 
    disp(' ')
    disp(['Configure V_in_inv = ', num2str(V_in_inv_range(1), '%.1f'), ' V ~ ', num2str(V_in_inv_range(2), '%.1f'), ' V'])
    %{
    disp(['V_out  <  ', num2str(min(V_in_inv_range - V_in_min), '%.1f'), ' V'])
    disp(['V_out  >  ', num2str(max(V_in_inv_range - V_in_max), '%.1f'), ' V'])
    disp(['V_out  <  ', num2str(-V_out_min, '%.1f'), ' V'])
    %}
    Max = min( min(V_in_inv_range - V_in_min), -V_out_min);
    Min = max(V_in_inv_range - V_in_max);
    disp(['V_out from ', num2str(Min, '%.1f'), ' V to ', num2str(Max, '%.1f'), ' V'])

    disp('------------------------------------------------')
end