function Index = MyArrayProcessor_findLocalMinimum(A)
    % 假设A是我们的行向量
    % 计算相邻元素的差分
    dA = diff(A);
    % 找到差分从负到正的索引，这些位置的元素可能是极小值
    potentialMinimaIndices = find(dA(1:end-1) < 0 & dA(2:end) > 0) + 1;
    % 由于差分操作会减少一个元素，所以需要对索引进行调整
    %potentialMinimaIndices = [1, potentialMinimaIndices, length(A)];
    % 获取潜在极小值
    %potentialMinima = A(potentialMinimaIndices);
    % 过滤掉不是极小值的点（例如，向量的两端如果不是极小值则排除）
    %actualMinimaIndices = potentialMinimaIndices(2:end-1);
    %actualMinima = A(actualMinimaIndices);

    % 输出结果
    %disp(['极小值的索引：', num2str(actualMinimaIndices)]);
    %disp('极小值：');
    %disp(actualMinima);
    Index = potentialMinimaIndices;
end