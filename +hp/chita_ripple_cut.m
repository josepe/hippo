function out=chita_ripple_cut(in,cut)
% out, estructura de datoa identica a in
% tiempo en segundos, tiempos truncados
% entre [cut(1) cut(2)]
% out.times vector tiempos en segundos, resoluci?n 1/sampleFreq
% out.t_events
% out.dataSamples datos
% out.sampleFreq

out=in;
indices=interp1(in.times,1:length(in.times),cut);
ind=round(indices);
out.times=in.times(ind(1):ind(2));
out.dataSamples=in.dataSamples(ind(1):ind(2));
out.t_events=in.t_events(out.t_events>=cut(1)&out.t_events<=cut(2));