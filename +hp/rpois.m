function y=rpois(lam,m,n);

% Y=RPOIS(LAM,M,N)
% GENERATES A M,N MATRIX OF POISSON 
% PROCESS WITH RATE LAM (AVERAGE NUMBER OF POINTS)
% PER COLUMN

ns=poissrnd(lam,n,1);
res=[];
for i=1:n
	poi=ransp(m,ns(i));
	res=[res;poi];
end
y=res';
