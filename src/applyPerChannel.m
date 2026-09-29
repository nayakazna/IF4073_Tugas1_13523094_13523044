function result = applyPerChannel(img, isColorFlag, fcnHandle)
    if isColorFlag
        result = zeros(size(img));
        for k = 1:3
            result(:, :, k) = fcnHandle(img(:, :, k));
        end
    else
        result = fcnHandle(img);
    end
end