function [spectry_out,freq]=myspec(yy,delt,M,title1);
%MYSPEC - computes a spectrum of data yy(t), t=1,N, where N is a power of 2,
% 
%	Phase convention: the phase angle is positive when the
%	2nd time series leads.
% 
%USAGE -	[spectry_out,freq]=myspec(yy,delt,M,title1);
%
%EXPLANATION -	
% 	yy - time series of data of length N, N is a power of 2 
% 		N is computed from the size of yhat using fft.
% 	delt - sampling interval
% 	M - size of window (M is window width--Daniell. delt must also be specified.)
% 	title1 - title for the plots
%
%SEE ALSO -	
%
%CREATED -	obtained coher.m from Tom Farrar 2011/02/10 
%		Originally from Carl Wunsch, 1987
% 
%	$Revision: 1.7 $
%	$Date: 2011-10-27 15:27:37 $
%	$Id: myspec.m,v 1.7 2011-10-27 15:27:37 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% Title arguments added 6-9-01 (JTF)
% Modifications 1-18-02 by Tom Farrar, tomf@mit.edu.
% Added 'scale' term to modify frequency scale for plots.  Labels must be 
%           changed manually!
% Modified to remove mean BEFORE tapering input time series (3-10-06).
% This is important to avoid spurious low freq energy.
%  2011-09-10  CMDR
% 	modified from coher.m to produce a spectrum for one time series
%
% 

% test the arguments 
if exist('title1')~=1, title1=[]; end;
if isempty(title1), title1='Plot Title'; end;

if exist('delt')~=1, delt=[]; end;
if isempty(delt), delt=1; end;

% set a default window width dependent on the length of the timeseries
if exist('M')~=1, M=[]; end;
if isempty(M), M=floor(length(yy)./4); end;

% ensure the first argument a column vector
yy1=yy(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scale=1;%number timesteps per time unit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up some stuff for confidence intervals
%   plot confidence intervals on spectrum plots as in Wunsch's 
%      "Time Series Analysis.  A Heuristic Primer.", 2000, eqn 10.70 
%      "Time Series Analysis.  A Heuristic Primer.", 2010, eqn 11.76
% spot is the x-coordinate of errorbar plot 
% spot=1./2.87;%10;%10^-7;%24/12.42;%24./18.2414;%1/2.87;%10^0;
nu=2.*M;
[low,up]=confid(0.05,nu); %won't work w/o optimization toolbox
%

% remove the mean 
yy1=yy1-mean(yy1);

% split the data into sections
% [n,m]=size(y,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This part does the work
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate a taper window. Taper the whole TS
L=length(yy1);
L10=fix(L./5);
wind=ones(L,1);
wind(1:L10,1)=1-cos([1:L10].'.*pi/(2.*L10));
wind(L:-1:L-L10+1,1)=wind(1:L10,1);

y=yy1.*wind;
avgy=mean(y);

N=length(y);
yhat=fft(y)./(N./2); 
% N=length(yhat);
% yhat=yhat./(N./2);

% normalization is such that amplitude of a unit sine wave =1 in ft.
% not corrected for taper energy loss.
window=ones(M,1);

% 
periody=yhat.*conj(yhat);

% Convolve (multiply as polynomials) the window and fft
% and normalize by
% dividing values by width of the averaging interval to get spectral density
% in units of cycles/delta t
% effect of convolving with window of ones is a running average
specty=conv(window,periody)./(M./(delt.*N));

%now decimate, discarding 1/2 the fft and spectrum by symmetry
s=M:M:N./2;
s1=length(s);
spectry=specty(s);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set up frequency  scale
df = 1./(N.*delt);
freq=df.*( ([1:s1]-1).*M + (M-1)./2).';

period=1./freq;

%now plot log log
figure;

	loglog(freq.*scale,spectry);
	grid
	hold on;
	axis tight; grid on;%JTF
%JTF
	lowyy=var(y).*low;
	upyy=var(y).*up;

	ax=axis;
	spot=10.^(log10(ax(1))+(log10(ax(2))-log10(ax(1)))./10);

	loglog([spot spot], [lowyy,upyy],'r','linewidth',3);
	% hold off; 
	xlabel('FREQUENCY (cpd)'),ylabel('POWER DEN');
	title(title1);

	hold on;	%JTF

% format short e
% disp(' NUMBER    FREQ.    PERIOD    POWERY     POWERZ     COHERENCE AMP.     & PHASE')
% [num,freq,period,spectry,spectrz,coheramp,coherpha];


% disp('note to convert to power, use delfreq, not freq(1)')
% disp('power computed will be 2*the meansquare.')
format short;axis;

spectry_out=spectry;
% spectrz_out=spectrz;
% coheramp_out=coheramp;
% coherpha_out=coherpha;
% return;



%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   % Level of no significance for coherence plots
%%%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   % coheramp_data=coheramp;
%%%    % num=100;
%%%    % level=95;
%%%   % out_n=zeros(num,1);
%%%   % for ind=1:num
%%%   % yy=randn(size(yy));%replace yy with white noise
%%%   % yy1=yy(:);zz1=zz(:);
%%%   
%%%        clear periody;%clear freq;
%%%        clear specty;clear spectz;clear cohyz;
%%%   
%%%   
%%%   %generate a taper window
%%%     L=length(yy1);
%%%     L10=fix(L/10);
%%%     wind=ones(L,1);
%%%     wind(1:L10,1)=1-cos([1:L10]'*pi/(2*L10));
%%%     wind(L:-1:L-L10+1,1)=wind(1:L10,1);
%%%     y=yy1.*wind;
%%%     % z=zz1.*wind;
%%%   avgy=mean(y);
%%%   % avgz=mean(z);
%%%   y=y-avgy;
%%%   % z=z-avgz;
%%%   yhat=fft(y);
%%%   % zhat=fft(z);
%%%   N=length(yhat);
%%%   yhat=yhat/(N/2);
%%%   % zhat=zhat/(N/2);
%%%   %normalization is such that amplitude of a unit sine wave =1 in ft.
%%%   %not corrected for taper energy loss.
%%%   window=ones(M,1);
%%%   periody=yhat.*conj(yhat);
%%%   % periodz=zhat.*conj(zhat);
%%%   % perioyz=yhat.*conj(zhat);
%%%   specty=conv(window,periody);
%%%   % spectz=conv(window,periodz);
%%%   % cohyz=conv(window,perioyz);
%%%   %divide values by width of the averaging interval to get spectral density
%%%   % in units of cycles/delta t
%%%   specty=specty/(M/(delt*N));
%%%   % spectz=spectz/(M/(delt*N));
%%%   % cohyz=cohyz/(M/(delt*N));
%%%   %now decimate
%%%   s=M:M:N/2;
%%%   s1=length(s);
%%%   spectry=specty(s);
%%%   % spectrz=spectz(s);
%%%   % coheryz=cohyz(s)./sqrt(spectry.*spectrz);
%%%   %discarding 1/2 the fft and spectrum by symmetry
%%%   % coheramp= abs(coheryz);
%%%   % coherpha=angle(coheryz)*180/pi;
%%%   
%%%   
%%%   
%%%    
%%%    % amp=sort(coheramp);
%%%    
%%%    % top5=amp(round(level*.01*end):end);
%%%    % out_n(ind)=top5(1);
%%%    
%%%   % end
%%%    
%%%   % noconfid=mean(out_n); 
%%%   % hold on
%%%   % subplot(223), semilogx([freq*scale freq*scale],[coheramp_data noconfid.*ones(size(period))]),axis tight, ax=axis;axis([ax(1),ax(2),0,1]);
%%%   % xlabel('FREQUENCY (cpd)'),ylabel('COH AMPL.');
%%%   % grid on
%%%   % hold off
%%%   
%%%   % coheramp=coheramp_data+i.*noconfid.*ones(size(period));
%%%   
