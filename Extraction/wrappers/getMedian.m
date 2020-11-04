
function medianFeature = getMedian(image, radSize)

% radius of kernel window

    if (ndims(image) ~= 2 && ndims(image) ~= 3)
         error('image number of dimensions is neither 2 nor 3 ...'); 
    end


    for z = 1 : size(image, 3)
        medianFeature(:, :, z) = getMedian2d(double(image(:, :, z)), radSize);
    end 
    
    
end


function medianFeature = getMedian2d(image, radSize)

% radius of kernel window

ws = 1 + 2 * radSize; % kernel window size

medianFeature = medfilt2(image, [ws ws]);

%medianFeature = rescale(medianFeature);

end