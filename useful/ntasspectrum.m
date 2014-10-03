function [Full,baseline,background,fha,peaks] = ntasspectrum(AD,fldnm,wind,seglen,figs)
%NTASSPECTRUM - spectral analysis of NTAS current meter data	
% 
%USAGE - [Full,baseline,background,fha,peaks] =
% 			ntasspectrum(AD,fldnm,wind,seglen,figs,peakfname)
%
%EXPLANATION -	Draws pictures and returns matlab spectrum object for 
%			all frequency bands.
% 		AD - data structure
% 		fldnm - fieldname to do spectrum on
% 		wind - type of filtering window for spectral density estimator
% 		seglen - split time series into segments of seglen (default N/8)
% 		figs - boolean, plot or noplot [default plot (1)]
% 
% 		Full - spectrum object with result
% 		baseline - struct describing a line through the valleys of the
% 			log-log plot of the frequency vs psd
%  		background - level of instrument noise in the tail
% 		fha - handles to figures created
%
%SEE ALSO -	
% 	ntascompare, ntascheckmat
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-08-09 
% 
%	$Revision: 1.22 $
%	$Date: 2012-05-03 17:48:21 $
%	$Id: ntasspectrum.m,v 1.22 2012-05-03 17:48:21 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-04-19 
% 	confusion is inevitable with large data sets. carry around some
% 	meta data to mitigate the problem.
% 
% }}}

% License {{{
% -------
%
%     This program is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of
% the License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public
% License along with this program.  If not, see
% <http://www.gnu.org/licenses/>.
% 
% See accompanying script gpl-3.0.m
%
% }}}

% AD fldnm  wind seglen figs
%  AD 'Hann' [] 0 
bands=0; % do we plot all frequency bands or no
fn=0; % keep track of the figure numbers

if exist('AD')~=1, AD=[]; end;
if isempty(AD) || ~isstruct(AD),
	error('Provide a valid NTAS data structure');
end;

if ~isfield(AD,'spd'),
	AD.spd=abs(1i.*AD.north+AD.east);
end;
% % AD.dir=90-rad2deg(angle(AD.east+1i.*AD.north));
% %       ........  or  ........
if ~isfield(AD,'dir'),
	AD.dir=rad2deg(angle(AD.north+1i.*AD.east));
end;

% if exist('peakfname')~=1, peakfname=[]; end;

if exist('figs')~=1, figs=[]; end;
% we'll set figs later if it is empty

if exist('seglen')~=1, seglen=[]; end;
% we'll set seglen later if it is empty

if exist('wind')~=1, wind=[]; end;

if exist('fldnm')~=1, fldnm=[]; end;
if isempty(fldnm), 
	fldnm='spd';
	if ~isfield(AD,fldnm)
		error('No fieldname supplied and default fieldname (spd) not found');
	end
else
	if ~isfield(AD,fldnm),
		% peakfname=figs;
		figs=seglen; 
		seglen=wind;
		wind=fldnm; 
		fldnm='spd';
	end;
end;

% we can deal only with vectors: if you have a matrix, make your own loop
% outside this function
if ~any(size(AD.(fldnm))==1), error('Call for 1xN matrix only'); end

if isempty(wind), wind='Hann'; end;

if isempty(figs), figs=1; end;


% figs, seglen, wind, fldnm

% 
% % be sure our data are clean and trimmed 
% VM=clipstruct(VM,'yday',[64.0, 412.46 ]);
% AD=clipstruct(AD,'yday',[64.0, 412.46 ]);
% % there is a glotch in the VM timebase. What to do? Throw it
% % away.

% K=find(diff(VM.yday)==0);
% if ~isempty(K),
% 	[m,n]=size(VM.yday);
% 	fn=fieldnames(VM); 
% 	for i=1:length(fn), 
% 		if all(size(VM.(fn{i}))==[m,n]),
% 			if m>n,
% 				VM.(fn{i})(K+1,:)=[];
% 			else
% 				VM.(fn{i})(:,K+1)=[];
% 			end;
% 		end;
% 	end;
% end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Spectral Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Looking at the spectra: sampling frequency (per day)
dt=mode(diff(AD.yday));
ADf=1./dt; % once per hour

% series must be regular
II=find(isfinite(AD.(fldnm)));

t=min(AD.yday):dt:max(AD.yday); 
Y=interp1(AD.yday(II),AD.(fldnm)(II),t);
I=find(~isfinite(Y));
Y(I)=[]; t(I)=[];

% ADfh=ADf./24;
ADfh=ADf;
units='day^{-1}';

% 
% h=spectrum.periodogram;
%
% Welch spectral estimator, with Hamming window, eight segments with
% 50% overlap.
% (Welch: splits data into segments and averages spectrum of the
% segments)
if isempty(seglen), seglen=floor(length(AD.yday)./8); end;
% h=spectrum.welch('hamming',seglen,50);
h=spectrum.welch(wind,seglen,50);
Hopts=psdopts(h);

% plot the psd (Power Spectral Density) 
% stationary by taking the diff (removes mean and trend)
% figure; subplot(1,2,1); psd(h,diff(VM.spd),'Fs',VMf); subplot(1,2,2); psd(h,diff(AD.spd),'Fs',ADf);

Hopts.SpectrumType='Onesided';
% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pvm=psd(h,VM.spd,Hopts);

Hopts.Fs=ADfh;
Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;

% keyboard

Pad=psd(h,Y,Hopts);

[fpeaks,pkhgt,p,minos,background]=spectralpeaks(Pad); 
baseline=struct('poly',p,'offset',minos);

peaks=struct('f',fpeaks,'dens',pkhgt,'depth',AD.depth);

% add identifying information to baseline structure.
% too very complicated to extend Pad with meta data so leave it alone,
% although I would have liked to attach information like experiment and
% serial number to it.
Full=Pad;

metafields={'experiment', 'position', 'longitude', 'latitude', ...
	'Position', 'meta', 'instrument', 'lat', 'lon', 'year', ...
	'depth'};

for j=1:length(metafields)
	if isfield(AD,metafields{j})
		baseline.(metafields{j})=AD.(metafields{j});
		peaks.(metafields{j})=AD.(metafields{j});
	end
end

% All spectrum

if figs,

    y=Pad.Data;

    fn=fn+1; fha(fn)=figure; % Peak distribution
    	qqplot(log10(pkhgt));
    	ylabel('Quantiles of log(PSD)');
    	title('QQ Plot of Peak PSD');
    	
    fn=fn+1; fha(fn)=figure; 
	h0=loglog(Pad.Frequencies,y); hold on;
	set(gca,'xgrid','on','xminorgrid','off', ...
		'ygrid','on','yminorgrid','off');
	% logCI=minmax(log10(Pad.ConfInterval)-log10([Pad.Data,Pad.Data]));
	% axis('tight');
	ax=axis;
	% plot the ci at 1/10 of the axis length from the origin
	% barX=10.^(log10(ax(1))+(log10(ax(2))-log10(ax(1)))./2); 
	% barY=10.^(log10(ax(3))+(log10(ax(4))-log10(ax(3))).*9./10+[logCI(1),0,logCI(2)]);
	% plot([barX,barX,barX],barY,'r','linewidth',3);
	% plot(barX,barY(2),'r+','linewidth',3);
	% plot(barX,barY(2),'r+');
	H=myerrorbar(Pad,[0.5 0.8],ax,'r');

	% CI
	baseln=log10(ax(1:2));
	% plot(10.^baseln,10.^(polyval(p,baseln)),'r:','linewidth',3);
	h1=plot(10.^baseln,10.^(polyval(p,baseln)+minos),'g-.','linewidth',3);
	
	% label the obvious stuff
	% IF=2.*pi./sw_f(AD.lat)./24./60./60;
	% K1=1./0.0417807./24;
	% M2=1./0.0805114./24;
	% arrows=[IF K1 M2]; 
	% plot([arrows;arrows] , 10.^[4 4 4; 3.5 3.5 3.5],'g','linewidth',3);


	% instrument noise background
	h2=plot(10.^baseln,10.^[background,background],'g','linewidth',3);

	% make a legend with the regression line and background
	% on it
	legend([h0,h1,h2],...
		{	...
		[ 'Spectrum at ' num2str(AD.depth) ' m'], ...
		['y = 10^{' num2str(p(1)) ' log(x) + ' ...
			num2str(p(2)+minos) '}'], ...
		['bg = 10^{' num2str(background) '} = ' ...
			num2str(10.^background) ]}, ...
			'location','southwest');

	ylabel('Power Spectral Density (cm^2.s^{-2})')
	xlabel(['Frequency (' units ')']);
	title('Full Frequency');

end;

% stop now
% return;

% High Frequency part

if figs,
   fn=fn+1; fha(fn)=figure; 
	% ax=[0,75,0,1.2];
	% ax=[0,5,0,1.2];
	
	% subplot(2,1,1);
	% x=1./Pvm.Frequencies;
	% Fmax=max(Pvm.Data(x>=12 & x<=13));
	% y=Pvm.Data./Fmax;
	% ci=Pvm.ConfInterval./Fmax;
	% plot(x,y); hold on;
	% % plot(x,ci,'r');
	% axis(ax);
	% title('VMCM Power Spectral Density')
	% % ylabel(regexprep(get(get(gca,'ylabel'),'string'),'Hz','hr^{-1}'));
	% % xlabel(regexprep(get(get(gca,'xlabel'),'string'),'Hz','hr^{-1}'));
	% ylabel('Relative PSD');
	% xlabel('Period (hour)');

	% subplot(2,1,2);
	x=1./Pad.Frequencies;
	Fmax=max(Pad.Data(x>=12./24 & x<=13./24));
	y=Pad.Data;
	% y=Pad.Data./Fmax;
	I=find(x<=5);
	% ci=Pad.ConfInterval./Fmax;
	plot(x(I),y(I)); hold on; 
	% plot(x,ci,'r');
	bl=10.^(polyval(p,Pad.Frequencies)+minos);
	h1=plot(x(I),bl(I),'g-.','linewidth',3);
	h2=plot(x(I),10.^[repmat(background,size(x(I)))],'g','linewidth',3);
	% axis(ax);
	title('High Frequency Band')
	ylabel('Power Spectral Density (cm^2.s^{-2})');
	xlabel('Period (day)');

end;

% we are going to skip to plot the inertial, diurnal and semi-diurnal 
% bands
if bands,
% 
%  _____ ____    _            __     ___  
% |___ /| ___|  | |_  ___    / /_   / _ \ 
%   |_ \|___ \  | __|/ _ \  | '_ \ | | | |
%  ___) |___) | | |_| (_) | | (_) || |_| |
% |____/|____/   \__|\___/   \___/  \___/ 
%                                         

% still with spectrum.welch
% h=spectrum.welch(wind,seglen,50);
% change that to get better resolution (maybe?)
% h=spectrum.welch(wind,floor(length(AD.yday)./2),50);

Hopts.SpectrumType='Twosided';

% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pvm=psd(h,VM.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[35:0.05:60]); 

Hopts.Fs=ADfh./24; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
Pad=psd(h,Y,Hopts, ...
	'FreqPoints','User Defined','FrequencyVector',1./[35:0.05:60]);
% Pad=msspectrum(h,AD.spd,Hopts, ...
% 	'FreqPoints','User Defined','FrequencyVector',1./[35:0.05:60]);

Inertial=Pad;

if figs, 
   fn=fn+1; fha(fn)=figure; 
	x=1./Pad.Frequencies;
	y=Pad.Data;
	% z=Pad.ConfInterval;
	han(1)=plot(x,y,'b'); hold on;
	% han(2:3)=plot(x,z,'r'); hold on;
	
	% x=1./Pvm.Frequencies;
	% y=Pvm.Data;
	% han(2)=plot(x,y); hold on;
	ylabel('Power Spectral Density (cm^2.s^{-2})')
	xlabel('Period (hour)');
	% legend(han,{'Aquadopp','VMCM'});
	title('Inertial Band');

end;

% return;
% 
% 
%  ____   _____   _           ____   ____  
% |___ \ |___ /  | |_  ___   |___ \ | ___| 
%   __) |  |_ \  | __|/ _ \    __) ||___ \ 
%  / __/  ___) | | |_| (_) |  / __/  ___) |
% |_____||____/   \__|\___/  |_____||____/ 
%                                          


% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pvm=psd(h,VM.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[23:0.005:25]); 

Hopts.Fs=ADfh./24; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
Pad=psd(h,Y,Hopts, ...
	'FreqPoints','User Defined','FrequencyVector',1./[23:0.01:25]);

Diurnal=Pad;

if figs,
    fn=fn+1; fha(fn)=figure; 
	x=1./Pad.Frequencies;
	y=Pad.Data;
	han(1)=plot(x,y,'b'); hold on;
	% x=1./Pvm.Frequencies;
	% y=Pvm.Data;
	% han(2)=plot(x,y); hold on;
	ylabel('Power Spectral Density (cm^2.s^{-2})')
	xlabel('Period (hour)');
	title('Diurnal Tide');
	% legend(han,{'Aquadopp','VMCM'});

end;
% 
%  _  _     ____    _           _  _____    ____  
% / |/ |   | ___|  | |_  ___   / ||___ /   | ___| 
% | || |   |___ \  | __|/ _ \  | |  |_ \   |___ \ 
% | || | _  ___) | | |_| (_) | | | ___) |_  ___) |
% |_||_|(_)|____/   \__|\___/  |_||____/(_)|____/ 
%                                                 

% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pvm=psd(h,VM.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[11.5:0.001:13.5]); 

Hopts.Fs=ADfh./24; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
Pad=psd(h,Y,Hopts, ...
	'FreqPoints','User Defined','FrequencyVector',1./[11.5:0.001:13.5]);

Semidiurnal=Pad;

if figs,
    fn=fn+1; fha(fn)=figure; 
	x=1./Pad.Frequencies;
	y=Pad.Data;
	han(1)=plot(x,y,'b'); hold on;
	% x=1./Pvm.Frequencies;
	% y=Pvm.Data;
	% han(2)=plot(x,y); hold on; 
	ylabel('Power Spectral Density (cm^2.s^{-2})')
	xlabel('Period (hour)');
	% legend(han,{'Aquadopp','VMCM'});
	title('Semidiurnal Tide');

end;
% figure; subplot(2,1,1); psd(h,diff(VM.spd),'Fs',VMf,'ConfLevel',0.9);
% 	subplot(2,1,2); psd(h,diff(AD.spd),'Fs',ADf,'ConfLevel',0.9); 

% plotting speeds against speeds

% figure; qqplot(VM.spd,AD.spd)
	% xlabel('Quantiles of VMCM speeds');
	% ylabel('Quantiles of Aquadopp speeds');


% extract data at the same time bases (reduce to aquadopp
% sampling frequency)
% VMCM has the higher sampling frequency

% X=interp1(VM.yday,VM.spd,AD.yday);

% f(1)=figure;
	% plot(X,AD.spd,'.');
	% hold on;
	% xlabel('v_{VMCM}');
	% ylabel('v_{Aquadopp}');


% f(2)=figure; plot(X,X-AD.spd,'.')
	% xlabel('v_{VMCM}');
	% ylabel('v_{VMCM}-v_{Aquadopp}');

% for directions, interpolate on an unwrapped series
% Y=wrapTo180(interp1(VM.yday,unwrapd(VM.dir),AD.yday));

% f(3)=figure; plot(Y,wrapTo180(AD.dir),'.');
	% xlabel('VMCM direction');
	% ylabel('Aquadopp direction');
% 
% f(4)=figure; plot(Y,Y-wrapTo180(AD.dir),'.');
	% xlabel('VMCM direction');
	% ylabel('VMCM-Aquadopp direction');

% find 10th percentile, exclude amount below from regression
% (assumption that low velocities lead to great error in the
% direction.

% cutoff_lo=prctile(X,25);
% cutoff_hi=prctile(X,75);
% 
% K=find(X>cutoff_hi);
% J=find(X>cutoff_lo);
% figure(f(1));
	% hold on;
	% plot(X(J),AD.spd(J),'r.');
	% plot(X(K),AD.spd(K),'g.');
	% xlabel('v_{VMCM}');
	% ylabel('v_{Aquadopp}');

	% [P,S]=polyfit(X,AD.spd,1);
	% x=minmax(X); 
	% plot(x,polyval(P,x),'k','linewidth',2');

	% [A,B,C]=tlsr(X.',AD.spd.'); 
% tlsr returns [slope,inter] in A, polyval expects [inter,slope]
	% plot(x,polyval(fliplr(A),x),'y','linewidth',2)


% figure(f(3));
	% hold on;
	% plot(Y(J),wrapTo180(AD.dir(J)),'r.');
	% plot(Y(K),wrapTo180(AD.dir(K)),'g.');
	% % xlabel('VMCM direction');
	% % ylabel('VMCM-Aquadopp direction');
% 
% figure(f(4));
	% hold on;
	% plot(Y(J),Y(J)-wrapTo180(AD.dir(J)),'r.');
	% plot(Y(K),Y(K)-wrapTo180(AD.dir(K)),'g.');
	% % xlabel('VMCM direction');
	% % ylabel('VMCM-Aquadopp direction');
% 

end; % if bands,

return;
end

