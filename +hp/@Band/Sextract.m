function y=Sextract(x,flag)
%function y=extract(x,flag)
% returns spiketimes (points of threshold crossing)
% uses 2.5 standard deviations for threshold 
% x=raw data (sampled at 10kHz)
% flag: enter a positive value to select positive deflecting (upward) spikes
%      or a negative number for negative deflecting (downward) spikes

xo=x-mean(x);
thres=2.5*std(xo);
if flag>=0
   ind_high=find(xo>thres); % select upward spikes 
else
   ind_high=find(xo<-thres); % select downward spikes
end
dif_high=diff(ind_high); 		%diff vector
index=find(dif_high>1)+1;
ty=round(ind_high(index)/10); %divides /10 to get spike times in 1msec resolution
lng=floor(length(x)/10); 		%length of the spike train in miliseconds
y=zeros(lng,1);
y(ty)=ones(size(ty));
