function rgbColor = MyColors2rgb(hexColor)
    %hexColor = cell(hexColor);
    rgbColor = sscanf(hexColor, '#%2x%2x%2x', [1,3])/255;
end