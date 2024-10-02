function stc_error = MyErrorAnalyzer_continuous(f, f_hat, X_range)
%%
% Refer to https://yidingg.github.io/YiDingg/#/Notes/Else/GoodnessOfFit for
% more details.
%%
    % SAAE, Standard Absolute Area Error, 标准绝对面积误差
    stc_error.SAAE = integral( @(x) abs(f(x) - f_hat(x)), X_range(1), X_range(2) ) / integral( @(x) abs(f(x)), X_range(1), X_range(2) );
    disp(['SAAE = ', num2str(stc_error.SAAE, '%.10f')]);
end