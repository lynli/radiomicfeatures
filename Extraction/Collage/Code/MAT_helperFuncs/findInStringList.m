function [ subList ] = findInStringList( stringList, pattern, multipleOccurrenceAllowed)

% Given a list of strings (might be file/directory paths/names)
% This function returns a sublist of strings which contain the given
% pattern

subList = cell(0);

for i = 1 : length(stringList)

    currentStr = char(stringList(i));
    idxOccurence = strfind(currentStr, pattern);
    nOccurences = length(idxOccurence);
    
if(1 == nOccurences)  % found once
    subList(length(subList) + 1) = cell(stringList(i));
else
    if(1 < nOccurences)
        if(~multipleOccurrenceAllowed)
            msgbox('Searched pattern occures more than once ...', 'Error 001');
        else
            subList(length(subList) + 1) = cell(stringList(i));
        end
    end
end


end

end

