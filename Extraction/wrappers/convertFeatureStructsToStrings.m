function featureNameList = convertFeatureStructsToStrings(featureStructList)

% This function gets the list of names of the features passed in the
% structure list featureStructList


nFeatures = length(featureStructList);

featureNameList = cell(0, 1);

fnameidx = 1;
   for nf = 1 : nFeatures
       
       currentFeature = featureStructList(nf);
       %currentFeature = featureStructList{nf};
       
%        try
%             currentFeature = featureStructList(nf);
%         catch exception
%             try
%                 currentFeature = featureStructList{nf};
%             catch exception
%                 error('Struct/Cell mismatch ...');
%             end
%         end
       
       
       
       currParamString = '';
       try
       if(~isempty(currentFeature.waveLength))
           currParamString = strcat(currParamString, strcat('_', num2str(currentFeature.waveLength)));
       end
       end
       try
       if(~isempty(currentFeature.orientation))
           currParamString = strcat(currParamString, strcat('_', num2str(currentFeature.orientation)));
       end
       end
       try
       if(~isempty(currentFeature.radius))
           currParamString = strcat(currParamString, strcat('_', num2str(currentFeature.radius)));
       end
       end
       try
       if(~isempty(currentFeature.kernelType))
           currParamString = strcat(currParamString, strcat('_', (currentFeature.kernelType{1, 1})));
       end
       end
       try
       if(~isempty(currentFeature.nHistBins))
           currParamString = strcat(currParamString, strcat('_', num2str(currentFeature.nHistBins)));
       end
       end
       
       switch currentFeature.name
            case 'Haralick'
               haralickFeatNames = {'Entropy', 'Energy', 'Intertia', 'InDiffMom', 'Correlation', 'InfoMes1', 'InfoMes2', 'SumAve', 'SumVar', 'SumEnt', 'DiffAve', 'DiffVar', 'DiffEnt'};
                for i = 1 : 13 
                    featureNameList{fnameidx, 1} = strcat(strcat(currentFeature.name, '_'), strcat(haralickFeatNames{i}, currParamString));
                    fnameidx = fnameidx + 1;
                end
            case 'Collage'
               haralickFeatNames = {'Entropy', 'Energy', 'Intertia', 'InDiffMom', 'Correlation', 'InfoMes1', 'InfoMes2', 'SumAve', 'SumVar', 'SumEnt', 'DiffAve', 'DiffVar', 'DiffEnt'};
                for i = 1 : 13 
                    featureNameList{fnameidx, 1} = strcat(strcat(currentFeature.name, '_'), strcat(haralickFeatNames{i}, currParamString));
                    fnameidx = fnameidx + 1;
                end              
           case 'Laws'
              for i = 1 : 25
                featureNameList{fnameidx, 1} = strcat(strcat(currentFeature.name, '_'), strcat(num2str(i), currParamString));
                fnameidx = fnameidx + 1;
              end
           otherwise

             featureNameList{fnameidx, 1} = strcat(currentFeature.name, currParamString);
             fnameidx = fnameidx + 1;

       end
       
   
   end
end