function [feats, names] = lcibFeats(curvepts, time)
curvepts=smooth(curvepts);
[MaxSI,id] = max(curvepts);
TTP=time(id);
MaxUp = (MaxSI-curvepts(1))/curvepts(1);
if id==1 
   UpRate=0; 
else
   UpRate = MaxUp/(time(id-1)); 
end
if length(curvepts)==id 
   WoRate = 0; 
else
   WoRate =(curvepts(end)-MaxSI)/(time(end)-TTP);
end
Enhance = (curvepts(3)-curvepts(1))/curvepts(1);
EnRatio = Enhance/MaxUp;
feats=[MaxUp, TTP, UpRate, WoRate, Enhance, EnRatio];
names = {'Maximum Uptake', 'Time to Peak', 'Rate of Uptake', ...
    'Rate of Washout', 'Initial Enhancement', 'Enhancement Ratio'};