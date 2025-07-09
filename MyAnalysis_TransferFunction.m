function stc = MyAnalysis_TransferFunction(H_s, displayresults)



% 输入分子分母为任意阶的传递函数 H(s)
    if nargin < 2 || displayresults == 1
        flag_displayresults = 1;
    else
        flag_displayresults = 0;
    end

if displayresults
    disp('------------  MyAnalysis_TransferFunction  ------------')
    disp(' ')
end

% 初始化
    flag_nume_zeros = 0;
    flag_deno_poles = 0;


% 提取基本参数
    syms s
    [stc.nume, stc.deno] = numden(H_s); % 提取分子 numerator 和分母 denominator
    [nume_coefficients, nume_components] = coeffs(stc.nume, s);
    [deno_coefficients, deno_components] = coeffs(stc.deno, s);
    stc.nume_coefficients = transpose([nume_coefficients; nume_components]);
    stc.deno_coefficients = transpose([deno_coefficients; deno_components]);
    stc.nume_order = size(stc.nume_coefficients, 1) - 1;
    stc.deno_order = size(stc.deno_coefficients, 1) - 1;

% 获取标准表达式 H(s) = H_0 * ...
    stc.H_0 = simplify(stc.nume_coefficients(end, 1) / stc.deno_coefficients(end, 1));
    stc.nume_standard = simplify(stc.nume/stc.nume_coefficients(end, 1), "Steps", 10);
    stc.deno_standard = simplify(stc.deno/stc.deno_coefficients(end, 1), "Steps", 10);
    [stc.nume_coefficients_standard, ~] = coeffs(stc.nume_standard, s);  % 注意只返回一个参数时是 s^0, s^1, ..., 返回两个参数才是 s^n, ..., s^0
    [stc.deno_coefficients_standard, ~] = coeffs(stc.deno_standard, s);
    tv = sym2cell([stc.H_0, stc.nume_standard/stc.deno_standard]);
    stc.standard_expression = cell2sym(tv);

% 求解零极点
    % 零点
    if stc.nume_order <= 2
        if displayresults 
            disp(['nume_order = ', num2str(stc.nume_order), ', 已求解零点表达式'])
        end
        stc.nume_zeros = solve(stc.nume, s);
        flag_nume_zeros = 1;
    else
        disp(['nume_order = ', num2str(stc.nume_order), ' > 2, 未求解零点表达式'])
    end
    % 极点
    if stc.deno_order <= 2
        if displayresults 
            disp(['deno_order = ', num2str(stc.deno_order), ', 已求解极点表达式'])
        end
        stc.deno_poles = solve(stc.deno, s);
        flag_deno_poles = 1;
    else
        disp(['deno_order = ', num2str(stc.deno_order), ' > 2, 未求解极点表达式'])
    end

% dominant-pole approximation
% p_1 = - C/B, p_2 = - B/A
stc.dominantPoleAppro.p1 = - stc.deno_coefficients(3, 1)/stc.deno_coefficients(2, 1);
stc.dominantPoleAppro.p2 = - stc.deno_coefficients(2, 1)/stc.deno_coefficients(1, 1);

    

% 展示结果
    if flag_displayresults
        disp('H_0 =')
        disp(stc.H_0)
        disp('标准表达式 standard_expression = ')
        disp(stc.standard_expression);
        disp('分子系数 nume_coefficients = ')
        disp(stc.nume_coefficients)
        disp('分母系数 deno_coefficients = ')
        disp(stc.deno_coefficients)
        if flag_nume_zeros == 1
            disp('零点表达式: ')
            disp(stc.nume_zeros)
        end
        if flag_deno_poles == 1
            disp('p_1 ≈ - C/B = ')
            disp(stc.dominantPoleAppro.p1)
            disp('p_2 ≈ - B/A = ')
            disp(stc.dominantPoleAppro.p2)
            disp('极点表达式: ')
            disp(stc.deno_poles)
        end
    end



if displayresults
    disp(' ')
    disp('-------------------------------------------------------')
    %disp('------------  MyAnalysis_TransferFunction  ------------')
end

end


