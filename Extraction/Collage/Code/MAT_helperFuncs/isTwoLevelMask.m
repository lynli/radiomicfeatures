function result = isTwoLevelMask(I)

% Ahmad Algohary
% Ensures given mask has a maximum of two unique levels,
% and if so, one of them is 0


    uv = unique(I);
     
    if(length(uv) == 1 && uv(1) == 0)
        result = true;
    elseif(length(uv) == 1 && uv(1) ~= 0 )
        warning(strcat('Only one NON-ZERO level was found in the given mask: ', num2str(uv(1))));
        result = true;   
    elseif(length(uv) == 2)
		result = true;
    else
        result = false;
    end

end