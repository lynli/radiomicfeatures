function InitializeTest(codeDir)

        clc; clear; close all; 
        
        if(~exist('codeDir', 'var') || isempty(codeDir))
            codeDir = fileparts(fileparts(mfilename('fullpath')));
        end
        
    addpath(strcat(codeDir, '/Code'), ...
            strcat(codeDir, '/Code/MAT_helperFuncs'), ...
            strcat(codeDir, '/Code/MEX_ComputeV')   , ...
            strcat(codeDir, '/Code/MEX_Atan_2')     , ...
            strcat(codeDir, '/Code/MEX_ComputeHaralick'));

end