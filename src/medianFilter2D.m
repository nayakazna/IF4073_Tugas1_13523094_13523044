function out = medianFilter2D(img, windowSize)
    validateattributes(windowSize, {'numeric'}, {'scalar', 'integer', 'positive'});
    if mod(windowSize, 2) == 0
        error('medianFilter2D:InvalidSize', 'ukuran jendlea harus ganjil.');
    end

    img = double(img);
    out = zeros(size(img));
    radius = floor(windowSize / 2);
    rowIndices = min(max((1 - radius):(size(img, 1) + radius), 1), size(img, 1));
    columnIndices = min(max((1 - radius):(size(img, 2) + radius), 1), size(img, 2));
    padded = img(rowIndices, columnIndices);

    for row = 1:size(img, 1)
        for column = 1:size(img, 2)
            neighborhood = padded(row:(row + 2 * radius), column:(column + 2 * radius));
            out(row, column) = median(neighborhood(:));
        end
    end
end
