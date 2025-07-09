function fig = MyFigure_ChangeSize_2048x512(hFig)
    if nargin == 0   % 没有输入任何参数
        hFig = gcf;
    else
        % 打开指定的图窗
        figure(hFig);
    end

    % 获取当前图窗的位置和大小
    pos = get(hFig, 'Position');
    
    % 计算新的宽度和高度
    newWidth = 2048;  % 设置宽度
    newHeight = 512;  % 设置高度
    
    % 设置新的位置和大小
    set(hFig, 'Position', [pos(1), pos(2), newWidth, newHeight]);
    % 获取屏幕尺寸
    screenSize = get(0, 'ScreenSize');
    % 获取图窗的当前大小
    figPos = get(hFig, 'Position');
    % 计算图窗的左上角位置，使其居中
    left = (screenSize(3) - figPos(3)) / 2;
    bottom = (screenSize(4) - figPos(4)) / 2;
    
    % 设置图窗的位置
    set(hFig, 'Position', [left, bottom, figPos(3), figPos(4)]);

end