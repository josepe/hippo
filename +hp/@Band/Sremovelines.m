function out=Sremovelines(in,freqs,Q)
import hp.*
out=in;
if nargin<3
    Q=45;
end
if ~isempty(freqs)
    wo=2*freqs(1)/in.sampleFreq;
    bw=wo/Q;
    [b,a] = iirnotch(wo,bw);
    out.data=filtfilt(b,a,out.data);
    freqs(1)=[];
    out=Band.removelines(out,freqs,Q);
end
end