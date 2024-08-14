function [stc_GridSearch, stc_Figure] = MyGridSearch(stc_GridSearch, objective, ShowProcess)
% 输入网格搜索结构体，输出最优搜索结果（maximize）。
% 输入参数：
    % stc：网格搜索结构体
        % stc.Var：迭代参数信息
    % objective：目标函数
    % ShowProcess：过程监控层级
% 输出：搜索结果及进一步建议
% 注：迭代总次数为 1000 时，在 waitbar 上共耗时约 0.8 s 
%%    
% 步骤一：初始化
    if ShowProcess ~= 0
        Waitbar = waitbar(0, '1', 'Name', 'Grid Search', 'Color', [0.9, 0.9, 0.9]);
    end
    persent = 0;
    size_Var = size(stc_GridSearch.Var);
    num_Var = size_Var(1);
    stc_GridSearch.Var(:,3) = stc_GridSearch.Var(:,3) + 1;    % 点的数量比单元数多 1
    if num_Var == 1
        Objective = zeros(1, stc_GridSearch.Var(:,3));    % 解空间
    end
    if num_Var ~= 1
        Objective = zeros(stc_GridSearch.Var(:,3)');    % 解空间
    end
    disp("网格搜索初始化完毕，开始遍历解空间")

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


%                 if ShowProcess == 1
%                     %disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
%                     persent = 100*i/stc_GridSearch.Var(1,3);
%                     waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
%                 end
%                     if ShowProcess == 2
%                         %disp(['进度：',num2str(100*(i/stc_GridSearch.Var(1,3) + j/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)))),'%'])
%                         persent = 100*(i/stc_GridSearch.Var(1,3) + j/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)));
%                         waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
%                     end
%                         if ShowProcess == 3
%                             %disp(  ['进度：', num2str(  100*( i/stc_GridSearch.Var(1,3) + j/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)) + k/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)*stc_GridSearch.Var(3,3))  )  ),'%']  )
%                             waitbar((mytry)/N*100, Waitbar, ['Computing: ', ...
%                                 num2str(  100*( i/stc_GridSearch.Var(1,3) + j/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)) + k/(stc_GridSearch.Var(1,3)*stc_GridSearch.Var(2,3)*stc_GridSearch.Var(3,3))  )  ), ...
%                                 '%']);
%                             waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
%                         end

% 步骤三：求解目标函数
    start = tic;

    switch num_Var
        case 1
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            for i = 1:stc_GridSearch.Var(1,3)
                Objective(i) = objective(stc_GridSearch.X1(i));
                if ShowProcess ~= 0
                    %disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                    persent = 100*i/stc_GridSearch.Var(1,3);
                    waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
                end
            end
        case 2
            stc_GridSearch.X1 = linspace(stc_GridSearch.Var(1,1),stc_GridSearch.Var(1,2),stc_GridSearch.Var(1,3));
            stc_GridSearch.X2 = linspace(stc_GridSearch.Var(2,1),stc_GridSearch.Var(2,2),stc_GridSearch.Var(2,3));
            for i = 1:stc_GridSearch.Var(1,3)
                for j = 1:stc_GridSearch.Var(2,3)
                    Objective(i,j) = objective(stc_GridSearch.X1(i),stc_GridSearch.X2(j));

                end
                if ShowProcess ~= 0
                    %disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                    persent = 100*i/stc_GridSearch.Var(1,3);
                    waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
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
                if ShowProcess ~= 0
                    %disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                    persent = 100*i/stc_GridSearch.Var(1,3);
                    waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
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
                if ShowProcess ~= 0
                    %disp(['进度：',num2str(100*i/stc_GridSearch.Var(1,3)),'%'])
                    persent = 100*i/stc_GridSearch.Var(1,3);
                    waitbar(persent/100, Waitbar, ['Computing: ', num2str( round(persent, 2) ), '%']);
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
    stc_GridSearch.Object_best = obj_best;
    

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

% 第六步：输出结果
    % 进度条
        time = toc(start);
        if ShowProcess ~= 0
            waitbar(1, Waitbar, ['Grid Search Completed (in ', num2str(time),' s)']);
            Waitbar.Color = [1 1 1];
        end
        
    % 文本
        disp('---------------------------------')
        disp('>> --------  网格搜索  -------- <<')
        disp(['总计算次数：',num2str(prod(stc_GridSearch.Var(:,3)))])
        disp(['历时 ', num2str(time), ' 秒'])
        disp(['最优参数：', num2str(stc_GridSearch.X_best)])
        disp(['最优目标值：',num2str(stc_GridSearch.Object_best)])
        disp('>> --------  网格搜索  -------- <<')
        disp('---------------------------------')

    % 图像
        switch num_Var
        case 1
            stc_Figure = MyPlot(stc_GridSearch.X1,Objective);
            stc_Figure.axes.Title.String = ['Grid Search (in ', num2str(time),' s)'];
            stc_Figure.leg.String = 'par 1';
            stc_Figure.label.x.String = 'parameter';
            stc_Figure.label.y.String = 'objective';

        case 2
            stc_Figure = MyMesh(stc_GridSearch.X1, stc_GridSearch.X2, Objective', true);
            stc_Figure.label_left.x.String = 'par 1';
            stc_Figure.label_left.y.String = 'par 2';
            stc_Figure.label_left.z.String = 'objective';
            stc_Figure.label_right.x.String = 'par 1';
            stc_Figure.label_right.y.String = 'par 2';
            stc_Figure.label_right.z.String = 'objective';
            sgtitle(stc_Figure.fig, ['Grid Search (in ', num2str(time),' s)'])  
        end

% 第七步：导出数据
    writematrix([datestr(now, 'yyyy-mm-dd HH:MM:SS'), "Spend (s)", time, 'X_best', stc_GridSearch.X_best, 'Object_best', stc_GridSearch.Object_best], 'MyGridSearchResualts.xlsx', "WriteMode","append");
end
