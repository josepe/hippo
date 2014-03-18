function Splot_data(in,range)
import hp.*
%grafica datos y eventos en objeto in
% if nargin <2
% figure,plot(in.tvector(:),in.data(:)/(1.5*max(in.data(:))));
% elseif nargin==2
%     ind=Band.index(in,range);
%     indrange=ind(1):ind(2);
%     figure,plot(in.tvector(indrange),in.data(indrange)/(1.5*max(in.data(:))));
% else
%     
% end
% if nargin >2
%     figure(hf);
%     hold on;
% else
%     figure;
% end
% 
% if nargin <2 | isempty(range)
% plot(in.tvector(:),in.data(:)/(1.5*max(in.data(:))));
% elseif nargin==2
%     ind=Band.index(in,range);
%     indrange=ind(1):ind(2);
%     plot(in.tvector(indrange),in.data(indrange)/(1.5*max(in.data(:))));
% else
%     Splot_data(in,range);
%  
% end

%grafica datos y eventos en objeto in
if nargin <2
%    in.pl=plot(in.tvector(:),in.data(:)/(1.5*max(in.data(:))));
     in.pl=plot(in.tvector(:),real(in.data(:)));
elseif nargin==2
    ind=in.index(range);
    indrange=ind(1):ind(2);
    in.pl=plot(in.tvector(indrange),real(in.data(indrange)));
else
    
end