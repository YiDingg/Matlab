function stc = MyAnalogIC_Cadence_gmId_readData(deviceName, flag_plot)
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
end