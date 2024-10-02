function color = GetMyColors
color = num2cell( ...
        [
        "#9999ff" "#0000ff" "#000099" "#000019"
        "#ff99ff" "#ff00ff" "#990099" "#190019"
        "#ff9999" "#ff0000" "#990000" "#190000"
        "#99ff99" "#00ff00" "#009900" "#001900"
        "#ffff99" "#ffff00" "#999900" "#191900"
        "#99ffff" "#00ffff" "#009999" "#001919"
        "#ffffff" "#bbbbbb" "#999999" "#191919"
        ]' ...  % 这里的转置是必要的, 为了使 MyColors{i} 能先遍历第一行再进入下一行
    );
end