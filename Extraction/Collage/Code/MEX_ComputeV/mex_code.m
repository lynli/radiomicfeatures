% Ahmad Algohary 06/23/2017

cd(fileparts(mfilename('fullpath')));

%mex -setup:'C:\Program Files\MATLAB\R2017a\bin\win64\mexopts\msvc2013.xml' C
%mex -setup:'C:\Program Files\MATLAB\R2017a\bin\win64\mexopts\msvcpp2013.xml' C++


mex -output 'ComputeV' ...
-I'VNL\src\vxl\core' -I'VNL\src\vxl\core\vnl' ...
-I'VNL\src\vxl\core\vnl\algo' -I'VNL\src\vxl\vcl' ...
-l'itkvnl-4.11' -l'itkvnl_algo-4.11' ...
-l'ITKVNLInstantiation-4.11' ...
-l'itkvcl-4.11' -l'itknetlib-4.11' ...
-l'itkNetlibSlatec-4.11' -l'itkv3p_netlib-4.11' ...
-L'VNL\lib' ...
'ComputeV.cpp'


