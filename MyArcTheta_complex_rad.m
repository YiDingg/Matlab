function theta_rad = MyArcTheta_complex_rad(z)
% 输入复数，返回复数对应的角度
% 注：支持矩阵输入
    x = real(z);
    y = imag(z);
    theta_rad = MyArcTheta_rad(x, y);
end

