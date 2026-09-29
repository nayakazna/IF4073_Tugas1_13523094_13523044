function imhist_(img, dim)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
h = image_histogram(img);
colors = ['r', 'g', 'b'];
for d = 1:dim
    plot(0:255, h(:, d), colors(d));
    hold on;
end
hold off;
end