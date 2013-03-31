function Splot_data(in,range)
import hp.*
%grafica datos y eventos en objeto in
if nargin <2
figure,plot(in.tvector(:),in.data(:)/(1.5*max(in.data(:))));
else
    ind=Band.index(in,range);
    indrange=ind(1):ind(2);
    figure,plot(in.tvector(indrange),in.data(indrange)/(1.5*max(in.data(:))));
end