function out=Scutpoints(in,tinitial,Npoints)
% out, estructura de datoa identica a in
% tiempo en segundos, tiempos truncados
% entre [cut(1) cut(2)]
% out.times vector tiempos en segundos, resoluci?n 1/sampleFreq
% out.t_events
% out.dataSamples datos
% out.sampleFreq
import hp.*
out=in;
indtinitial=interp1(in.tvector(:),(1:length(in.tvector(:)))',tinitial);
indtinitial=round(indtinitial);
out.tvector=in.tvector(indtinitial:indtinitial+Npoints-1);
out.data=in.data(:);
out.data=in.data(indtinitial:indtinitial+Npoints-1);
if ~isempty(in.tevents)
    out.tevents=in.tevents(out.tevents>=in.tvector(indtinitial)&out.tevents<=in.tvector(indtinitial+Npoints));
end
out.nrSamples=length(out.data);

end