function sdev=SadaptSdev(dat,Nsamples)
x=dat;
if nargin <2
    [me,st]=AdaptRecursive(x,length(x));
else
    [me(1:Nsamples),st(1:Nsamples)]=AdaptRecursive(x,Nsamples);
    sn=0;
    s2n=0;
    for i=Nsamples+1:length(x)
        
        sn=sn+x(i)-x(i-Nsamples);
        s2n=s2n+x(i)^2-x(i-Nsamples)^2;
        me(i)=sn/Nsamples;
        st(i)=sqrt((s2n-2*sn*me(i)*+me(i)^2)/Nsamples);
       
    end
end
sdev=[me;st]';
end

function [me,st]=AdaptRecursive(x,stop)
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