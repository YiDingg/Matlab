function stc = MyAnalogIC_Cadence_gmId_etaDefinition_1(stc)
%{ 
常规 eta 定义:
    self gain:          eta = (z - z_0)/z_0 = z/z_0 - 1
    current density:    eta = ... (同上)
    transient freq:     eta = ...
    vgs:                eta = (1/z - 1/z_0)/(1/z_0) = z_0/z - 1
    overdrive voltage   eta = ... (同上)
%}
%%
    stc.fieldNames = fieldnames(stc); % 查找字段
    stc.flag_eta_defined = 1;
    for i = 1:length(stc.definedParameters) % 遍历所有字段, 给予 eta 定义
        if  stc.definedParameters_polarity(1) == 1
            stc.(stc.definedParameters{i}).eta_func = @(z, z_0) z./z_0 - 1;
            %disp(stc.fieldNames{i})
        else 
            stc.(stc.definedParameters{i}).eta_func = @(z, z_0) z_0./z - 1;
            %disp(stc.fieldNames{i})
        end
    end
end