function featureStructList = createFeatureStructs(featureNameList)
    nFeatures = length(featureNameList);
    featureStructList = cell(nFeatures, 1);

    for i = 1 : nFeatures
        featureStructList{i, 1} = convertFeatureStringToStruct(char(featureNameList{i}));
    end

end
