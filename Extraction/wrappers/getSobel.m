function sobelFeature = getSobel(image, type)

% type could be one of : 'x' for x direction, 
%'y' for y direction, 
% 'dxy' for xy diagonal
% 'dyx' for yx diagonal
% 'm' for magnitude



if (ndims(image) == 2 || ndims(image) == 3)
    for z = 1 : size(image, 3)
        sobelFeature(:, :, z) = getSobel2d(double(image(:, :, z)), char(type));
    end 
else
        error('image number of dimensions is neither 2 nor 3 ...');
end
    
    
end


function sobeleature = getSobel2d(image, type)

% type could be one of : 'x' for x direction, 
%'y' for y direction, 
% 'dxy' for xy diagonal
% 'dyx' for yx diagonal
% 'm' for magnitude

kernel_x = [-1 0 1;-2 0 2;-1 0 1];
kernel_y = [1 2 1; 0 0 0; -1 -2 -1];
kernel_dxy = [0 1 2; -1 0 1; -2 -1 0];
kernel_dyx = flipdim([0 1 2; -1 0 1; -2 -1 0], 2);


switch type
    case 'x'
        sobeleature = conv2(image, kernel_x, 'same');
    case 'y'
        sobeleature = conv2(image, kernel_y, 'same');
    case 'dxy'
        sobeleature = conv2(image, kernel_dxy, 'same');
    case 'dyx'
        sobeleature = conv2(image, kernel_dyx, 'same');
    case 'm' % magnitude
        sobeleature_x = conv2(image, kernel_x, 'same');
        sobeleature_y = conv2(image, kernel_y, 'same');
        sobeleature = sqrt(sobeleature_x.^2 + sobeleature_y.^2);
    otherwise
        error('undefied kernel type ...');
end

%sobeleature = rescale(sobeleature);

end