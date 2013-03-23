function out = highpassBW8(in,stop)

out=in;
%HIGHPASSBW8 Returns a discrete-time filter object.

%
% M-File generated by MATLAB(R) 7.9 and the Signal Processing Toolbox 6.12.
%
% Generated on: 22-Mar-2013 18:07:49
%

% Butterworth Highpass filter designed using FDESIGN.HIGHPASS.

% All frequency values are in Hz.


Fs = in.sampleFreq;  % Sampling Frequency

N  = 8;    % Order
Fc = stop;  % Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.highpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter');
out.data=filter(Hd,in.data);

% [EOF]
