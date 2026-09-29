function out = specifyViaVChannel(imgRGB, refRGB)
    hsvIn = rgb2hsv(imgRGB / 255);
    Vin = hsvIn(:, :, 3) * 255;
    if ndims(refRGB) == 3
        hsvRef = rgb2hsv(refRGB / 255);
        Vref = hsvRef(:, :, 3) * 255;
    else
        Vref = refRGB;
    end
    Vout = histSpecifyChannel(Vin, Vref);
    hsvIn(:, :, 3) = Vout / 255;
    out = hsv2rgb(hsvIn) * 255;
end