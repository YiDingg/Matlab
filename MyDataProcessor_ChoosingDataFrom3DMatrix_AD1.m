function data = MyDataProcessor_ChoosingDataFrom3DMatrix_AD1(data)
    % 依据 Vrb (I_b) 对数据分组
    leg_Vrb = unique(data(:, 6));   % 提取 Vrb 字符串
    length_Ib = length(leg_Vrb);    % 获取 Ib 总组数
    Index = zeros(length_Ib, 2);    % 左起始, 右终止
    for i = 1:length_Ib
        Index(i, 1) = find(  round(data(:, 6), 4) == leg_Vrb(i)  , 1, 'first' );
        % 找到第一个; 保留 4 位小数进行判断, 避免浮点不等
        Index(i, 2) = find(  round(data(:, 6), 4) == leg_Vrb(i)   , 1, 'last' );
        % 找到最后一个
    end
    
    % 挑选部分数据
    tv = size(Index, 1);
    tv = round(linspace(1, tv, 11));
    new_Index = Index(tv(1), 1):Index(tv(1), 2);
    for i = 2:length(tv)
        new_Index = [new_Index, Index(tv(i), 1):Index(tv(i), 2)];
    end
    data = data(new_Index, :);
end