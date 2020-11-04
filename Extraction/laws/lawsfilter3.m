function lawsresponses = lawsfilter3(I,shortflag)
% LAWSFILTER3 Apply 3D Law's filters to an image.
%
%   LAWSRESPONSES = LAWSFILTER3(I) returns in LAWSRESPONSES a N-by-M-by-125 
%       array containing the 125 filter responses from the laws kernels.
%
%   See also: lawskerns2, convn.
%
%JCC

[nrows, ncols, nplanes, highdims]=size(I);
if highdims>1, error('3D grayscale volumes only.'); end

K3=lawskerns3;
% [ks1 ks2 ks3 nkerns]=size(K3);
if nargin>1 && shortflag,
    nkerns=10;
else
    nkerns=size(K3,4); % nkerns 3D kernels
end

% Calculate filter responses
lawsresponses=zeros([nrows ncols nplanes nkerns]);
% fI=fftn(I,size(I)+[ks1 ks2 ks3]-1);
% [lawsresponses(:,:,:,1),nfft,fI]=jconvn(I,K3(:,:,:,1),size(I)); %#ok<ASGLU>
for i=1:nkerns,
    lawsresponses(:,:,:,i)=convn(I,K3(:,:,:,i),'same');
%     lawsresponses(:,:,:,i)=jconvn(fI,K3(:,:,:,i),size(I));
    fprintf('.');
end
fprintf('\n');
