function SUVFeature = getSUV(image,BWI)

if (ndims(image) == 2 || ndims(image) == 3)
    SUVFeature = image/BWI;
else
        error('image number of dimensions is neither 2 nor 3 ...');
end
    
end