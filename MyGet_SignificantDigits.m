function x_ = MyGet_SignificantDigits(x, n)
    x_ = round(x ./ 10.^floor(log10(abs(x))), n - 1) .* 10.^floor(log10(abs(x)));
end