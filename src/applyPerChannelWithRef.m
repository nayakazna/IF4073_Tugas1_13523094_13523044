function result = applyPerChannelWithRef(img, refImg, isColorFlag, fcnHandle)
    if isColorFlag
        result = zeros(size(img));
        for k = 1:3
            refCh = refImg(:, :, min(k, size(refImg, 3)));
            result(:, :, k) = fcnHandle(img(:, :, k), refCh);
        end
    else
        refCh = refImg;
        if ndims(refCh) == 3, refCh = rgb2grayManual(refCh); end
        result = fcnHandle(img, refCh);
    end
end