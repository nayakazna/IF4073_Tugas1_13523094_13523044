function kernel = buildKernel(kernelName, kernelSize, sigma)
%BUILDKERNEL Construct the kernels exposed by the filtering tab.
    validateattributes(kernelSize, {'numeric'}, {'scalar', 'integer', 'positive'});
    if mod(kernelSize, 2) == 0
        error('buildKernel:InvalidSize', 'Ukuran kernel harus ganjil.');
    end

    switch kernelName
        case 'Average'
            kernel = ones(kernelSize) / kernelSize^2;
        case 'Gaussian'
            validateattributes(sigma, {'numeric'}, {'scalar', 'finite', 'positive'});
            radius = floor(kernelSize / 2);
            [x, y] = meshgrid(-radius:radius);
            kernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
            kernel = kernel / sum(kernel(:));
        case 'Sharpen'
            kernel = [0 -1 0; -1 5 -1; 0 -1 0];
        case 'Sobel-X'
            kernel = [-1 0 1; -2 0 2; -1 0 1];
        case 'Sobel-Y'
            kernel = [-1 -2 -1; 0 0 0; 1 2 1];
        otherwise
            error('buildKernel:UnknownKernel', 'Unknown kernel: %s.', kernelName);
    end
end
