function plot_data(in)

%grafica datos y eventos en objeto in
figure,plot(in.tvector,in.data/(1.5*max(in.data)));
end