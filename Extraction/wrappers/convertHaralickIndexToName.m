function name = convertHaralickIndexToName(index)
    featNames={'Entropy','Energy','Intertia','InDiffMom','Correlation','InfoMes1' ...
    'InfoMes2','SumAve','SumVar','SumEnt','DiffAve','DiffVar','DiffEnt'};
name = featNames{index};
end
