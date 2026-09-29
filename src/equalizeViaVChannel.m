function out = equalizeViaVChannel(imgRGB)
    hsv = rgb2hsv(imgRGB / 255);
    V = hsv(:, :, 3) * 255;
    Veq = histEqualizeChannel(V);
    hsv(:, :, 3) = Veq / 255;
    out = hsv2rgb(hsv) * 255;
end