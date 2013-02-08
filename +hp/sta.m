function z=sta(x,y)
% Z=STA(X,Y)
% computes the spike triggered average between spike
% trains in X and signal in Y, using convolution

[m,n]=size(x);
[k,l]=size(y);
if (n~=l)
	error('trial number must be the same');
else
	z=[];
	for i=1:n;
		cv=conv(x(:,i),y(:,i));
		z=[z cv];
	end
end
