function index = convertHaralickNameToIndex(name)
    featNames={'Entropy','Energy','Intertia','InDiffMom','Correlation','InfoMes1' ...
    'InfoMes2','SumAve','SumVar','SumEnt','DiffAve','DiffVar','DiffEnt'};

index = find(ismember(featNames, name));

end