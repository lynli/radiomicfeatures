InitializeTest(); % Initialize

%% Settings
caseID = 'case1_3'; % if directory name is case23_4, then ID is 23_4
%outPrefix = 'baseline' ; % or calculated 
%idxHaralickSubFeature = 1; 
%winRadius = 1; 
%sliceNum = 2;

%% Settings
% Select Case ID
caseDirPathList = findDirs(strcat(fileparts(fileparts(mfilename('fullpath'))), '/Data/'), 0); % Get Case directory list in ../Data/
caseIDList = cell(1, 0);

for i = 1 : length(caseDirPathList)
   caseIDList{i} = GetNameFromPath(caseDirPathList{i});
end
[idxSelectedCase, v] = listdlg('PromptString','Select a case ID:',...
                'SelectionMode','single',...
                'ListSize',[100 500],...
                'Name', 'Select Case ID ...',...
                'ListString', caseIDList);


if(~v || isempty(idxSelectedCase))
    disp('Operation canceled or no valid section made ...');
    return;
else
    caseDir = caseDirPathList{idxSelectedCase};
end

% Select parameters
settings = inputdlg({'winRadius','idxHralickSubFeature', 'sliceNum', 'outPrefix'}, 'Settings', 1, {'1', '1', '1', 'baseline'}); 
if(isempty(settings)) % user clicked the cancel button
    disp('Operation canceled ...');
    return;
else
    [winRadius, status] = str2num(settings{1});  
    assert(status, 'Invalid winRadius value ...');
    [idxHaralickSubFeature, status] = str2num(settings{2});  
    assert(status, 'Invalid idxHaralickSubFeature value ...'); 
    [sliceNum, status] = str2num(settings{3});  
    assert(status, 'Invalid sliceNum value ...'); 
    outPrefix = settings{4};  
    %assert(status, 'Invalid outPrefix value ...'); 
end


%% Start
    %caseDir = strcat(parentDir, '/Data/', num2str(caseID));
    [I, resolution, offset] = mha_read_volume(strcat(caseDir, '/T1.mha'));
    M = mha_read_volume(strcat(caseDir, '/T1-label.mha'));
    
    
    % Assertions 
    AssertTestInput(idxHaralickSubFeature, winRadius, I, M, sliceNum);
    
    I = I(:, :, sliceNum);
    M = M(:, :, sliceNum);
    
    mha_write_volume(strcat(caseDir, '/Image_slice', num2str(sliceNum), '.mha'), I, resolution, offset);
    mha_write_volume(strcat(caseDir, '/Mask_slice', num2str(sliceNum), '.mha'), M, resolution, offset);
        
    sCollage = compute_CoLlAGe2D(I, winRadius, idxHaralickSubFeature, M);
    mha_write_volume(strcat(caseDir, '/', outPrefix, 'Coliage_h', num2str(idxHaralickSubFeature-1), '_rad', num2str(winRadius), '_slice', num2str(sliceNum), '.mha'), sCollage, resolution, offset);

   %% End
   disp(strcat('DONE: ', caseDir, '/', outPrefix, 'Coliage_h', num2str(idxHaralickSubFeature-1), '_rad', num2str(winRadius), '_slice', num2str(sliceNum), '.mha')) 