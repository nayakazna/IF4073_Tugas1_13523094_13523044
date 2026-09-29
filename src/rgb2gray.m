function gray = rgb2gray(img)
    R = img(:, :, 1); G = img(:, :, 2); B = img(:, :, 3);
    gray = 0.2989 * R + 0.5870 * G + 0.1140 * B;
end