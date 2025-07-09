function stc_visa = MyOscilloscope_MSO2202A_read_alldata(ch, four_level)
    % 初始化
    instrreset  % 创建 visa 对象前, 断开并删除全部对象, 防止报错
    stc_visa = visa( 'NI', 'USB0::0x1AB1::0x04B0::DS2F192200361::INSTR' );
    stc_visa.InputBufferSize = 14e6 + 2048;    % 一般示波器返回 1400 个数据点
    fopen(stc_visa);    % 打开已创建的VISA对象
    % 无需改动的数据读取设置
    fprintf(stc_visa,':WAVEFORM:FORMAT BYTE');  % 设置数据传输形式, {WORD|BYTE|ASCii}

    % 示波器设置
    str_channel = ":WAVeform:SOURce CHANnel" + num2str(ch); % 用于数据读取
    fprintf(stc_visa,':ACQuire:MDEPth?'); depth_origin = str2num(char(fread( stc_visa, 2048 ))');   % 读取当前存储深度
    fprintf(stc_visa, ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay?'); tv = str2num(char(fread( stc_visa, 2048 ))');   % 检查另一通道是否打开
    if tv == 1  % 另一通道处于打开状态
        str_channel_on = ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay on';
        str_channel_off = ":CHANnel" + num2str(mod(ch+2, 2)+1) + ':DISPlay off';
        fprintf(stc_visa, str_channel_off); % 关闭另一通道
    end
    if four_level >= 4
        disp('不建议 level = 4, 读取未执行')
        return
    end
    depth = 1400*10^four_level;    % 计算存储深度, 14e3 ~ 14e6 (非交织模式) or 7e3 ~ 7e6 (交织模式, 即两通道同时打开)
    fprintf(stc_visa,":ACQuire:MDEPth " + num2str(depth));  % 设置存储深度
    fprintf(stc_visa,':STOP'); disp('已停止示波器运行') % 暂停示波器

    % 数据读取设置
    fprintf(stc_visa, str_channel);  % 设置要读取的通道, {CHANnel1|CHANnel2|MATH|FFT|LA}
    fprintf(stc_visa, ':WAVeform:MODE RAW');  % 设置读取模式, {NORMal|RAW|MAXimum}
    fprintf(stc_visa, ':WAVeform:Start 1');
    fprintf(stc_visa, ":WAVeform:POINts " + num2str(depth));

    % 开始读取数据
    fprintf(stc_visa, ':wav:data?'); [data, ~]= fread(stc_visa, stc_visa.InputBufferSize); % 读取波形数据 
    fprintf(stc_visa, ':WAVeform:XINCrement?'); [X_increment,~]= fread( stc_visa, stc_visa.InputBufferSize ); % 读取时间刻度
    fprintf(stc_visa, ':WAVeform:YINCrement?'); [Y_increment,~]= fread( stc_visa, stc_visa.InputBufferSiz ); % 读取电压刻度
    fprintf(stc_visa, ':WAVeform:YREFerence?'); [Y_ref_index,~]= fread( stc_visa, 2048 ); % 读取电压参考线
    fprintf(stc_visa, ':WAVeform:YORigin?'); [Y_bias_index,~]= fread( stc_visa, 2048 ); % 读取电压偏移
    fprintf(stc_visa,':ACQuire:SRATe?'); Fs = fscanf(stc_visa); Fs = str2double(Fs); % 读取采样频率

    % 恢复示波器设置
    if tv == 1  % 另一通道原本是打开状态
        fprintf(stc_visa, str_channel_on); % 打开另一通道
    end
    fprintf(stc_visa,':RUN'); disp('已重新开启示波器') % 先开启, 再恢复深度
    fprintf(stc_visa,":ACQuire:MDEPth " + num2str(depth_origin));   % 恢复存储深度
    

    % 关闭设备
    fclose(stc_visa); % 关闭连接 (必须要有), 否则再次调用时会报错
    delete(stc_visa); 
    clear stc_visa; 
    
    %{
    数据处理：
        读取的波形数据含有 TMC 头，长度为 11 个字节，
        其中前 2 个字节分别为 TMC 头标志符 '#' 和宽度描述符 9，
        接着的 9 个字节为数据长度，然后是波形数据，最后一个字节为结束符 0x0A。
        所以，读取的有效波形数据点为 12 到倒数第 2 个点 
    %}
    data = data(12:(end-1));  % 获取有效数据点
    X_increment = str2double(char(X_increment)'); % str ascii 码转换成数字
    Y_increment = str2double(char(Y_increment)'); % str ascii 码转换成数字
    Y_ref_index = str2double(char(Y_ref_index)'); % str ascii 码转换成数字
    Y_bias_index = str2double(char(Y_bias_index)'); % str ascii 码转换成数字
    
    data = data - Y_ref_index - Y_bias_index; % 减去参考线的位置再减去偏移
    data = data * Y_increment; % 将单位从格数转化为 vol
    time = 0 : X_increment : ( (length(data)-1)*X_increment );   % 创建时间轴

    % 结果展示
    data_length = length(data);
    sampling_time = time(end) + X_increment;
    sampling_rate = length(data)/(time(end) + X_increment);
    disp(  "Sampling Points: " + num2str(data_length)  ) % 显示总采样点数
    disp(  "Sampling Time: " + num2str(sampling_time) + ' s' ) % 显示采样时间长度
    disp(  "Sampling Rate: " + num2str(sampling_rate) + ' Sa/s' ) % 显示采样率
    stc_visa.stc_spectrum = MyAnalysis_Spectrum_3fig(data', time', 0);  % 进行频谱分析并作图

    % 导出结果
    stc_visa.data = data;
    stc_visa.time = time;
    stc_visa.data_length = length(data);
    stc_visa.sampling_time = time(end) + X_increment;
    stc_visa.sampling_rate = length(data)/(time(end) + X_increment);
end
