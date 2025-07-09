function stc = MyAnalysis_TransferFunction_Dominant_Pole_Approximation(H_s)
disp('------------  MyAnalysis_TransferFunction_Dominant_Pole_Approximation  ------------')
disp(' ')

    % 输入一个分子 <= 1 阶, 分母 = 2 阶的传递函数
    stc = MyAnalysis_TransferFunction(H_s, 0);
    if stc.deno_order == 2
        % 提取分母标准表达式 a*s^2 + b*s + 1 的系数 a, b
        co = stc.deno_coefficients_standard;  % 注意 co 是 s^0, s^1, s^2, ...
        stc.Dominant_p1 = simplify(- 1/co(2), 'Steps', 20);
        stc.Dominant_p2 = simplify(- co(2)/co(1), 'Steps', 20);
    else
        disp('传递函数分母阶数错误, 请检查 !')
        %stc.nume_coefficients
        %stc.deno_coefficients
        return
    end

    disp('Dominant p1 = ')
    stc.Dominant_p1
    disp('Dominant p2 = ')
    stc.Dominant_p2

disp(' ')
disp('------------------------------------------------------------------------------------')
%disp('------------  MyAnalysis_TransferFunction_Dominant_Pole_Approximation  ------------')
end