function stc = MyDataProcessor_MOS_3D_Data2_IdVgsVds(data, unit_Id)
    data(:, 5) = data(:, 4);    % 依据 data(:, 4) 来分组
    data(:, 1) = data(:, 3);
    windowSize = 1;
    stc = MyDataProcessor_MOS_3D_Data1_IdVdsVgs(data, unit_Id, windowSize);
    ori_x = stc.label_left.x.String;
    ori_y = stc.label_left.y.String;
    stc.label_left.x.String = ori_y;
    stc.label_left.y.String = ori_x;
    ori_x = stc.label_right.x.String;
    ori_y = stc.label_right.y.String;
    stc.label_right.x.String = ori_y;
    stc.label_right.y.String = ori_x;
    stc.light3 = light(stc.axes_left);            % create a light
    lightangle(stc.light3, 90, 135);   % 设置 light 角度
    
end