function rangeFeature = getRange(image, radSize)

% radius of kernel window

    if (ndims(image) ~= 2 && ndims(image) ~= 3)
         error('image number of dimensions is neither 2 nor 3 ...'); 
    end

    if(radSize < 1)
        error('radius is expected to be greater than 1 ...'); 
    end
    
    ws = 1 + 2 * radSize; % kernel window size
    neighborWin = ones(ws, ws);
    
    for z = 1 : size(image, 3)
        rangeFeature(:, :, z) = rangefilt(double(image(:, :, z)), neighborWin);
        %rangeFeature(:, :, z) = rescale(rangeFeature(:, :, z));
    end 

end


