function out = intensityTransform(img, subtype, c, gammaVal, stretchVals)
%INTENSITYTRANSFORM Apply a selected intensity transformation to one channel.
    values = min(255, max(0, double(img)));

    switch subtype
        case 'Negative'
            out = 255 - values;
        case 'Log Transform'
            validateattributes(c, {'numeric'}, {'scalar', 'finite', 'nonnegative'});
            out = c * 255 * log(1 + values) / log(256);
        case 'Power-Law (Gamma)'
            validateattributes(c, {'numeric'}, {'scalar', 'finite', 'nonnegative'});
            validateattributes(gammaVal, {'numeric'}, {'scalar', 'finite', 'positive'});
            out = c * 255 * (values / 255) .^ gammaVal;
        case 'Contrast Stretching'
            if numel(stretchVals) ~= 4 || any(~isfinite(stretchVals))
                error('intensityTransform:InvalidStretch', 'Stretch values harus r1,s1,r2,s2.');
            end
            [r1, s1, r2, s2] = deal(stretchVals(1), stretchVals(2), stretchVals(3), stretchVals(4));
            if r1 < 0 || r2 > 255 || r1 >= r2 || any([s1 s2] < 0) || any([s1 s2] > 255)
                error('intensityTransform:InvalidStretch', 'Haruslah 0 <= r1 < r2 <= 255 dan nilai output di [0, 255].');
            end
            out = zeros(size(values));
            low = values <= r1;
            middle = values > r1 & values <= r2;
            high = values > r2;
            if r1 == 0
                out(low) = s1;
            else
                out(low) = values(low) * s1 / r1;
            end
            out(middle) = s1 + (values(middle) - r1) * (s2 - s1) / (r2 - r1);
            if r2 == 255
                out(high) = s2;
            else
                out(high) = s2 + (values(high) - r2) * (255 - s2) / (255 - r2);
            end
        otherwise
            error('intensityTransform:UnknownSubtype', 'Unknown intensity transformation: %s.', subtype);
    end
end
