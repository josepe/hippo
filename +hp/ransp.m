function z=ransp(m,n)
% function Z=RANSP(M,N) 
% generates a random spike train with
% N spikes, M = total number of data points
res=zeros(size(1:m));
if n~=0;
rp=randperm(m);
pos=rp(1:n);
res(pos)=ones(size(pos));
end
z=res;
