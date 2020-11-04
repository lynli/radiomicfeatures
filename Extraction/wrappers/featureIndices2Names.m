function featureNames = featureIndices2Names(idxFeatures, allFeaturesStructList, protocolNames)

try

featNameList = convertFeatureStructsToStrings(allFeaturesStructList);
nAllFeats = length(featNameList);

for x = 1 : length(protocolNames)
    featureNameList((1+(nAllFeats * (x-1))) : (x * nAllFeats)) = featNameList;
end

% Now BestFeatures has the indices of the requested features, Next: I will write the names
featureNames = featureNameList(idxFeatures);
    
catch e
    handleException(e)
end
end