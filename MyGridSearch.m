function [stc_GridSearch, stc_Figure] = MyGridSearch(stc_GridSearch, objective, ShowProcess)
% 输入网格搜索结构体，输出最优搜索结果（maximize）。
% 输入参数：
    % stc：网格搜索结构体
        % stc.Var：迭代参数信息
            % stc.Var：m*3 矩阵（m<=3），每一行为一个参数范围和单元数
                % 例如：
                % stc.Var = [
                % 0 1 100
                % 10 100 300
                % ]
    % objective：目标函数
    % ArrayInput：目标函数是否支持数组输入
% 输出：搜索结果及进一步建议
    
    % 步骤一：初始化
    size_Var = size(stc_GridSearch.Var);
    num_Var = size_Var(1);
    stc_GridSearch.Var(:,3) = stc_GridSearch.Var(:,3) + 1;    % 点的数量比单元数多 1
    if num_Var == 1
        Objective = zeros(1, stc_GridSearch.Var(:,3));    % 解空间
    end
    if num_Var ~= 1
        Objective = zeros(stc_GridSearch.Var(:,3)');    % 解空间
    end

    % 步骤二：预估时间
%     test = tic;
%     switch num_Var
%         case 1
%                 stc.X1 = linspace(stc.Var(1,1),stc.Var(1,2),3);
%                 for i = 1:3
%                     Objective(i) = objective(stc.X1(i));
%                 end
%         case 2
%         case 3
%         case 4
%         otherwise
%             disp("非法参数个数!")
%             return
%     end
% 
%     time_pre = toc(test);
%     time_pre = time_pre*prod(stc.Var(:,3)./3);
%     disp(['预估时间：',num2str(time_pre),' s = ',num2str(time_pre/60),' min'])

    % 步骤三：求解目标函数
    time = tic;
    switch num_Var
        case 1
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            for i = 1:stc_GridSearch.Var(1,3)
                Objective(i) = objective(stc_GridSearch.X1(i));
            end
        case 2
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            stc_GridSearch.X2 = linspace(stc_GridSearch.Var(2,1),stc_GridSearch.Var(2,2),stc_GridSearch.Var(2,3));
            for i = 1:stc_GridSearch.Var(1,3)
                for j = 1:stc_GridSearch.Var(2,3)
                    Objective(i,j) = objective(stc_GridSearch.X1(i),stc_GridSearch.X2(j));
                end
                if ShowProcess
                    disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                end
            end
        case 3
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            stc_GridSearch.X2 = linspace(stc_GridSearch.Var(2,1),stc_GridSearch.Var(2,2),stc_GridSearch.Var(2,3));
            stc_GridSearch.X3 = linspace(stc_GridSearch.Var(3,1),stc_GridSearch.Var(3,2),stc_GridSearch.Var(3,3));
            for i = 1:stc_GridSearch.Var(1,3)
                for j = 1:stc_GridSearch.Var(2,3)
                    for k = 1:stc_GridSearch.Var(3,3)
                        Objective(i,j,k) = objective(stc_GridSearch.X1(i),stc_GridSearch.X2(j),stc_GridSearch.X3(k));
                    end
                end
                if ShowProcess
                    disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                end
            end
        case 4
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            stc_GridSearch.X2 = linspace(stc_GridSearch.Var(2,1),stc_GridSearch.Var(2,2),stc_GridSearch.Var(2,3));
            stc_GridSearch.X3 = linspace(stc_GridSearch.Var(3,1),stc_GridSearch.Var(3,2),stc_GridSearch.Var(3,3));
            stc_GridSearch.X4 = linspace(stc_GridSearch.Var(4,1),stc_GridSearch.Var(4,2),stc_GridSearch.Var(4,3));
            for i = 1:stc_GridSearch.Var(1,3)
                for j = 1:stc_GridSearch.Var(2,3)
                    for k = 1:stc_GridSearch.Var(3,3)
                        for l = 1:stc_GridSearch.Var(4,3)
                            Objective(i,j,k,l) = objective(stc_GridSearch.X1(i),stc_GridSearch.X2(j),stc_GridSearch.X3(k),stc_GridSearch.X4(l));
                        end
                    end
                end
                if ShowProcess
                    disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                end
            end
    end

    % 第四步：提取最优解
    [obj_best, index_best] = max(Objective,[],'all');
    switch num_Var
        case 1
            Index_best = index_best;
            stc_GridSearch.X_best = stc_GridSearch.X1(index_best);
        case 2
            Index_best = [mod(index_best-1,stc_GridSearch.Var(1,3)) + 1, floor(index_best/stc_GridSearch.Var(1,3))];
            stc_GridSearch.X_best(1) = stc_GridSearch.X1(Index_best(1));
            stc_GridSearch.X_best(2) = stc_GridSearch.X2(Index_best(2));
        case 3
            Index_best(1) = mod(index_best-1,stc_GridSearch.Var(1,3)); 
            Index_best(3) = floor( index_best/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)) );
            Index_best(2) = ( mod(index_best,stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)) - Index_best(1) - 1 )  /  stc_GridSearch.Var(1,3);
            Index_best = Index_best + 1;
            stc_GridSearch.X_best(1) = stc_GridSearch.X1(Index_best(1));
            stc_GridSearch.X_best(2) = stc_GridSearch.X2(Index_best(2));
            stc_GridSearch.X_best(3) = stc_GridSearch.X3(Index_best(3));
        case 4
            Index_best(4) = floor( index_best/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)*stc_GridSearch.Var(3,3)) );
            Index_best(3) = floor(  ( index_best - Index_best(4)*(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)*stc_GridSearch.Var(3,3)) ) / (stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3))  );
            Index_best(2) = floor(  ( index_best - Index_best(4)*(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)*stc_GridSearch.Var(3,3)) - Index_best(3)*(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)) ) / stc_GridSearch.Var(1,3)  );
            Index_best(1) = mod(index_best-1,stc_GridSearch.Var(1,3)); 
            Index_best = Index_best + 1;
            stc_GridSearch.X_best(1) = stc_GridSearch.X1(Index_best(1));
            stc_GridSearch.X_best(2) = stc_GridSearch.X2(Index_best(2));
            stc_GridSearch.X_best(3) = stc_GridSearch.X3(Index_best(3));
            stc_GridSearch.X_best(4) = stc_GridSearch.X3(Index_best(4));
    end
    stc_GridSearch.Index_best = Index_best;
    stc_GridSearch.obj_best = obj_best;
    

%     % 第五步：进一步建议
%     [obj_advice, index_advice] = maxk(Objective,3)
%     switch num_Var
%         case 1
%             Index_best = index_best;
%             stc.X_best = stc.X1(index_best);
%         case 2
%             Index_best = [mod(index_best-1,stc.Var(1,3)) + 1, floor(index_best/stc.Var(1,3))];
%             stc.X_best(1) = stc.X1(Index_best(1));
%             stc.X_best(2) = stc.X2(Index_best(2));
%         case 3
%             Index_best(1) = mod(index_best-1,stc.Var(1,3)); 
%             Index_best(3) = floor( index_best/(stc.Var(1,3)*stc.Var(2,3)) );
%             Index_best(2) = ( mod(index_best,stc.Var(1,3)*stc.Var(2,3)) - Index_best(1) - 1 )  /  stc.Var(1,3);
%             Index_best = Index_best + 1;
%             stc.X_best(1) = stc.X1(Index_best(1));
%             stc.X_best(2) = stc.X2(Index_best(2));
%             stc.X_best(3) = stc.X3(Index_best(3));
%         case 4
%             Index_best(4) = floor( index_best/(stc.Var(1,3)*stc.Var(2,3)*stc.Var(3,3)) );
%             Index_best(3) = floor(  ( index_best - Index_best(4)*(stc.Var(1,3)*stc.Var(2,3)*stc.Var(3,3)) ) / (stc.Var(1,3)*stc.Var(2,3))  );
%             Index_best(2) = floor(  ( index_best - Index_best(4)*(stc.Var(1,3)*stc.Var(2,3)*stc.Var(3,3)) - Index_best(3)*(stc.Var(1,3)*stc.Var(2,3)) ) / stc.Var(1,3)  );
%             Index_best(1) = mod(index_best-1,stc.Var(1,3)); 
%             Index_best = Index_best + 1;
%             stc.X_best(1) = stc.X1(Index_best(1));
%             stc.X_best(2) = stc.X2(Index_best(2));
%             stc.X_best(3) = stc.X3(Index_best(3));
%             stc.X_best(4) = stc.X3(Index_best(4));
%     end
%     stc.Index_best = Index_best;
%     stc.obj_best = obj_best;

    % 输出结果

    disp('---------------------------------')
    disp('>> --------  网格搜索  -------- <<')
    disp(['总计算次数：',num2str(prod(stc_GridSearch.Var(:,3)))])
    toc(time)
    disp(['最优参数：', num2str(stc_GridSearch.X_best)])
    disp(['最优目标值：',num2str(obj_best)])
    disp('>> --------  网格搜索  -------- <<')
    disp('---------------------------------')

    switch num_Var
        case 1
            stc_Figure = MyPlot(stc_GridSearch.X1,Objective,['parameter';'objective']);
            legend(stc_Figure.axes, "par 1");
            title(stc_Figure.axes, '网格搜索结果','FontSize',13,'FontWeight','bold')
        case 2
            stc_Figure = MyMesh(stc_GridSearch.X1, stc_GridSearch.X2, Objective', true);
            xlabel(stc_Figure.p1, "par 1");
            ylabel(stc_Figure.p1, "par 2");
            zlabel(stc_Figure.p1, "objective")
            xlabel(stc_Figure.p2, "par 1");
            ylabel(stc_Figure.p2, "par 2");
            zlabel(stc_Figure.p2, "objective")
            sgtitle(stc_Figure.fig, '网格搜索结果','FontSize',13,'FontWeight','bold')
    end
end
