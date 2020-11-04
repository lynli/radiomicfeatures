function featSruct = convertFeatureStringToStruct(featName)
    
    featSruct = struct;
    featSruct.waveLength   = [];
    featSruct.orientation  = [];
    featSruct.radius       = [];
    featSruct.kernelType   = [];
    featSruct.nHistBins    = [];
    featSruct.nSubFeatures = [];


    C = strsplit(featName, '_');
    
    featSruct.name = C{1};
    
    switch featSruct.name
           case 'Gabor'
               featSruct.waveLength  = str2num(C{2});
               featSruct.orientation = str2num(C{3});
               
           case 'Haralick'
               featSruct.radius       = str2num(C{3});
               featSruct.nHistBins    = str2num(C{4});
               featSruct.nSubFeatures = convertHaralickNameToIndex(C{2});

           case 'Laws'
               featSruct.nSubFeatures = str2num(C{2});
               
           case 'Mean'
               featSruct.radius       = str2num(C{2});
               
           case 'Median'
               featSruct.radius       = str2num(C{2});
               
           case 'StdDev'
                featSruct.radius       = str2num(C{2});
                
           case 'Sobel'
                featSruct.kernelType   = C{2};
                
           case 'Gradient'
               featSruct.kernelType   = C{2};
               
           case 'Entropy'
               featSruct.radius       = str2num(C{2});
               
           case 'Intensity'
              
           case 'Range'
               featSruct.radius       = str2num(C{2});
               
       otherwise
              error(strcat('Unexpected feature name', featSruct.name));
           
       end
       
      
    
end