function y=win(x);
%returns data in x windowed on a hanning window.

[n m]=size(x);
y=[];
for i=1:m
w=x(:,i).*(hanning(n));
y=[y w];
end
