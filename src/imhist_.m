function h = imhist_(img, dim)
    h = image_histogram(img);

    if nargout == 0
        if nargin < 2
            dim = size(h, 2);
        end
        dim = min(dim, size(h, 2));
        colors = 'rgb';
        for channel = 1:dim
            plot(0:255, h(:, channel), colors(channel));
            hold on;
        end
        hold off;
    end
end
