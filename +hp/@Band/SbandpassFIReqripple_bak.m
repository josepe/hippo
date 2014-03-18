function out = SbandpassFIReqripple(in,Flow,Fhigh,order)
%SBANDPASSFIREQRIPPLE Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.9 and the Signal Processing Toolbox 6.12.
%
% Generated on: 02-Nov-2013 20:10:57
%

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.

out=in;
s=size(in.data);
Fs = in.sampleFreq;  % Sampling Frequency

N      = order;   % Order
Fstop1 = Flow(1);   % First Stopband Frequency
Fpass1 = Flow(2);  % First Passband Frequency
Fpass2 = Fhigh(1);  % Second Passband Frequency
Fstop2 = Fhigh(2);  % Second Stopband Frequency
Wstop1 = 1;    % First Stopband Weight
Wpass  = 1;    % Passband Weight
Wstop2 = 1;    % Second Stopband Weight
dens   = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 0 1 1 0 ...
    0], [Wstop1 Wpass Wstop2], {dens});
% Hd = dfilt.dffir(b);
% 
% 
%[b,a] = sos2tf(Hd.sosMatrix,Hd.ScaleValues);

out.data=reshape(filtfilt(b,1,in.data(:)),s(1),s(2));
end


% [EOF]