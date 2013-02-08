function y=rand_samp_n(x,n);
% y=rand_samp_n(x,n);
% obtain a random set of sample trials from x


m=size(x,2);
randord=ceil(m*rand(1,n));

y=x(:,randord);