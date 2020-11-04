function dirList = findDirs(dirName, recursive)

% dirName: input directory absolute path
% recursive: if 1: search recursively
%            otherwise: no recursion
% Ahmad Algohary

dirList = cell(0, 1);

if(isempty(dirName))
    error('Input directory path is empty ...');
end

  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories

  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  
  validIndex = ~ismember(subDirs, {'.','..'});  %# Find index of subdirectories

    idx  = find(validIndex);
	idxLst = 1;
    for i = idx
        dirList{idxLst, 1} = fullfile(dirName, subDirs{i});
        idxLst = idxLst + 1;
    end

  
    if(recursive == 1)
        initialLen = length(dirList);
	  for i = 1:initialLen                  
		subDirList = findDirs(dirList{i}, recursive);
        dirList = [dirList; subDirList];
	  end
    end
end