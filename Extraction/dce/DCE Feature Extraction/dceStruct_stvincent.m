function [dceVol, time, numSlice, datadce_dir] = dceStruct_stvincent(datadce_dir)
% DCESTRUCT formats the DCE MRI data into the format required for feature
% extraction for St. Vincent data cohort

% INPUT: Path to the directory containing DCE MRI files. If you want to 
% work with mha files, add the registered dce mha files to the same folder 
% as the one containing dce dicom files (KEEP IN MIND the flipping issues 
% with mha!!)

% OUTPUT: 
% dceVol -- is a four dimensional matrix of the size m x n x o x p where m x n is
% the size of a slice and o is the number of time points and p is the number of slices. 
% time -- is the time in seconds of each time point from the first time point 
% numSlice -- is the number of slices in the volume
% datadce_dir -- points to the directory in which the original data lies (just
% in case you forget)

% Created by Asha Singanamalli 1/4/2014 with MATLAB ver: R2013b on Windows 8
% Edited on 10/1/2014 to account for the acquisition time format hh:mm:ss to get correct time in seconds 
% Edited on 3/23/2015 to create St Vincent data specific script which accounts for the 
% data format it has (slice 1 tpt 1...slice 1 tpt n, slice 2 tpt 1....etc) and uses inputs in the mha format when available

addpath(genpath('C:\Users\cwruasha\Documents\Research\Code\matlab\images\mha'))

% Need locations for both dicom and mha files since dicom provides.
% NOTE: Currently assumes the folder structure of demo data
% information on temporal spacing while mha provides the registered images
% datadce_dir = uigetdir('C:\Users\cwruasha\Documents\Research\Data','Select DCE MRI directory');
dicomfiles = dir([datadce_dir filesep 'B_DCE' filesep '*.dcm']);
mhafiles = dir([datadce_dir filesep 'ccipdRegd_B_*.mha']);

% Determine the number of slices
info = mha_read_header([datadce_dir filesep mhafiles(3).name]);
numSlice = info.Dimensions(3);

time(1)=0;
for i = 1 : numel(mhafiles)
    
    % Read mha volumes at each timepoint into a struct
    disp (['Loading....time point = ' num2str(i)]);
    dceVol(:,:,:,i) = mha_read_volume([datadce_dir filesep mhafiles(i).name]);
    
    % Determine the time points
    info = dicominfo([datadce_dir filesep 'B_DCE' filesep dicomfiles(i).name]);
    aqtime{i}=info.AcquisitionTime;
    if i>1
        T=aqtime{i};
        tcurr=[str2num(T(1:2)) str2num(T(3:4)) str2num(T(5:end))];
        time(i)=etime([0 0 0 tcurr],[0 0 0 t0]);
        clear tcurr T
    else
        T1=aqtime{1};
        t0=[str2num(T1(1:2)) str2num(T1(3:4)) str2num(T1(5:end))];
        clear T1
    end
end

dceVol=permute(dceVol,[1 2 4 3]); % last dimension is slice, 3rd dimension is time




