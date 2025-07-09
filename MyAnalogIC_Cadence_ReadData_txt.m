function stc = MyAnalogIC_Cadence_ReadData_txt(filePath, flag_plot)
Debug = 0;
% 读取 SKILL 代码导出的 .txt 文件, 数字格式 scientific, cadence 数据导出参考代码见文末
% 导出的数据格式为 "colomn"
%%
    % filePath = "D:\a_Win_VM_shared\a_Misc\Cadence_Data\tsmc18rf_gmIdData_nmos2v\tsmc18rf_gmIdData_nmos2v_selfGain.txt";
    fileContent = fileread(filePath);

% 提取 length
    % 定义正则表达式匹配模式, 提取 length 信息
    pattern = "\(L = (\d+\.\d*)e-(\d*)\)";
    matches = regexp(fileContent, pattern, 'tokens');
    
    % 提取所有匹配的L值并转换为数值
    secondVarible = zeros(size(matches));
    for i = 1:length(matches) % 遍历匹配项并转换为数值
        base = str2double(matches{i}{1}); % 获取基数部分
        exponent = matches{i}{2}; % 获取指数部分（如果有）
        if ~isempty(exponent)
            L_value = base * 10^str2double("-" + exponent); % 处理科学计数法
        else
            L_value = base; % 没有指数部分，直接使用基数
        end
        % 将值添加到数组 A 中
        secondVarible(i) = L_value;
    end

    if Debug 
        disp("Second Varible' = ")
        disp(secondVarible')
    end

% 提取

% 读取文件内容
fileID = fopen(filePath, 'r');
if fileID == -1
    error('无法打开文件');
end

% 初始化变量
data_left = [];
data_right = [];
dataMatrix = []; % 存储所有数据
currentSet = []; % 当前数据集
isCollecting = false; % 是否正在收集数据

% 逐行读取文件内容
while ~feof(fileID)
    line = fgetl(fileID);
    
    % 检查是否是数据块的开始
    if contains(line, 'Set No.')
        % 如果已经在收集数据，保存当前数据集
        if isCollecting     % 将当前数据集追加到总矩阵
            data_left = [data_left, currentSet(:, 1)];
            data_right = [data_right, currentSet(:, 2)];

        end
        currentSet = []; % 初始化新的数据集
        isCollecting = true; % 开始收集数据
    elseif isCollecting && ~isempty(line) && ~contains(line, '#') && ~contains(line, 'L =')
        % 提取数据行
        data = str2num(line); % 将字符串转换为数值
        if length(data) == 2
            currentSet = [currentSet; data]; % 将数据添加到当前数据集
        end
    end
end

% 保存最后一个数据集
if isCollecting
    data_left = [data_left, currentSet(:, 1)];
    data_right = [data_right, currentSet(:, 2)];
end

% 关闭文件
fclose(fileID);

if Debug
    % 显示结果
    disp('提取的数据矩阵：');
    disp(dataMatrix);
    disp(data_left);
end

Length = zeros(size(data_left)) + secondVarible;
if flag_plot
   stc.mysurf = MySurf(data_left, Length, data_right);
end

% 返回结果
stc.data_left = data_left;
stc.data_right = data_right;
stc.secondVarible = secondVarible;
if Debug
    filePath    % 显示数据来源
end

%{
; 20250529: 给出 cadence 中导出数据的参考代码如下 (SKILL 语言)
; 快速导出 gm-Id 仿真数据

    ; 设置数据导出路径和器件名称
        ; 完整路径例如 "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data/tsmc18rf_gmIdData_nmos2v/tsmc18rf_gmIdData_nmos2v_test.txt"
        export_path = "/home/IC/a_Win_VM_shared/a_Misc/Cadence_Data"
        export_deviceName = "tsmc18rf_gmIdData_nmos2v"
        export_fileFormat = ".txt"
    ; 创建各个数据的 filePathAndName
        path_selfGain = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_selfGain", export_fileFormat)
        path_currentDensity = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_currentDensity", export_fileFormat)
        path_transientFreq = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_transientFreq", export_fileFormat)
        path_overdrive = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_overdrive", export_fileFormat)
        path_vgs = strcat(export_path, "/", export_deviceName, "/", export_deviceName, "_vgs", export_fileFormat)
    ; 导出数据
        ocnPrint(   ; 1. 导出 self gain (gm*rO)
            ?output path_selfGain
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "self_gain"))
        )
        ocnPrint(   ; 2. 导出 current density (Id/W)
            ?output path_currentDensity
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "id") / VAR("W")))
        )
        ocnPrint(   ; 3. transient freq (gm/2*pi*((Cgs+Cgd)))
            ?output path_transientFreq
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y (OS("/NMOS" "gm") / (2 * 3.1415926 * abs((OS("/NMOS" "cgs") + OS("/NMOS" "cgd"))))))
        )
        ocnPrint(   ; 4. 导出 minimum overdrive (Vdsat)
            ?output path_overdrive
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vdsat"))
        )
        ocnPrint(   ; 5. gate-source voltage (Vgs)
            ?output path_vgs
            ?numberNotation 'scientific
            waveVsWave(?x OS("/NMOS" "gmoverid") ?y OS("/NMOS" "vgs"))
        )
%}
end
