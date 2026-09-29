function h = image_histogram(X)
    h = zeros(256, 3);
    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            for k = 1:3
                value = int64(X(i,j,k));
                h(value +1, k) = h(value + 1, k) + 1;
            end
        end
    end
end