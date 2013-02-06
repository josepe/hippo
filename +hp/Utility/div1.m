function y=div1(x);
% reshapes x into 1 sec duration trials (@1kHz=1000points/sec)

[m,n]=size(x);
p=m*n;
q=reshape(x,1,p);
q=q(1:(p-mod(p,1000)));

y=reshape(q,1000,(p-mod(p,1000))/1000);

