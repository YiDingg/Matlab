function theta_deg = MyArcTheta_complex_deg(z)
% 输入复数，返回复数对应的角度
% 注：支持矩阵输入
    x = real(z);
    y = imag(z);
    theta_deg = MyArcTheta_deg(x, y);
end

