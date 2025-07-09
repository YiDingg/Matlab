function co = MyAnalogIC_Cadence_gmId_parameterDefinitions(str)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
注：此函数已废弃
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% 返回 1: selfGain 之类的越大越好的参数
% 返回 -1: overdrive 之类的越小越好的参数

higher_better_str = [
    "selfGain"
    "currentDensity"
    "transientFreq"
    "gm"
    "rout"
];
lower_better_str = [
    "overdrive"
    "vgs"
];

    if ismember(str, higher_better_str)
        co = 1;
        return
    elseif ismember(str, lower_better_str)
        co = -1;
        return
    else
        error("[Error] performance parameter undifined!")
    end

end