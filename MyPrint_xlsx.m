function str = MyPrint_xlsx(data, digit)

    %str = cell(zeros(size(data)));
    % 遍历矩阵，将每个元素格式化为保留 digit 位小数的字符串  
    for i = 1:size(data, 1)  
        for j = 1:size(data, 2)  
            str{i, j} = num2str(data(i, j), ['%.', num2str(digit),'f']);  
        end  
    end  
    writecell(str, 'MyPrint_xlsx.xlsx', 'Sheet', 'Sheet1', 'WriteMode', 'replace'); % 输出位置
end