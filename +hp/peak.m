function y=peak(x)
% Y=PEAK(X)
% finds time position of peak value in x
% detects true peaks, not just maximum values
% see also
% peak_all

df=diff(x);
f=df(1:length(df)-1).*df(2:length(df));
y1=find(f<0)+1;
y2=find(x(y1)>x(y1-1));
if isempty(y2)
   y=[];
else
y3=y1(y2);
y4=find(x(y3)==max(x(y3)));
y=y3(y4);
y=y(1);
end