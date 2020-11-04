function [collage_map, collageInImg] = compute_CoLlAGe2D(inImage, winRadius, haralick_number, inMask, processWholeImage)

% Sanity checks
narginchk(4, 5)
assert(~isempty(inImage), 'Invalid input image ...');
assert(~isempty(winRadius) && isscalar(winRadius) && ~mod(winRadius, 1) && winRadius > 0 && winRadius <= 10, 'Invalid winRadius (Expected to be integer between 1 - 10) ...');
assert(~isempty(haralick_number) && isscalar(haralick_number) && ~mod(haralick_number, 1) && haralick_number > 0 && haralick_number <= 13, 'Invalid Haralick index (expected to be an integer between 1 - 13) ...');

if(exist('processWholeImage', 'var'))
    assert(~isempty(processWholeImage), 'Empty boolean argument processWholeImage, if not needed, it has to be removed ...');
    inImage = impad(inImage, size(inImage) + 2 * winRadius, cast(0,class(inImage)));
    [r, c] = size(inImage);
    c_min = uint16(1 + winRadius);
    c_max = uint16(c - winRadius);
    r_min = uint16(1 + winRadius);
    r_max = uint16(r - winRadius);
else
    if(exist('inMask', 'var'))
        assert(unique(size(inMask) == size(inImage)) == 1, 'Invalid mask size (does not match input image size ...');
        assert(isTwoLevelMask(inMask), 'Invalid mask (input mask should have only two levels ...');
        
        [r_mask, c_mask] = find(inMask ~= 0);
        
        if(isempty(r_mask))
            collage_map = zeros(size(inImage));
            return;
        end
        
        c_min= uint16(min(c_mask));
        c_max= uint16(max(c_mask));
        r_min= uint16(min(r_mask));
        r_max= uint16(max(r_mask));
    else
        error('Invalid input mask ...')
    end
end

I2_outer = inImage(r_min-winRadius:r_max+winRadius,c_min-winRadius:c_max+winRadius);
I2_double_outer=im2double(I2_outer);
I2_inner=inImage(r_min:r_max,c_min:c_max);
[r, c]=size(I2_inner);
[Gx, Gy]=gradient(I2_double_outer);

[dominant_orientation_roi]=find_orientation_CoLlAGe(Gx,Gy,winRadius,r,c);

% Find co-occurrence features of orientation
vol=double(dominant_orientation_roi);

nharalicks=13;  % Number of Features
bg=-1;          % Background-1
ws=5;           % Window Size5
hardist=5;      % Distance in a window5
harN=64;        % Maximum number of quantization level 64

scal = rescale_range(vol,0,harN-1);
volN=round(scal);   % Quantizing an image
addedfeats=0;  % Feature counter index

volfeats = zeros(size(volN, 1), size(volN, 2), 13);
volfeats(:,:,addedfeats+(1:nharalicks)) = ComputeHaralick(volN,harN,ws,hardist,bg);
collage_map=volfeats(:,:,haralick_number);

% Inut image with ROI values replaced wwith calculated map
collageInImg = inImage;
collageInImg(r_min : r_max, c_min : c_max) = collage_map;

end







