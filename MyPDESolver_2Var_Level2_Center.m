function PdeProblem = MyPDESolver_2Var_Level2_Center(PdeProblem)
% PDE 求解器（二元，二阶，中心差分）u_0_y

% 若待求函数为 u = u(t,x)
% 方程：a*u + b_t*u_t + b_x*u_x + c_tt*u_tt + c_xx*u_xx = phi(t,x)
% 注：无法解决 u_tx 前系数不为零的方程
% 输入：PdeProblem 结构体
    % PdeProblem.N_t       ：t 轴单元数，步长为 x_end/N_t
    % PdeProblem.N_x       ：x 轴单元数，步长为 x_end/N_x

    % PdeProblem.t_beg     ：t 轴范围 [t_beg, t_end]
    % PdeProblem.t_end     ：t 轴范围 [t_beg, t_end]
    % PdeProblem.x_beg     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.x_end     ：x 轴范围 [x_beg, x_end]

    % PdeProblem.a         ：u 的系数
    % PdeProblem.b_t       ：u_t 的系数
    % PdeProblem.b_x       ：u_x 的系数
    % PdeProblem.c_tt      ：u_tt 的系数
    % PdeProblem.c_xx      ：u_xx 的系数
    % PdeProblem.PhiIsZero ：右侧函数是否为零，ture 或 false
    % PdeProblem.phi       ：右侧函数，@(t,x)

    % PdeProblem.u_xbeg_y  ：边界条件 @(y)
    % PdeProblem.u_xend_y  ：边界条件 @(y)
    % PdeProblem.u_x_ybeg  ：边界条件 @(x)
    % PdeProblem.u_x_yend  ：边界条件 @(x)
% 输出：
% 注：无法解决 u_xy 前系数不为零的方程

% 若待求函数为： u = u(x,y)
% 方程：a*u + b_x*u_x + b_y*u_y + c_xx*u_xx + c_yy*u_yy = phi(x,y)
% 输入：PdeProblem 结构体
    % PdeProblem.N_x       ：x 轴单元数，步长为 x_end/N_x
    % PdeProblem.N_y       ：y 轴单元数，步长为 y_end/N_y

    % PdeProblem.x_beg     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.x_end     ：x 轴范围 [x_beg, x_end]
    % PdeProblem.y_beg     ：y 轴范围 [y_beg, y_end]
    % PdeProblem.y_end     ：y 轴范围 [y_beg, y_end]

    % PdeProblem.a         ：u 的系数
    % PdeProblem.b_x       ：u_x 的系数
    % PdeProblem.b_y       ：u_y 的系数
    % PdeProblem.c_xx      ：u_xx 的系数
    % PdeProblem.c_yy      ：u_yy 的系数
    % PdeProblem.PhiIsZero ：右侧函数是否为零，ture 或 false
    % PdeProblem.phi       ：右侧函数，@(x,y)

    % PdeProblem.u_xbeg_y  ：边界条件 @(y)
    % PdeProblem.u_xend_y  ：边界条件 @(y)
    % PdeProblem.u_x_ybeg  ：边界条件 @(x)
    % PdeProblem.u_x_yend  ：边界条件 @(x)
% 输出：
% 注：无法解决 u_xy 前系数不为零的方程

tic

% 数据准备
    x_beg = PdeProblem.x_beg;
    x_end = PdeProblem.x_end;
    y_beg = PdeProblem.y_beg;
    y_end = PdeProblem.y_end;
    N_x = PdeProblem.N_x;
    N_y = PdeProblem.N_y;
    a = PdeProblem.a;
    b_x = PdeProblem.b_x;
    b_y = PdeProblem.b_y;
    c_xx = PdeProblem.c_xx;
    c_yy = PdeProblem.c_yy;
    phi = PdeProblem.phi;
    u_xbeg_y = PdeProblem.u_xbeg_y;
    u_xend_y = PdeProblem.u_xend_y;
    u_x_ybeg = PdeProblem.u_x_ybeg;
    u_x_yend = PdeProblem.u_x_yend;
    
    h_x = x_end/N_x;
    h_y = y_end/N_y;
     
    lam_m0 = -b_x/(2*h_x) + c_xx/h_x^2;         % lamda_{i-1, j}
    lam_0m = -b_y/(2*h_y) + c_yy/h_y^2;         % lamda_{i, j-1}
    lam_00 = a - 2*c_xx/h_x^2 - 2*c_yy/h_y^2;   % lamda_{i, j}
    lam_p0 = b_x/(2*h_x) + c_xx/h_x^2;          % lamda_{i, j+1}
    lam_0p = b_y/(2*h_y) + c_yy/h_y^2;          % lamda_{i+1, j}

    PdeProblem.X = linspace(x_beg, x_end, N_x+1);    % X 轴
    PdeProblem.Y = linspace(y_beg, y_end, N_y+1);
    X = PdeProblem.X;
    Y = PdeProblem.Y;    % Y 轴
% 矩阵初始化

    [GridX, GridY] = meshgrid(X,Y); 
    I_m = lam_m0*eye(N_y-1);
    I_p = lam_p0*eye(N_y-1);
    U = zeros((N_x-1)*(N_y-1), 1);     % 待求函数
    K = zeros((N_x-1)*(N_y-1), (N_x-1)*(N_y-1));      % 系数矩阵

    Phi = zeros((N_x-1)*(N_y-1), 1);
    phi_matrix = zeros(N_y+1,N_x+1);
    if ~PdeProblem.PhiIsZero
        phi_matrix = phi(GridX,GridY);
    end
    
    varphi_matrix = zeros(N_y-1, N_x-1);
    varphi_matrix(1, :) = -lam_0m*phi_matrix(1, 2:N_x); % 矩阵索引比网格索引多 1
    varphi_matrix(end, :) = -lam_0p*phi_matrix(N_y+1, 2:N_x); % 矩阵索引比网格索引多 1
    
    Result = zeros(N_y+1,N_x+1);
    Result(1,:) = u_x_ybeg(X);
    Result(end,:) = u_x_yend(X);
    Result(:,1) = u_xbeg_y(Y);
    Result(:,end) = u_xend_y(Y);
    % 平滑边缘突变
    Result(1,1) = 0.5*( u_x_ybeg(X(1)) +  u_xbeg_y(Y(1)));
    Result(1,end) = 0.5*( u_x_ybeg(X(end)) + u_xend_y(Y(1)) );
    Result(end, 1) = 0.5*( u_x_yend(X(1)) + u_xbeg_y(Y(end)) );
    Result(end, end) = 0.5*( u_x_yend(X(end)) + u_xend_y(Y(end)) );
% 赋入矩阵数据
    G = lam_00*eye((N_y-1)) ...
        + [
            zeros((N_y-1)-1, 1) , lam_0p*eye((N_y-1)-1);
            zeros(1,(N_y-1))
          ] ...
        + [
            zeros(1, (N_y-1));
            lam_0m*eye((N_y-1)-1), zeros((N_y-1)-1, 1);
          ];
    for i = 1: N_x-1
        K( (i-1)*(N_y-1)+1 : i*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = G;
    end
    for i = 1: N_x-2
        K( (i)*(N_y-1)+1 : (i+1)*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = I_m;
        K( (i-1)*(N_y-1)+1 : (i)*(N_y-1), (i)*(N_y-1)+1 : (i+1)*(N_y-1) ) = I_p;
    end
    % 第一项 \vec{\phi}
    for i = 1: N_x-1    
        Phi( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 ) = phi_matrix(2:N_y, i+1);   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end
    % 第二项 \vec{\varphi}
    for i = 1: N_x-1    
        Phi( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 ) = varphi_matrix(:, i) + Phi( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 );   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end
    % 第三项 \vec{u}_09
    Phi(1:(N_y-1), 1) = Phi(1:(N_y-1), 1) -lam_0m*u_xbeg_y(Y(2:N_y));
    % 第四项 \vec{u}_{N_x}
    Phi( (N_x-2)*(N_y-1)+1:(N_x-1)*(N_y-1), 1) = Phi( (N_x-2)*(N_y-1)+1:(N_x-1)*(N_y-1), 1) -lam_0m*u_xend_y(Y(2:N_y));


% 求解矩阵方程
    U = K\Phi;

% 展开结果
    for i = 1: N_x-1    
        Result(2:N_y, i+1) = U( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 );   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end

time = toc;

% 返回结果
    PdeProblem.Result = Result;
    disp("----------------------------------------------")
    disp("------- PDE 求解器（二元，二阶，中心差分）-------")
    disp(['用时：', num2str(time)])
    disp(['x 轴步长：', num2str(h_x)])
    disp(['y 轴步长：', num2str(h_y)])
    disp("PDE结构体：")
    disp(PdeProblem)
    disp("------- PDE 求解器（二元，二阶，中心差分）-------")
    disp("----------------------------------------------")
end