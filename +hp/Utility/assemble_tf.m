function [t0,y]= assemble_tf(xin,dw,wl,nwin)

% function y= assemble_tf(x,dw,wl,nwin)
% use to align sliding window calculations with original data series
% returns a signal with the data in x
% extended at 1kHz sampling rate by spline interpolations.
% t0 indicates the first  time point, to aligne
% in time. x must be a column vector (no matrices)

flag=iscell(xin);
if flag
    x=xin; 
else
   x{1}=xin;
end
clear xin;

for i=1:length(x)
  
    if size(x{i},2)>1;
        x{i}=x{i}';
    end
    
    % y=zeros(totpoints,1);
    span=(nwin-1)*dw+wl; % this is the time spanned by each windowed calculation
    t0=round(span/2);     % time shift the result to the middle point of the first interval
    
    % if nargin>5
    %     if inter=='interpolate'    
    
    tpoints=1:dw:dw*length(x{i})-1;
    y{i}=spline(tpoints,x{i},1:dw*length(x{i}));
end

if ~flag
    y=y{1};
end

%     end
% else
%     xp=kron(ones(1,dw),x)';
%     xp=xp(:);
%     y=xp;
% end
