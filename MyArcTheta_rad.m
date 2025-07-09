function theta_rad = MyArcTheta_rad(x, y)
%输入(x, y) 或 (cos theta, sin theta)，返回角度值 theta, 范围 [0, 2*pi)
% 注：支持矩阵输入
%%
    % 用 arctan 只能较方便地得到 [-pi/2, 3*pi/2), 我们选用 arccos
    %theta = mod((x>=0) .* atan(y./x) + (x<0) .* (atan(y./x) + pi) + 2*pi, 2*pi);
    cos_theta = x./sqrt(x.^2 + y.^2);
    theta_rad = (y >= 0) .* acos(cos_theta) + (y < 0) .* ( 2*pi - acos(cos_theta));
end

