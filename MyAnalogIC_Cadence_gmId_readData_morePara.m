function stc = MyAnalogIC_Cadence_gmId_readData_morePara(deviceName, flag_plot)
    data_str = [
        "selfGain"          % 1
        "currentDensity"    
        "transientFreq"
        "overdrive"
        "vgs"               % 5
        "gm"
        "rout"
    ];
    data_polarity = [
        1    % 1
        1
        1
        -1
        -1   % 5
        1
        1
    ];
    
%%
    export_path = "D:\a_Win_VM_shared\a_Misc\Cadence_Data";
    export_deviceName = deviceName;
    export_fileFormat = ".txt";
    data_str__ = '_' + data_str;
    stc.definedParameters = [];
    stc.definedParameters_polarity = [];
    for i = 1:length(data_str)
        filePath = strcat(export_path, "/", export_deviceName, "/", export_deviceName, data_str__(i), export_fileFormat);
        if exist(filePath, 'file') == 2
            disp('Loding: ' + data_str(i))
            stc.(data_str(i)) = MyAnalogIC_Cadence_ReadData_txt(filePath, flag_plot);
            stc.definedParameters = [stc.definedParameters; data_str(i)];
            stc.definedParameters_polarity = [stc.definedParameters_polarity; data_polarity(i)];
        else
            disp('Not found: ' + data_str(i))
        end
    end

%{
    export_path = "D:\a_Win_VM_shared\a_Misc\Cadence_Data";
    export_deviceName = deviceName;
    export_fileFormat = ".txt";

    path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat);
    path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat);
    path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat);
    path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat);
    path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat);
 
    stc.selfGain = MyAnalogIC_Cadence_ReadData_txt(path_selfGain, flag_plot);
    stc.currentDensity = MyAnalogIC_Cadence_ReadData_txt(path_currentDensity, flag_plot);
    stc.transientFreq = MyAnalogIC_Cadence_ReadData_txt(path_transientFreq, flag_plot);
    stc.overdrive = MyAnalogIC_Cadence_ReadData_txt(path_overdrive, flag_plot);
    stc.vgs = MyAnalogIC_Cadence_ReadData_txt(path_vgs, flag_plot);
%}
end