function stc = MySimulatedAnnealing(stc, objective)
% 输入退火问题结构体，输出迭代结果。
% 输入参数：
    % stc：退火问题结构体
        % stc.Var：迭代参数信息
            % stc.Var.num：迭代参数个数
            % stc.Var.var1range：参数 1 的范围
            % stc.Var.var2range：参数 2 的范围
            % ...
        % stc.Init：迭代参数初始值
        % stc.Annealing：退火参数
            % stc.Annealing.T0 = 100;        % 初始温度
            % stc.Annealing.a = 0.97;        % 降温系数
            % stc.Annealing.t0 = 1;         % 停止温度
            % stc.Annealing.mkvlength = 1;   % 马尔科夫链长度
% 输出：迭代结果

    % 步骤一：初始化
        TK = stc.Annealing.T0;
        t0 = stc.Annealing.t0;
        mkv = stc.Annealing.mkvlength;
        a = stc.Annealing.a;
        lam = stc.Annealing.lam;
        f_best = 0;
        change_1 = 0;    % 随机到更优解的次数
        change_2 = 0;    % 接收较差解的次数（两者约 10:1 时有较好寻优效果）
        mytry = 0;       % 当前迭代次数
        N = mkv*log(t0/TK)/log(a);   % 迭代总次数
        X = zeros(1, stc.Var.num); 
        % 迭代记录仪初始化
        X_best = zeros(1, stc.Var.num); 
        process = zeros(1, floor(N));
        process_change = zeros(1, floor(N));
        

    % 步骤二：退火
        disp("初始化完成，开始退火")
        tic; % 开始计时
        while TK >= t0   
            for i = 1:mkv  % 每个温度T下，我们都寻找 mkv 次新解 X，每一个新解都有可能被接受
                r = rand;
                if r>=0.5 % 在当前较优解附近扰动
                    for j = 1:stc.Var.num
                        X(j) = X_best(j)+(rand-0.5)*(stc.Var.range(:,2) - stc.Var.range(:,1));
                        X(j) = max(stc.Var.range(j,1), min(X(j), stc.Var.range(j,2)));   % 确保扰动后的 X 仍在范围内
                    end
                else % 生成全局随机解
                    X = rand*(stc.Var.range(:,2) - stc.Var.range(:,1))';  % 转置后才是行向量   
                end
                f = objective(X); % 计算目标函数
                mytry = mytry+1;
                if f > f_best   % 随机到更优解，接受新解
                   f_best = f;
                   X_best = X;
                   change_1 = change_1+1;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                elseif exp((f-f_best)/(lam*TK)) > rand  % 满足概率，接受较差解
                   f_best = f;
                   X_best = X;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    新目标值：',num2str(f_best)])
                   change_2 = change_2 + 1;
                end
                process(mytry) = f;
                process_change(mytry) = f_best;
            end
            disp(['当前进度:',num2str((mytry-1)/N*100),'%'])
            TK = TK*a;
        end
        time = toc; % 结束计时

    % 步骤三：退火结束，输出最终结果
        stc.process = process;
        stc.process_change = process_change;
        MyPlot(1:length(process),[process; process_change], ["times"; "objective"])
        disp('---------------------------------')
        disp(['此次退火用时(s)：',num2str(time)])
        disp(['一共寻找新解：',num2str(mytry)])
        disp(['change_1次数：',num2str(change_1)])
        disp(['change_2次数：',num2str(change_2)])
        disp('最优参数为：')
        disp(num2str(X_best))
        disp(['此参数下的目标函数值：',num2str(f_best)])
        disp('---------------------------------')
end
