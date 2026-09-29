function res = imhistmatch_(img, ref)
    sourceHistogram = image_histogram(img);
    referenceHistogram = image_histogram(ref);
    sourceChannels = size(sourceHistogram, 2);
    referenceChannels = size(referenceHistogram, 2);
    res = zeros(size(img));
    sourcePixels = size(img, 1) * size(img, 2);
    referencePixels = size(ref, 1) * size(ref, 2);

    for channel = 1:sourceChannels
        referenceChannel = min(channel, referenceChannels);
        sourceCdf = cumsum(sourceHistogram(:, channel)) / sourcePixels;
        referenceCdf = cumsum(referenceHistogram(:, referenceChannel)) / referencePixels;
        lut = zeros(256, 1);
        for value = 1:256
            match = find(referenceCdf >= sourceCdf(value) - 1e-12, 1);
            if isempty(match)
                match = 256;
            end
            lut(value) = match - 1;
        end

        if sourceChannels == 1
            values = round(min(255, max(0, double(img))));
            res = lut(values + 1);
        else
            values = round(min(255, max(0, double(img(:, :, channel)))));
            res(:, :, channel) = lut(values + 1);
        end
    end
end
