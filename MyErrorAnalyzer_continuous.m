function stc_error = MyErrorAnalyzer_continuous(f, f_hat, X_range)
    % 标准面积误差  AE_standard (SAE)
    stc_error.SAAE_standard = integral( @(x) abs(f(x) - f_hat(x)), X_range(1), X_range(2) ) / integral( @(x) abs(f(x)), X_range(1), X_range(2) );
    disp(['AE_standard = ', num2str(stc_error.SAAE_standard, '%.10f')]);
end