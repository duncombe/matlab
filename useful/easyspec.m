function [s,f]=easyspec(x,fs)
%EASYSPEC Easy plot of spectrum estimate
%         S=EASYSPEC(X) will return a spectrum vector of
%         X. [S,F]=EASYSPEC(X,FS) will also return a freuqency
%         axis in F, while the sample frequency is given in FS.
%         EASYSPEC(X) and EASYSPEC(X,FS), will plot the spectrum
%         and return the S vector in MATLAB's "ans".
%         Notes:
%         1. Spectrum values are in dB.
%         2. The frequency domain goes from DC to the Nyquist 
%            frequency. The "mirror part" of the spectrum is
%            omitted.
%         3. The sample segments, from which the spectrum is
%            calculated are picked by random. The function might
%            return significantly different results each time it's
%            called to if X isn't stationary.
%         4. EASYSPEC uses a hanning window and zero-pads by a
%            factor of 4. The spectrum vector will look smooth.

% Eli Billauer, 17.1.01 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.

if nargin==0
  error('No input vector given');
end

if (nargin==1)
  fs=2;
end

NFFT=16384; NWIN=NFFT/4;
LOOP=100;
win=hanning(NWIN)';

x=x(:)'*(17.127/NFFT/sqrt(LOOP));
n=length(x);
maxshift=n-NWIN;

if (n<2*NWIN)
  error(['Input vector should be at least of length '...
      num2str(2*NWIN)]);
end

s=zeros(1,NFFT);

for i=1:LOOP
  zuz=floor(rand*maxshift);
  s=s+abs(fft([win.*x(1+zuz:NWIN+zuz) zeros(1,NFFT-NWIN)])).^2;
end

s=10*log10(s(1:NFFT/2));
f=linspace(0,fs/2,NFFT/2);

if nargout==0
  hold off;
  plot(f,s);
  ylabel('Power Spectrum [dB]');
  xlabel('Frequency');
	grid on; zoom on;  
end

