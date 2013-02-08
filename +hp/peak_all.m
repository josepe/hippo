function y=peak_all(x)
% Y=PEAK_ALL(X)
% finds time positions of all peak values in x
% detects true peaks, not just maximum values
% see also
% peak

df=diff(x);
f=df(1:length(df)-1).*df(2:length(df));
y1=find(f<0)+1;
y2=find(x(y1)>x(y1-1));
if isempty(y2)
   y=[];
else
y=y1(y2);
end