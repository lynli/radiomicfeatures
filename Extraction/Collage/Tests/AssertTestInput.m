function AssertTestInput(idxHaralickSubFeature, winRadius, inImage, inMask, sliceNum)

assert(~isempty(winRadius) && isscalar(winRadius) && ~mod(winRadius, 1) && winRadius > 0 && winRadius <= 10, 'Invalid winRadius (Expected to be integer between 1 - 10) ...');
assert(~isempty(idxHaralickSubFeature) && isscalar(idxHaralickSubFeature) && ~mod(idxHaralickSubFeature, 1) && idxHaralickSubFeature > 0 && idxHaralickSubFeature <= 13, 'Invalid Haralick index (expected to be an integer between 1 - 13) ...');

assert(unique(size(inMask) == size(inImage)) == 1, 'Invalid mask size (does not match input image size ...');
assert(isTwoLevelMask(inMask), 'Invalid mask (input mask should have only two levels ...');

assert(sliceNum >= 1 && sliceNum <= size(inImage, 3), 'Out of range sliceNum ...');

end