function Feature = getLoG(image)

    if (ndims(image) == 2 || ndims(image) == 3)
        for z = 1 : size(image, 3)
            Feature(:, :, z) = edge(double(image(:, :, z)),'log');  
        end 
    else
            error('image number of dimensions is neither 2 nor 3 ...');
    end
     
end

