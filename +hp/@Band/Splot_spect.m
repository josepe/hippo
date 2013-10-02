function Splot_spect(in,lg)
import hp.*
%grafica datos y eventos en objeto in
if nargin <2
    pow=in.powspec(:);    
elseif lg=='l'
    pow=log(in.powspec(:));
elseif lg=='n'
    pow=in.powspec(:);
end
figure,plot(in.fvector(:),pow/(1.5*max(pow)));
end