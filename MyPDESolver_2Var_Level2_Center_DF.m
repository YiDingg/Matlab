function PdeProblem = MyPDESolver_2Var_Level2_Center_DF(PdeProblem)
%% PDE 求解器：二元，DF格式（一阶导两点中心差分，二阶导四点中心差分），利用副初始条件显式求解结果
% 待求函数：u(x,y) 或 u(t,x)
% 注：仍有 bug 未修复
% issue 1: 理论上是无条件稳定格式，但 x 方向单元数必须远多于 y 方向单元数才能得到稳定解
% issue 2: 求解二维泊松方程时，求解结果完全相反

%% 设待求函数为： u = u(x,y)
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

    % PdeProblem.u_xbeg_y  ：初始条件函数 @(y)
    % PdeProblem.u_x_ybeg  ：边界条件函数 @(x)
    % PdeProblem.u_x_yend  ：边界条件函数 @(x)
% 输出：
% 注：无法解决 u_xy 前系数不为零的方程
%%
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
    
    lam_m0 = - b_x/(2*h_x) + c_xx/h_x^2 - c_yy/h_y^2;
    lam_0m = - b_y/(2*h_y) + c_yy/h_y^2 - c_xx/h_x^2;
    lam_00 = a ;
    lam_p0 = b_x/(2*h_x) + c_xx/h_x^2 - c_yy/h_y^2;
    lam_0p = b_y/(2*h_y) + c_yy/h_y^2 - c_xx/h_x^2;


%{
    lam_m0 = lam_m0/100;
    lam_0m = lam_0m/100;
    lam_00 = lam_00/100;
    lam_p0 = lam_p0/100;
    lam_0p = lam_0p/100; 
%}

    PdeProblem.X = linspace(x_beg, x_end, N_x+1);    % X 轴
    PdeProblem.Y = linspace(y_beg, y_end, N_y+1);
    X = PdeProblem.X;
    Y = PdeProblem.Y;    % Y 轴

% 矩阵初始化（横轴x向右，纵轴t向下，此时矩阵索引为 A(t,x)；或横轴y向右，纵轴x向下，此时矩阵索引为 A(x,y)）
    [GridX, GridY] = meshgrid(X, Y); 
    D_m0 = lam_m0*eye(N_y-1);
    D_p0 = lam_p0*eye(N_y-1);
    U = zeros((N_x-1)*(N_y-1), 1);     % 待求函数
    K = zeros((N_x-1)*(N_y-1), (N_x-1)*(N_y-1));      % 系数矩阵

    Phi = zeros((N_x-1)*(N_y-1), 1);
    phi_matrix = zeros(N_x+1, N_y+1);
    if ~PdeProblem.PhiIsZero
        phi_matrix = phi(GridX', GridY');
    end
    
    psi_matrix = zeros(N_y-1, N_x-1);
    psi_matrix(1, :) = - lam_0m * u_x_ybeg( X(2:N_x) ); % 矩阵索引比网格索引多 1
    psi_matrix(end, :) = - lam_0p * u_x_yend( X(2:N_x) ); % 矩阵索引比网格索引多 1
    
    Result = zeros(N_x+1, N_y+1);    
    % 先赋值 x 再赋值 y（先赋 t 后赋 x）
    Result(1,:)   = u_xbeg_y(Y);
    Result(:,1)   = u_x_ybeg(X);
    Result(:,end) = u_x_yend(X);
    % 平滑边缘突变
    %{
        Result(1,1) = 0.5*( u_x_ybeg(X(1)) +  u_xbeg_y(Y(1)));
        Result(1,end) = 0.5*( u_x_ybeg(X(end)) + u_xend_y(Y(1)) );
        Result(end, 1) = 0.5*( u_x_yend(X(1)) + u_xbeg_y(Y(end)) );
        Result(end, end) = 0.5*( u_x_yend(X(end)) + u_xend_y(Y(end)) ); 
    %}


% 求解第二初始条件 \vec{u}_1（仅针对一维热传导方程，采用四点显式求解）
    r = 0;
    % for j = 2:N_y
    %     Result(2,j) = (1-2*r)*Result(1,j) + r*( Result(1,j+1) + Result(1,j-1) );
    % end
    Result(2, 2:N_y) = (1-2*r)*Result(1, 2:N_y) + r*( Result(1, 3:(N_y+1)) + Result(1, 1:(N_y-1)) );

% 求解第二初始条件 \vec{u}_1（仅针对一维热传导方程，采用六点隐式求解）



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
        K( (i-1)*(N_y-1)+1 : i*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = D_p0;
    end
    for i = 1: N_x-2
        K( (i)*(N_y-1)+1 : (i+1)*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = G;
    end
    for i = 1: N_x-3
        K( (i+1)*(N_y-1)+1 : (i+2)*(N_y-1), (i-1)*(N_y-1)+1 : i*(N_y-1) ) = D_m0;
    end
    % 第一、二项 \vec{\phi} + \vec{\psi}
        for i = 1: N_x-1    
            Phi( (i-1)*(N_y-1)+1 : i*(N_y-1), 1 ) = phi_matrix(i+1, 2:N_y)' + psi_matrix(:, i);   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
        end
    % 第三项 \vec{u}_0 和 \vec{u}_1
        Phi(1:(N_y-1)*2, 1) = Phi(1:(N_y-1)*2, 1) + [ D_m0*Result(1,2:N_y)' + G*Result(2,2:N_y)'; D_m0*Result(2,2:N_y)'];

% 求解矩阵方程
    U = K\Phi;

% 展开结果
    for i = 3: N_x+1    
        Result(i, 2:N_y) = U( (i-3)*(N_y-1)+1 : (i-2)*(N_y-1), 1 );   % 网格索引 0 ~ N，矩阵索引 1 ~ N+1
    end

time = toc;

% 返回结果
    PdeProblem.Result = Result;
    disp("----------------------------------------------------------------------")
    disp("---- PDE 求解器：二元，DF格式（一阶导两点中心差分，二阶导四点中心差分）----")
    disp(['用时：', num2str(time)])
    disp(['x 轴单元数：', num2str(N_x), ', x 轴步长：', num2str(h_x)])
    disp(['y 轴单元数：', num2str(N_y), ', y 轴步长：', num2str(h_y)])
    disp("---- PDE 求解器：二元，DF格式（一阶导两点中心差分，二阶导四点中心差分）----")
    disp("----------------------------------------------------------------------")
end