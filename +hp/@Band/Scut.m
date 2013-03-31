function out=Scut(in,cut)
% out, estructura de datoa identica a in
% tiempo en segundos, tiempos truncados
% entre [cut(1) cut(2)]
% out.times vector tiempos en segundos, resoluci?n 1/sampleFreq
% out.t_events
% out.dataSamples datos
% out.sampleFreq
import hp.*
out=in;
indices=interp1(in.tvector(:),(1:length(in.tvector(:)))',cut);
ind=round(indices);
out.tvector=in.tvector(:);
out.tvector=in.tvector(ind(1):ind(2));
out.data=in.data(:);
out.data=in.data(ind(1):ind(2));
if ~isempty(in.tevents)
    out.tevents=in.tevents(out.tevents>=cut(1)&out.tevents<=cut(2));
end
out.nrSamples=length(out.data);

end