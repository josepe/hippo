function y=wnois(x)
% Y=WNOIS(X)
% generates a signal with the same number of trials as
% X, having the same mean and stdv as X (trial by trial)

[k,l]=size(x);
mx=mean(x);sx=std(x);
mxm=kron(ones(k,1),mx);
sxm=kron(ones(k,1),sx);
y=normrnd(mxm,sxm);