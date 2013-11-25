function out=SbandpassBW(in,band,order)
out=in;
s=size(in.data);
Fs = in.sampleFreq;  % Sampling Frequency

if nargin>2   % Set filter Order
    N   = order;
else
    N=8; 
end
    
Fc1 = band(1);  % First Cutoff Frequency
Fc2 = band(2);  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);

Hd = design(h, 'butter');

[b,a] = sos2tf(Hd.sosMatrix,Hd.ScaleValues);

out.data=reshape(filtfilt(b,a,in.data(:)),s(1),s(2));


% [EOF]
