function Features = getFeatureParams_ISMRM2016

% nSubFeatures will be a range (e.g. 1:13) of requested features or empty

Features = struct;
n = 1; % current feature field being filled

%% Intensity
Features(n).name = 'Intensity';
n = n + 1;

%% Gabor
gaborWavelength = 1.0 : 2.0 : 20.0;
gaborOrientation = 0.00 : 0.50 : 3.50;
for w = 1 : length(gaborWavelength)
    for a = 1 : length(gaborOrientation)
        GaborParams(n, :) = [gaborWavelength(w), gaborOrientation(a)];
        
        Features(n).name = 'Gabor';
        Features(n).waveLength  = gaborWavelength(w);
        Features(n).orientation = gaborOrientation(a);
        
        n = n + 1;
    end
end

%% Entropy
kernelRadius = 1:1:2;
for r = 1 : length(kernelRadius)
    Features(n).name    = 'Entropy';
    Features(n).radius  = kernelRadius(r);
    n = n + 1;
end

%% Mean
kernelRadius = 1:1:2;
for r = 1 : length(kernelRadius)
    Features(n).name    = 'Mean';
    Features(n).radius  = kernelRadius(r);
    n = n + 1;
end

%% Median
kernelRadius = 1:1:2;
for r = 1 : length(kernelRadius)
    Features(n).name    = 'Median';
    Features(n).radius  = kernelRadius(r);
    n = n + 1;
end

%% Range
kernelRadius = 1:1:2;
for r = 1 : length(kernelRadius)
    Features(n).name    = 'Range';
    Features(n).radius  = kernelRadius(r);
    n = n + 1;
end

%% Standard Deviation
kernelRadius = 1:1:2;
for r = 1 : length(kernelRadius)
    Features(n).name    = 'StdDev';
    Features(n).radius  = kernelRadius(r);
    n = n + 1;
end

%% Sobel
kernelDirection = cellstr(['x  '; 'y  '; 'dxy'; 'dyx'; 'm  ']);
for k = 1 : size(kernelDirection, 1)
    Features(n).name    = 'Sobel';
    Features(n).kernelType  = kernelDirection(k);
    n = n + 1;
end

%% Gradient
kernelDirection = cellstr(['x'; 'y'; 'd'; 'm']);
for k = 1 : size(kernelDirection, 1)
    Features(n).name    = 'Gradient';
    Features(n).kernelType  = kernelDirection(k);
    n = n + 1;
end

%% Haralick
kernelRadius   = 1:1:2;
nHistogramBins = 64;
nSubFeatures   = 1:13;
for r = 1 : length(kernelRadius)
    for h = 1 : length(nHistogramBins)
        Features(n).name    = 'Haralick';
        Features(n).radius  = kernelRadius(r);
        Features(n).nHistBins  = nHistogramBins(h);
        Features(n).nSubFeatures  = nSubFeatures;
        n = n + 1;
    end
end

%% Laws
nSubFeatures   = 1:25;
        
    Features(n).name          = 'Laws';
    Features(n).nSubFeatures  = nSubFeatures;
    n = n + 1;



end

