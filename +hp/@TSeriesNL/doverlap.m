function y=doverlap(x,dw,wl)
% Y=DOVERLAP(X,DW,WL)
% Divides input vector data into an array of overlapping windows
% X input vector (COLUMN VECTOR)
% DW distance between initial index of overlapping windows
% WL length of analyzing window
% Y output array

Nx=length(x);
Nw=floor((Nx-wl)/dw);
y=[];
for i=1:Nw
    index=(i-1)*dw +1;
    % new addition: multiply by hanning window
    if nargin > 3
        y=[y x(index:index+wl-1).*hanning(wl)];
    else
        y=[y x(index:index+wl-1)];
    end
end