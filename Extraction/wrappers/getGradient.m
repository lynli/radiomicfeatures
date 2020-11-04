function feature = getGradient(image, type)

% type can take a value of x, y, m, d
% 'x' : gradient along x direction
% 'y' : gradient along y direction
% 'm' : gradient magnitude sqrt(Gx^2 + Gy^2)
% 'd' : gradient direction (arctan2(Gy/Gx))

    if (ndims(image) ~= 2 && ndims(image) ~= 3)
         error('image number of dimensions is neither 2 nor 3 ...'); 
    end
    
    for z = 1 : size(image, 3)
        feature(:, :, z) = getGradient2d(double(image(:, :, z)), char(type));
    end 
    
end






function gradFeature = getGradient2d(image, type)

% type can take a value of x, y, m, d
% 'x' : gradient along x direction
% 'y' : gradient along y direction
% 'm' : gradient magnitude sqrt(Gx^2 + Gy^2)
% 'd' : gradient direction (arctan2(Gy/Gx))

[Gx, Gy] = imgradientxy(image);

switch type
    case 'x'
        gradFeature = Gx;
    case 'y'
        gradFeature = Gy; 
    case 'd'
        [Gmag, gradFeature] = imgradient(Gx, Gy);    
    case 'm'
        [gradFeature, Gdir] = imgradient(Gx, Gy);           
    otherwise
    
end


    %gradFeature = rescale(gradFeature);

end


