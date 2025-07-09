function fig = MyFigure_ChangeSize(size, hFig)
    % 打开指定的图窗
    if nargin <=1   % 未指定图窗
        hFig = gcf;
    end
    
    
    % 获取当前图窗的位置和大小
    figure(hFig);
    pos = get(hFig, 'Position');
    
    % 计算新的宽度和高度

    % 设置新的位置和大小
    set(hFig, 'Position', [pos(1), pos(2), size(1), size(2)]);
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