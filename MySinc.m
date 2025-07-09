function re = MySinc(a)
    re = (sin(a)./a);
    re(isnan(re)) = 1;
end