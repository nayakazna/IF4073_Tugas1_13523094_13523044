function res = imhistmatch_(img, ref)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    h1 = image_histogram(img);
    h2 = image_histogram(ref);
    N1 = size(img, 1) * size(img, 2);
    N2 = size(ref, 1) * size(ref, 2);
    res = zeros(size(img), 'uint8');

    for k = 1:3
        c1 = cumsum(h1(:, k)) / N1;
        c2 = cumsum(h2(:, k)) / N2;
        lut = zeros(256, 1);
        for v = 1:256
            idx = find(c2 >= c1(v) - 1e-12, 1);
            if isempty(idx)
                idx = 256;
            end
            lut(v) = idx - 1;
        end
        res(:,:,k) = uint8(lut(double(img(:,:,k)) + 1));
    end
end