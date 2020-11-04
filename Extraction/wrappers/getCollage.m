function [features, featNames] = getCollage(image, winRad)

switch (ndims(image))
    case 2
        [features, featNames] = getCollage2D(image, winRad);
        features = rescale(features);
    case 3
        for z = 1 : size(image, 3)
            [features(:, :, z, :), featNames] = getCollage2D(image(:, :, z), winRad);
            features(:, :, z, :) = rescale(features(:, :, z, :));
        end
        
    otherwise
        error('image number of dimensions is neither 2 nor 3 ...');
end

end


function [volfeats, featNames] = getCollage2D(image, winRadius)

% winRad  : this is the radius of the from which the GLCM is calculated for
% each pixel ()

    featNames = {'Entropy','Energy','Intertia','InDiffMom','Correlation','InfoMes1' ...
                 'InfoMes2','Sum Ave','Sum Var','Sum Ent','Diff Ave','Diff Var','Diff Ent'};

    for idxHralickSubFeature = 1 : length(featNames)
        volfeats(:, :, idxHralickSubFeature) = compute_CoLlAGe2D(image , winRadius, idxHralickSubFeature, [], true);
    end    

end