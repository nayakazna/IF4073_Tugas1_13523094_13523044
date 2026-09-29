function h = image_histogram(img)
%IMAGE_HISTOGRAM Return 256-bin histograms for grayscale or RGB images.
    if ~isnumeric(img) || ~(ndims(img) == 2 || ndims(img) == 3)
        error('image_histogram:InvalidImage', 'Gambar harus 2-D grayscale atau 3-D RGB numeric array.');
    end

    channelCount = 1;
    if ndims(img) == 3
        channelCount = size(img, 3);
        if channelCount ~= 3
            error('image_histogram:InvalidChannels', 'Citra berwarna hraus mempunyai 3 saluran.');
        end
    end

    h = zeros(256, channelCount);
    for channel = 1:channelCount
        if channelCount == 1
            values = img;
        else
            values = img(:, :, channel);
        end
        values = round(min(255, max(0, double(values))));
        h(:, channel) = accumarray(values(:) + 1, 1, [256 1], @sum, 0);
    end
end
