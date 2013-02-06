function [h t] = rand_phases_bandpass(W,Fs,T)
% h(t) = rand_phases_bandpass(W,Fs,leng) 
%   Generates W band limited signal
%   W=bandwidth (Hz)
%   Fs=sampling rate (points per sec)
%   T=duration (sec)
%Output
% h= W band-limited complex analytic signal

%frequency range

freqs=W(1):1/T:W(2);

phis=2*pi*rand(1,size(freqs,2));

t=0:1/Fs:T;
hk=zeros(size(freqs,2),size(t,2));
for k=1:size(freqs,2)
    hk(k,:)=exp(1i*(2*pi*freqs(k)*t+phis(k)));
end
h=sum(hk);