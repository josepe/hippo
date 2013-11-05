function out=SadaptEnv(in,Nsamples)
out=in;
x=abs(out.data);
if nargin <2
    env=AdaptRecursiveEnv(x,length(x));
else
    env(1:Nsamples)=AdaptRecursive(x,Nsamples);
    =0;
    for i=Nsamples+1:length(x)
        
        sn=sn+x(i)-x(i-Nsamples);
        me(i)=sn/Nsamples;
        st(i)=sqrt((s2n-2*sn*me(i)*+me(i)^2)/Nsamples);
        
        
    end
end
out.adaptsdev=[me;st];
end

function [me,st]=AdaptRecursiveEnv(x,stop)
me=zeros(1,stop);
st=me;
me(1)=x(1);
st(1)=0;
s2j=0;
for j=2:stop
    me(j)=(j/j-1)*me(j-1)+x(j)/j;
    s2j=s2j+me(j-1)^2-me(j)^2+(x(j)^2-s2j-me(j-1)^2)/n;
    st(j)=sqrt(s2j);
end
end
    