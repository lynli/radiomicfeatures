function VFeatures = extractFeatures(VImages, featuresList)
%% Get the initial List of Features with parameters
%featuresList = getFeatureParams;
%featuresList = getFeatureParamsReduced;
nStudies = length(VImages); 
nFeatures = length(featuresList); 

VFeatures = cell(nStudies, nFeatures);

for s = 1 : nStudies
   currImage = VImages{s, 1};
    
   f = 1; % pointer to where the extracted feature will be placed in VFeatures
   for nf = 1 : nFeatures
       currentFeature = featuresList(nf);
       
    if(iscell(currentFeature))
        currentFeature = currentFeature{1, 1};
    end

        switch currentFeature.name
            case 'Gabor'
               VFeatures{s, f} = single(getGabor(currImage, currentFeature.waveLength, currentFeature.orientation));
            case 'Haralick'
                extractedFeature = getHaralick(currImage, currentFeature.radius, currentFeature.nHistBins);
                   % add currentFeature.nSubFeatures - 1 only if it is the first study
                if(s == 1)
                    VFeatures = [VFeatures, cell(nStudies, length(currentFeature.nSubFeatures) - 1)];
                end 
                   % currentFeature.nSubFeatures will be a range (e.g. 1:13) of requested features or empty
                   for n = currentFeature.nSubFeatures
                       if(ndims(extractedFeature) == 4)
                         VFeatures{s, f} = single(extractedFeature(:, :, :, n));
                       else
                         VFeatures{s, f} = single(extractedFeature(:, :, n));  
                       end
                       f = f + 1;
                   end
               f = f - 1;
               clear extractedFeature;
            case 'Collage'
                extractedFeature = getCollage(currImage, currentFeature.radius);
                   % add currentFeature.nSubFeatures - 1 only if it is the first study
                if(s == 1)
                    VFeatures = [VFeatures, cell(nStudies, length(currentFeature.nSubFeatures) - 1)];
                end 
                   % currentFeature.nSubFeatures will be a range (e.g. 1:13) of requested features or empty
                   for n = currentFeature.nSubFeatures
                       if(ndims(extractedFeature) == 4)
                         VFeatures{s, f} = single(extractedFeature(:, :, :, n));
                       else
                         VFeatures{s, f} = single(extractedFeature(:, :, n));  
                       end
                       f = f + 1;
                   end
               f = f - 1;
               clear extractedFeature;
           case 'Laws'
               extractedFeature = getLaws(currImage);
                   % add currentFeature.nSubFeatures - 1 only if it is the first study
                   if(s == 1)
                    VFeatures = [VFeatures, cell(nStudies, length(currentFeature.nSubFeatures) - 1)];
                   end 
                   % currentFeature.nSubFeatures will be a range of requested features or empty
                   for n = currentFeature.nSubFeatures
                       if(ndims(extractedFeature) == 4)
                         VFeatures{s, f} = single(extractedFeature(:, :, :, n));
                       else
                         VFeatures{s, f} = single(extractedFeature(:, :, n));  
                       end
                       f = f + 1;
                   end
                f = f - 1;
                clear extractedFeature;
           case 'Mean'
               VFeatures{s, f} = single(getMean(currImage, currentFeature.radius));
           case 'Median'
               VFeatures{s, f} = single(getMedian(currImage, currentFeature.radius));
           case 'StdDev'
                VFeatures{s, f} = single(getStdDev(currImage, currentFeature.radius));
           case 'Sobel'
                VFeatures{s, f} = single(getSobel(currImage, currentFeature.kernelType));
           case 'Gradient'
               VFeatures{s, f} = single(getGradient(currImage, currentFeature.kernelType));
           case 'Entropy'
               VFeatures{s, f} = single(getEntropy(currImage, currentFeature.radius));
           case 'Intensity'
              VFeatures{s, f} = single(getIntensity(currImage));
           case 'Range'
               VFeatures{s, f} = single(getRange(currImage, currentFeature.radius));
           case 'Canny'
               VFeatures{s, f} = single(getCanny(currImage));
           case 'LoG'
               VFeatures{s, f} = single(getLoG(currImage));
       otherwise
              warning(strcat('Unexpected feature name', featuresList(f).name));
        end
        
       %disp(['Image ', num2str(s), ', feature ', num2str(f),' done ...'])
       f = f + 1;
   end
   
   disp(['Image ', num2str(s),' done ...'])
end

end


