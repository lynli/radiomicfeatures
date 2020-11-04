function intensityFeature = getIntensity(image)

if (ndims(image) == 2 || ndims(image) == 3)
    intensityFeature = image;
else
        error('image number of dimensions is neither 2 nor 3 ...');
end
    
end

