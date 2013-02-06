function plot_events(in)

%grafica datos y eventos en objeto in

figure,plot(in.tvector,in.data/(1.5*max(in.data)));
hold;
plot(in.tevents,.5*ones(1,length(in.tevents)),'ro');
end