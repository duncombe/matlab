function [a0,a,b,psd,f] = fourier(signal,window,dt)
% FOURIER      Calculates real Fourier coefficients for a series
%              (length N) using the discrete Fourier transform.
%              NOTE: Performance is distinctly improved when N is odd.
%              
% USAGE        [A0,A,B,PSD,F] = FOURIER(SIGNAL,[WINDOW],DT)
%              or [A,B,PSD,F] = FOURIER(SIGNAL,[WINDOW],DT)
%
%               SIGNAL: signal to be transformed
%               DT: sampling period of data. e.g. 1 second, 2 hours, etc.
%                   (*period*, not frequency!)
%               (note that Fs,the sampling frequency == 1/dt)
%                   
%               A0: mean of data
%               A:  cosine coefficients
%               B:  sine coefficients
%               PSD: Power spectral density.  Units are signal
%               units^2 per frequency.  E.g. if f is given in
%               cycles per day and signal is in cm, PSD units are
%               cm^2 day.
% 
%               with N being the number of components in the transform
%               and df == fs/N, we have sum(PSD.*df) == var(SIGNAL)
%
%               Plot semilogx(f,Psd*f) for the variance-preserving spectrum
%
%               F: resolved frequencies of yr data (to Nyquist = 1/(2*dt)
%                  F will come out in the inverse units of what you use
%                  for DT, e.g. 1/s, 1/day, 1/hr.
%               
%
% To recreate original signal (where N is length of data);
% j = (1:(N/2))'; % for odd N 
% j = (1:(N/2)-1)'; % for even N
%
% for k = 1:N,
%   signal(k) = a0 + ...
%   sum(a.*cos(2*pi*j*((k-1)*dt)/(N*dt)) - b.*sin(2*pi*j*((k-1)*dt)/(N*dt)));
% end
%
% % ***or***
%
% phase = angle(a+b*i);
% Amp = a./cos(phase);
%
% for k = 1:N
%   signal(k) = sum(Amp.*cos(2*pi*j*((k-1)*dt)/(N*dt) + phase));
% end
%
% To synthesize a single frequency component of the original signal:
% frq = 10;
%for k = 1:N
%  component(k) = a(frq).*cos(2*pi*j(frq)*((k-1)*dt)/(N*dt)) - ...
%      b(frq).*sin(2*pi*j(frq)*((k-1)*dt)/(N*dt));
%end
%
% You also might want to bear in mind the Euler relation, 
% implicit in all of the Matlab fourier routines:
%                  exp(iwt) = cos(wt) + i*sin(wt)
%
% SEE ALSO fft, fftdemo
%
% Deirdre Byrne, L-DEO 1/1/96

if (nargin ~= 2) & (nargin ~= 3)
  disp('Usage: fourier(signal,dt) OR fourier(signal,window,dt)')
  return
end

s = size(signal);
tr = 0;
if any(s == 1), N = max(s);
  if N == s(2), signal = signal'; tr = 1; end
else
  N = s(1);
end

if nargin == 3
  % normalize window
  window = window./sum(window);
  % apply to signal
  if size(signal,2) > 1
    for i = 1:size(signal,2)
      signal(:,i) = signal(:,i).*window;
    end
  else
    signal = signal.*window;
  end
  % calculate magnitude
  mag = 1./sum(window.^2);
else
  dt = window;
  window = [];
  mag = 1;
end

a = fft(signal,N);
% rescale coefficients to original units:
a = 2.*a./N;
a0 = a(1,:)./2; if abs(a0) < eps; a0 = 0; end

% now get the frequencies of the components
fs = 1/dt; % the sampling frequency
df = fs/N; % the resolution of the transform
if rem(N,2) == 0 % N is even
  a = a(2:N/2,:); b = imag(a); a = real(a);
  f=df*(1:N/2-1); % df * (1:N/2-1).
else % N is odd
  a = a(2:(N+1)/2,:); b = imag(a); a = real(a);
  f=df*(1:(N-1)/2); % df * (1:(N-1)/2).
end
f = f(:);

% rescale
a = a*sqrt(mag);
b = b*sqrt(mag);

if nargout == 4
  f = [0; f];
  a = [a0/2; a];
  b = [a0/2; b];
end

% The Power spectral density of the fft is:
psd = 1/2 * mag * [a.^2+b.^2]./df;
% such that sum(psd.*df) == var(signal);
% the factor of 1/2 is because the sum of a.^2+b.2
% actually scales with the COVARIANCE (2*variance).
%
% Actually, this has the effect of scaling the PSD by
% the square of the magnitude (where mag = 1./sum(window.^2)),
% since the magnitude is already included in a^2+b^2.
% So I feel it may not be stricty correct to multiply it through
% again, but this is exactly how Matlab's other programs
% scale the PSD.

% Note that using the Matlab PSD function pmtm, similarly
% sum(Pxx(2:end).*dF) == var(signal),
% while sqrt(Pxx(1))% = k*mean(SIGNAL)
%
% To obtain identical results from pmtm, use nw=0 BUT make
% sure to use 'unity' weighting.

if tr % transpose to orig orientation
  a = a'; b = b'; f = f'; psd = psd';
end

if nargout == 4
  a0 = a; a = b; b = psd; psd = f;
end

if nargout == 2;
  a0 = psd;
  a = f;
end
