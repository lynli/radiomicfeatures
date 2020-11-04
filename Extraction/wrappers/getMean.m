function meanFeature = getMean(image, winRadius)

windowSize = 1 + 2 * winRadius;
kernel = ones(windowSize, windowSize);
kernel = kernel ./ (windowSize^2);

switch (ndims(image))
    case 2
        meanFeature = conv2(double(image), kernel, 'same');
        meanFeature = rescale(meanFeature);
    case 3
        for z = 1 : size(image, 3)
            meanFeature(:, :, z) = conv2(double(image(:, :, z)), kernel, 'same');
            %meanFeature(:, :, z) = rescale(meanFeature(:, :, z));
        end
    otherwise
        error('image number of dimensions is neither 2 nor 3 ...');
end


    

end