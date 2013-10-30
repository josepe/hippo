function out=Sbandpow(in,frange,frange2)
% compute power in frequency band frange relative to total power
import hp.*
out=in;
findex=Band.findex(in,frange);
findrange=findex(1):findex(2);
outstring1=['L' num2str(frange(1)) 'H' num2str(frange(2))];

if nargin ==3
    findex2=Band.findex(in,frange2);
    findrange2=findex2(1):findex2(2);
    outstring2=['L' num2str(frange2(1)) 'H' num2str(frange2(2))];
else
    findrange2=1:length(in.powspec);
    outstring2=['L' num2str(round(in.fvector(1))) 'H' num2str(round(in.fvector(end)))];
end
conc=sum(in.powspec(findrange))/sum(in.powspec(findrange2));
outstring=[outstring1 '_' outstring2];

out.powbands.(outstring)=conc;

end