function theta_deg = MyArcTheta_deg(x, y)
%输入(x, y) 或 (cos theta, sin theta)，返回角度值 theta, 范围 [0, 360)
% 注：支持矩阵输入
%%
    theta_rad = MyArcTheta_rad(x, y);
    theta_deg = theta_rad/pi*180;
end

