function name = GetNameFromPath(path)

    % if the last char is slash, remove it
    lastChar = path(length(path));
    if(lastChar == '\' || lastChar == '/')
        path = path(1 : length(path) - 1);
    end

   
    idxOccurence_b = strfind(path, '\');
    idxOccurence_f = strfind(path, '/');

    f = max(idxOccurence_f);
    b = max(idxOccurence_b);
    

    if(~isempty(b) && ~isempty(f))
        idx = 0;
    elseif(~isempty(b) && isempty(f))
        idx = b;
    elseif(isempty(b) && ~isempty(f))
        idx = f;
    elseif(isempty(b) && isempty(f))
        idx = max(f, b);
    end
    
    name = path(idx + 1 : length(path));

end