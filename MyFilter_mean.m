function data = MyFilter_mean(data, windowSize)
    data = movmean(data, windowSize);
end