% Ahmad Algohary 06/23/2017

cd(fileparts(mfilename('fullpath')));

%mex -setup:'C:\Program Files\MATLAB\R2017a\bin\win64\mexopts\msvc2013.xml' C
%mex -setup:'C:\Program Files\MATLAB\R2017a\bin\win64\mexopts\msvcpp2013.xml' C++


mex -output 'ComputeHaralick' 'ComputeHaralick.cpp'


