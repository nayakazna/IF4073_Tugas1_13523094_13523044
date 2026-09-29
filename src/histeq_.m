function res = histeq_(img)
    h = image_histogram(img);
    res = zeros(size(img));
    channelCount = size(h, 2);
    pixelCount = size(img, 1) * size(img, 2);

    for channel = 1:channelCount
        if channelCount == 1
            values = round(min(255, max(0, double(img))));
        else
            values = round(min(255, max(0, double(img(:, :, channel)))));
        end

        cdf = cumsum(h(:, channel));
        cdfMin = cdf(find(cdf > 0, 1));
        if isempty(cdfMin) || cdfMin == pixelCount
            equalized = values;
        else
            lut = round((cdf - cdfMin) / (pixelCount - cdfMin) * 255);
            lut = min(255, max(0, lut));
            equalized = lut(values + 1);
        end

        if channelCount == 1
            res = equalized;
        else
            res(:, :, channel) = equalized;
        end
    end
end
