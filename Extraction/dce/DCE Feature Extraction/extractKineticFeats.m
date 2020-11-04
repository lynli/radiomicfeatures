function [kineticFeats, featureNames] = extractKineticFeats(datadce_dir)
% INPUT: Directory containing DCE dicom files, mha files, masks in mat
% format. The mask must be a volume same size as one DCE volume

% Load DCE volume
[dceVol, time, numSlice, datadce_dir] = dceStruct_stvincent(datadce_dir);
load([datadce_dir filesep 'mask.mat']); % 3D volume

% ****NOTE: LOOK AT THE IMAGES AND MAKE SURE THE ORIENTATIONS OF MASK AND DCE VOLUME 
% MATCH SINCE THE MHA VOLUMES APPEAR ROTATED IN MATLAB*****

for i = 1:size(dceVol,4) % for each slice
    dce = dceVol(:,:,:,i);
    % Average over 3x3 window (Optional)
    window=[3 3];
    for jj=1:size(dce,3)
        dce(:,:,jj) = colfilt(dce(:,:,jj),window,'sliding',@mean); 
    end
    mask_reshape = reshape(mask(:,:,i),size(mask(:,:,i),1)*size(mask(:,:,i),2),1); 
    dce_reshape = reshape(dce,size(dce,1)*size(dce,2),size(dce,3));
    [voxelsOfInterest,~] = find(mask_reshape);
    DCEinROI = dce_reshape(voxelsOfInterest,:);

    for m=1:size(DCEinROI,1)
        curvepts = DCEinROI(m,:)';
        
        % Relative Enhancement
        preC = 3; % Find the last pre-contrast timepoint (NOTE: When this occurs is data dependent!)
        postC = preC+1; % Find the first post-contrast timepoint
        if mean(curvepts(1:preC))~=0
            y = ((curvepts(postC:end)-mean(curvepts(1:preC)))./mean(curvepts(1:preC)))*100; % Get relative enhancement values
        else
            y = curvepts(postC:end);
        end
        t = time(postC:end)'; 
        clear preC
        y = smooth(y); % Smooth the relative enhancement curve
        xnew = t(1):1:t(end);
        ynew = interp1(t,y,xnew);
        %createfigure(t,y,xnew,ynew);
        
        % CCIPD Legacy Features
        [feats, names] = lcibFeats(curvepts,time);
        
        % Features from Chen et al., JMRI, 2012
        [PE,id] = max(ynew); %Peak enhancement
        TTPE = xnew(id); %Time to peak enhancement
        s10=PE*0.10; s70=PE*0.70; %Relative enhancement at 10% and 70% of max uptake
        [~, id_s10]=min(abs(ynew-s10));
        [~, id_s70]=min(abs(ynew-s70));
        [~, id_wo]=min(abs(xnew-(xnew(end)-60)));
      
%         figure(1); hold on
%         plot(xnew(id_s10),ynew(id_s10),'r o','LineWidth',2); hold on;
%         plot(xnew(id_s70),ynew(id_s70),'r sq','LineWidth',2); hold on;
%         plot(xnew(id_wo),ynew(id_wo),'m d','LineWidth',2);
      
        IG = (ynew(id_s70)-ynew(id_s10))/(xnew(id_s70)-xnew(id_s10)); %intial gradient
        WG = (ynew(end)-ynew(id_wo))/(xnew(end)-xnew(id_wo)); %washout gradient
        
        Iauc30=trapz(xnew(xnew<=30+xnew(1)),ynew(xnew<=30+xnew(1))); %30 seconds post-contrast
        Iauc60=trapz(xnew(xnew<=60+xnew(1)),ynew(xnew<=60+xnew(1))); %60 seconds post-contrast
        Iauc = trapz(xnew,ynew);  
        
        % Glasser et al. features **NOTE: Needs to be optimized. 
%         t2 = find(xnew<=30, 1, 'last' ); % Find the timepoint around 120 seconds
%         %plot(xnew(t2),ynew(t2),'o b','LineWidth',2)
%         washin=(ynew(t2)-ynew(1))/(xnew(t2)-xnew(1));
%         washout = (ynew(end)-ynew(t2))/(xnew(end)-xnew(t2)); 
%         if ynew(t2)<=50 && washout<0.10
%          curvetype=1;
%         elseif ynew(t2)<=50 && washout>=-0.10 && washout<=0.10
%          curvetype=2;
%         elseif ynew(t2)<=50 && washout>0.10
%           curvetype=3;
%         elseif ynew(t2)> 50 && ynew(t2)<=100 && washout<0.10
%           curvetype=4;
%         elseif ynew(t2)> 50 && ynew(t2)<=100 && washout>=-0.10 && washout<=0.10
%           curvetype=5;
%         elseif ynew(t2)> 50 && ynew(t2)<=100 && washout>0.10
%           curvetype=6;
%         elseif ynew(t2)>100 && washout<0.10
%           curvetype=7;
%         elseif ynew(t2)>100 && washout>=-0.10 && washout<=0.10
%           curvetype=8;
%         elseif ynew(t2)>100 && washout>0.10
%           curvetype=9;
%         end
%       disp(['Curve Type: ' num2str(curvetype)]);
      
     kineticFeats(m,:,i) = [feats, PE, TTPE, IG, WG, Iauc30, Iauc60, Iauc];
                    clear stdfeats PE TTP IG WG Iauc30 Iauc60 Iauc curvepts...
                        preC postC t y xnew ynew s10 s70 id_s10 id_s70 id_wo t2 curvetype
    end         
        clear DCEinROI voxelsOfInterest mask_reshape dce_reshape dce
end
featureNames = [names, 'Peak Enhancement', 'Time to Peak Enhancement', 'Initial Gradient',...
    'Washout Gradient', 'Initial Area Under the Curve 30 seconds', 'Initial Area Uner the Curve 60 seconds',...
    'Total Area Unter the Curve'];

