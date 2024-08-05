function [stc_SA, stc_Figure] = MySimulatedAnnealing(stc_SA, objective)
% 输入退火问题结构体，输出迭代结果（maximize）。
% 
% 输入：
    % stc：退火问题结构体
    % objective：目标函数
% 输出：迭代结果

    % 步骤一：初始化
        TK = stc_SA.Annealing.T0;
        t0 = stc_SA.Annealing.t0;
        mkv = stc_SA.Annealing.mkvlength;
        a = stc_SA.Annealing.a;
        num_Var = size(stc_SA.Var.range(:,3));
        num_Var = num_Var(1);
        %lam = stc.Annealing.lam;
        % 迭代记录仪初始化
        change_1 = 0;    % 随机到更优解的次数
        change_2 = 0;    % 接收较差解的次数（两者约 10:1 时有较好寻优效果）
        mytry = 1;       % 当前迭代次数
        N = mkv*ceil(log(t0/TK)/log(a));   % 迭代总次数
        X = stc_SA.Var.range(:,3)';
        X_best = stc_SA.Var.range(:,3)';
        f_best = objective(X); % 计算目标函数
        process = zeros(1, floor(N));
        process(1) = f_best;
        process_best = zeros(1, floor(N));
        process_best(1) = f_best;
        

    % 步骤二：退火
        disp("初始化完成，开始退火")
        disp(['initial obj: ',num2str(f_best)])
        start = tic; % 开始计时
        while TK >= t0   
            for i = 1:mkv  % 每个温度T下，我们都寻找 mkv 次新解 X，每一个新解都有可能被接受

                r = rand;
                if r>=0.5 % 在当前较优解附近扰动
                    for j = 1:num_Var
                            X(j) = X_best(j)+(rand-0.5)*(stc_SA.Var.range(j,2) - stc_SA.Var.range(j,1))*( 1-(mytry-1)/N )^2;
                            X(j) = max(stc_SA.Var.range(j,1), min(X(j), stc_SA.Var.range(j,2)));   % 确保扰动后的 X 仍在范围内
                    end
                else % 生成全局随机解
                    X = (stc_SA.Var.range(:,1) + rand*(stc_SA.Var.range(:,2) - stc_SA.Var.range(:,1)))';  % 转置后才是行向量   
                end

                mytry = mytry+1;
                f = objective(X); % 计算目标函数

                if f > f_best   % 随机到更优解，接受新解
                   f_best = f;
                   X_best = X;
                   change_1 = change_1+1;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    new obj: ',num2str(f_best)])
                elseif exp( - 10^7*(f_best-f)/(TK*abs(f_best))  ) > rand  % 满足概率，接受较差解
                   f_best = f;
                   X_best = X;
                   % disp(['较优参数为：',num2str(X_best)])
                   disp(['    new obj: ',num2str(f_best)])
                   change_2 = change_2 + 1;
                end

                process(mytry) = f;
                process_best(mytry) = f_best;
            end
            disp(['进度：',num2str((mytry)/N*100),'%'])
            TK = TK*a;
        end

    % 步骤三：退火结束，输出最终结果
        % 图像
            stc_SA.process = process;
            stc_SA.process_best = process_best;
            stc_SA.X_best = X_best;
            stc_SA.Object_best = f_best;

            time = toc(start);
            stc_Figure = MyYYPlot(1:length(process), process, 1:length(process), process_best);
            stc_Figure.axes.Title.String = ['Simulated Annealing (in ', num2str(time),' s)'];
            stc_Figure.leg.String = ["Current objective value";"Best objective value"];
            stc_Figure.p_left.LineWidth = 1.6;
            stc_Figure.p_right.LineWidth = 1.6;
            stc_Figure.label.x.String = 'times';
            stc_Figure.label.y_left.String = '$obj_{\mathrm{current}}$';
            stc_Figure.label.y_right.String = '$obj_{\mathrm{best}}$';

        % 文本
            disp('---------------------------------')
            disp('>> --------  模拟退火  -------- <<')
            toc(start)
            disp(['一共寻找新解：',num2str(mytry)])
            disp(['change_1次数：',num2str(change_1)])
            disp(['change_2次数：',num2str(change_2)])
            disp(['最优参数：', num2str(X_best)])
            disp(['最优目标值：', num2str(f_best)])
            disp('>> --------  模拟退火  -------- <<')
            disp('---------------------------------')

        % 导出数据
            writematrix([stc_SA.X_best, stc_SA.Object_best, time], 'SAResualt.xlsx', "WriteMode","append");
end
