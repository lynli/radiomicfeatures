InitializeTest(); % Initialize

%% Settings
outPrefix = 'baseline' ; % or 'calculated'
maximumWinRadius = 10;

%% Start
caseDirPathList = findDirs(strcat(fileparts(fileparts(mfilename('fullpath'))), '/Data/'), 0); % Get Case directory list in ../Data/

for c = 1 : length(caseDirPathList)
    caseDirPath = caseDirPathList{c};
    [pathstr, caseDirName, ext] = fileparts(caseDirPath);
    [I, resolution, offset] = mha_read_volume(strcat(caseDirPath, '/T1.mha'));
    M = mha_read_volume(strcat(caseDirPath, '/T1-label.mha'));
    
    for s = 1 : size(I, 3)
        mha_write_volume(strcat(caseDirPath, '/Image_slice', num2str(s), '.mha'), I(:, :, s), resolution, offset);
        mha_write_volume(strcat(caseDirPath, '/Mask_slice', num2str(s), '.mha'), M(:, :, s), resolution, offset);
        
        for r = 1 : maximumWinRadius
            for idxHaralickSubFeature = 1 : 13
                sCollage = compute_CoLlAGe2D(I(:, :, s), r, idxHaralickSubFeature, M(:, :, s));
                mha_write_volume(strcat(caseDirPath, '/', outPrefix, 'Coliage_h', num2str(idxHaralickSubFeature-1), '_rad', num2str(r), '_slice', num2str(s), '.mha'), sCollage, resolution, offset);
            end
        end

        %disp(strcat('SUCCESS: CASE: ', caseDirName, ', SLICE: ', num2str(s), ' ...')); % Display success message (better with for)
    end
    
    disp(strcat('SUCCESS: CASE: ', caseDirName, ' ...')); % Display success message (better with parfor)
end
