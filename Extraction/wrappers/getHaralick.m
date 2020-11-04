function [features, featNames] = getHaralick(image, winRad, nHBins)

switch (ndims(image))
    case 2
        [features, featNames] = getHaralick2D(image, winRad, nHBins);
    case 3
        for z = 1 : size(image, 3)
            [features(:, :, z, :), featNames] = getHaralick2D(image(:, :, z), winRad, nHBins);
        end
        
    otherwise
        error('image number of dimensions is neither 2 nor 3 ...');
end

end


function [volfeats, featNames] = getHaralick2D(image, winRad, nHBins)

% winRad  : this is the radius of the from which the GLCM is calculated for
% each pixel ()
% nHBins : Number of histogram bins representing the Maximum number of quantization level

haralickfun = @ComputeHaralick;



bg = -1;          % Background
hardist = 1;      % Distance in a window

nharalicks = 13;  % Number of Features
vol = double(image);
ws = (winRad * 2 + 1);           % Window Size
volN = round(rescale_range(vol, 0, nHBins-1));   % Quantizing an image

addedfeats = 0;  % Feature counter index
volfeats(:,:, addedfeats+(1:nharalicks)) = haralickfun(volN, nHBins, ws, hardist, bg);

for i = 1 : size(volfeats, 3)
    volfeats(:, :, i) = rescale(volfeats(:, :, i));
end

featNames={'Entropy','Energy','Intertia','InDiffMom','Correlation','InfoMes1' ...
    'InfoMes2','Sum Ave','Sum Var','Sum Ent','Diff Ave','Diff Var','Diff Ent'};

    
% %--
% figure (1)
% subplot (3,5,1)
% imagesc(vol); colormap gray; title ('Original'); axis image; axis off
% for i=1:13
%     subplot (3,5,i+1)
%     imagesc(volfeats(:,:,i)); colormap gray
%     title (featNames{i})
%     axis image
%     axis off
% end

end