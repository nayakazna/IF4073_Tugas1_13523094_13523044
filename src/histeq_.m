function res = histeq_(img)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    h = image_histogram(img);
    N = size(img, 1) * size(img, 2);
    res = zeros(size(img), 'uint8');

    for k = 1:3
        cdf = cumsum(h(:, k));
        cdf_min = cdf(find(cdf > 0, 1));

        if cdf_min == N
            res(:,:,k) = img(:,:,k);
            continue;
        end
        lut = round((cdf - cdf_min) / (N - cdf_min) * 255);
        lut = uint8(max(min(lut, 255), 0));
        res(:,:,k) = lut(double(img(:,:,k)) + 1);
    end
end