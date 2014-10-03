function  ntascompare(VMin,ADin,labels,overlap)	% {{{
%NTASCOMPARE - 	compare two current meter records
% 
%USAGE -	ntascompare(VMin,ADin,labels,overlap)	
%
%EXPLANATION -	VMin - First series structure
% 		ADin - Second series structure
% 		labels - cell of labels for the two series
% 		overlap - compare only over the time that the
% 			series overlap (default) or compare only
% 			the spectra.
% 			
%
%SEE ALSO -	ntasdatacompare
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-08-09 
%	$Revision: 1.9 $
%	$Date: 2012-07-20 13:59:27 $
%	$Id: ntascompare.m,v 1.9 2012-07-20 13:59:27 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-07-20 
% 	adding to help text
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

bands=0;

if exist('overlap')~=1, overlap=[]; end;
if isempty(overlap), overlap=1; end;

if exist('labels')~=1, labels=[]; end;
if isempty(labels), labels={'Series1','Series2'}; end;

if ~isfield(ADin,'spd'),
	ADin.spd=abs(1i.*ADin.north+ADin.east);
end;

if ~isfield(ADin,'dir'),
	ADin.dir=rad2deg(angle(ADin.north+1i.*ADin.east));
end;


if ~isfield(VMin,'spd'),
	VMin.spd=abs(1i.*VMin.north+VMin.east);
end;

if ~isfield(VMin,'dir'),
	VMin.dir=rad2deg(angle(VMin.north+1i.*VMin.east));
end;

% get all our times
ADin=ntascheckmat(ADin);	
VMin=ntascheckmat(VMin);	

% AD.spd=abs(1i.*AD.north+AD.east);
% AD.dir=90-rad2deg(angle(AD.east+1i.*AD.north));
%       ........  or  ........
% AD.dir=rad2deg(angle(AD.north+1i.*AD.east));

% show the time series on one another, before clip and trim



figure; subplot(2,1,1);
	% plot the more variable one first
	if iqr(VMin.north)>iqr(ADin.north),
		han(1)=plot(VMin.yday,VMin.north); hold on;
		han(2)=plot(ADin.yday,ADin.north,'g'); hold on;
	else
		han(2)=plot(ADin.yday,ADin.north,'g'); hold on;
		han(1)=plot(VMin.yday,VMin.north); hold on;
	end;
	legend(han,labels);
	ylabel('North Current Speed');
	title('Full Time Series');

	subplot(2,1,2);
	if iqr(VMin.east)>iqr(ADin.east),
		han(1)=plot(VMin.yday,VMin.east); hold on;
		han(2)=plot(ADin.yday,ADin.east,'g'); hold on;
	else
		han(2)=plot(ADin.yday,ADin.east,'g'); hold on;
		han(1)=plot(VMin.yday,VMin.east); hold on;
	end;
	legend(han,labels);
	ylabel('East Current Speed');
	xlabel('Yearday');

% be sure our data are clean and trimmed 
% clip to the overlapping parts of the records?

if overlap,
	% check startyear is the same
	if ~isfield(ADin,'year'), v=datevec(ADin.mday(1)); ADin.year=v(1); end;
	if ~isfield(VMin,'year'), v=datevec(VMin.mday(1)); VMin.year=v(1); end;
	if ADin.year~=VMin.year, 
		syear=min([ADin.year,VMin.year]);
		ADin.year=syear;
		VMin.year=syear;
		ADin.yday=ADin.mday-datenum(ADin.year,1,0);
		VMin.yday=VMin.mday-datenum(VMin.year,1,0);
	end;
	a=[minmax(VMin.yday); minmax(ADin.yday)];
	rng=[max(a(:,1)) min(a(:,2))];

	VM=ntasclipstruct(VMin,'yday',rng);
	AD=ntasclipstruct(ADin,'yday',rng);
else

	VM=VMin;
	AD=ADin;
	warning('Comparing records that do not overlap in time');

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check for mistakes in the timebase and throw away dups. Print a
% warning.

TS={'AD','VM'};
WN={'Series2','Series1'};

for j=1:length(TS),
	AA=eval(TS{j});
	K=find(diff(AA.yday)==0);
	if ~isempty(K),
		[m,n]=size(AA.yday);
		fn=fieldnames(AA); 
		for i=1:length(fn), 
			if all(size(AA.(fn{i}))==[m,n]),
				if m>n,
					AA.(fn{i})(K+1,:)=[];
				else
					AA.(fn{i})(:,K+1)=[];
				end;
			end;
		end;
		eval([TS{j} '=AA;']);
		warning(['Data for duplicate yearday values discarded in ' WN{j}]);
	end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting up some parameters
% 
% % For looking at the spectra: sampling frequency (per day)
VMf=1./mode(diff(VM.yday)); % 8 times per hour
ADf=1./mode(diff(AD.yday)); % once per hour

% make new labels for figure legends

figlabels{1}=[labels{1} ' (F_s=' num2str(VMf) '/hr)'];
figlabels{2}=[labels{2} ' (F_s=' num2str(ADf) '/hr)'];

% Blecch! Le's convert to cycles per hour

% VMfh=VMf./24;
% ADfh=ADf./24;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot displacements

% displacement is speed times time
VEdist=cumsum(ave(VM.east).*diff(VM.mday));
VNdist=cumsum(ave(VM.north).*diff(VM.mday));
AEdist=cumsum(ave(AD.east).*diff(AD.mday));
ANdist=cumsum(ave(AD.north).*diff(AD.mday));

figure; han(1)=plot(VEdist,VNdist); 
	hold on; 
	han(2)=plot(AEdist,ANdist,'g'); 
	legend(han,figlabels);
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Spectral Analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 
% Try welch spectral window
% is a clump of coil. Use periodogram.
% h=spectrum.periodogram;
% Hopts=psdopts(h);

% plot the psd (Power Spectral Density) 
% stationary by taking the diff (removes mean and trend)
% figure; subplot(1,2,1); psd(h,diff(VM.spd),'Fs',VMf); subplot(1,2,2); psd(h,diff(AD.spd),'Fs',ADf);

% Hopts.SpectrumType='Onesided';
% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
disp('Calculating first spectrum');
% examine the spectrum with Welch estimator using a Hann window
% of default segment length
% [Pvm,Pvmi,Pvmd,Pvms,BLvm]=ntasspectrum(VM,'Hann',[],0);
[Pvm,BLvm,BGvm]=ntasspectrum(VM,'Hann',[],0);

disp('Calculating second spectrum');
% [Pad,Padi,Padd,Pads,BLad]=ntasspectrum(AD,'Hann',[],0);
[Pad,BLad,BGad]=ntasspectrum(AD,'Hann',[],0);

% All spectrum
figure; 
	ax=[0,3000,0,15000];
	subplot(2,1,1);
	% x=1./Pvm.Frequencies;
	x=Pvm.Frequencies;
	% Fmax=max(Pvm.Data(x>=12 & x<=13));
	% y=Pvm.Data./Fmax;
	y=Pvm.Data;
	% ci=Pvm.ConfInterval./Fmax;
	loglog(x,y); hold on;
	% plot(x,ci,'r');
	% axis(ax);
	ax=axis;
	plot(ax(1:2),10.^polyval(BLvm.poly+[0,BLvm.offset],log10(ax(1:2))),'-.');
	plot(ax(1:2),10.^[BGvm BGvm],'--');
	title(labels{1})
	% ylabel(regexprep(get(get(gca,'ylabel'),'string'),'Hz','hr^{-1}'));
	% xlabel(regexprep(get(get(gca,'xlabel'),'string'),'Hz','hr^{-1}'));
	% ylabel('Relative PSD');
	ylabel('Power Spectral Density');
	xlabel('Frequency (cpd)');

	subplot(2,1,2);
	% x=1./Pad.Frequencies;
	x=Pad.Frequencies;
	% Fmax=max(Pad.Data(x>=12 & x<=13));
	% y=Pad.Data./Fmax;
	y=Pad.Data;
	% ci=Pad.ConfInterval./Fmax;
	loglog(x,y); hold on; 
	% plot(x,ci,'r');
	% axis(ax);
	ax=axis;
	plot(ax(1:2),10.^polyval(BLad.poly+[0,BLad.offset],log10(ax(1:2))),'-.');
	plot(ax(1:2),10.^[BGad BGad],'--');
	title(labels{2})
	% ylabel('Relative PSD');
	ylabel(' Power Spectral Density');
	xlabel('Frequency (cpd)');

% High Frequency part

figure; 
	ax=[0,75,0,1.2];
	subplot(2,1,1);
	x=24./Pvm.Frequencies;
	Fmax=max(Pvm.Data(x>=12 & x<=13));
	y=Pvm.Data./Fmax;
	% ci=Pvm.ConfInterval./Fmax;
	plot(x,y); hold on;
	% plot(x,ci,'r');
	axis(ax);
	title(labels{1})
	% ylabel(regexprep(get(get(gca,'ylabel'),'string'),'Hz','hr^{-1}'));
	% xlabel(regexprep(get(get(gca,'xlabel'),'string'),'Hz','hr^{-1}'));
	ylabel('Relative Power Spectral Density');
	xlabel('Period (hour)');

	subplot(2,1,2);
	x=24./Pad.Frequencies;
	Fmax=max(Pad.Data(x>=12 & x<=13));
	y=Pad.Data./Fmax;
	% ci=Pad.ConfInterval./Fmax;
	plot(x,y); hold on; 
	% plot(x,ci,'r');
	axis(ax);
	title(labels{2})
	ylabel('Relative Power Spectral Density');
	xlabel('Period (hour)');


% bands
% 
%  _____ ____    _            __     ___  
% |___ /| ___|  | |_  ___    / /_   / _ \ 
%   |_ \|___ \  | __|/ _ \  | '_ \ | | | |
%  ___) |___) | | |_| (_) | | (_) || |_| |
% |____/|____/   \__|\___/   \___/  \___/ 
%                                         
% Hopts.SpectrumType='Twosided';
% 
% Hopts.Fs=VMfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pvm=psd(h,VM.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[35:0.05:60]); 

% Hopts.Fs=ADfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pad=psd(h,AD.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[35:0.05:60]);

if bands,
figure; 
	x=1./Padi.Frequencies;
	y=Padi.Data;
	han(2)=plot(x,y,'g'); hold on;
	x=1./Pvmi.Frequencies;
	y=Pvmi.Data;
	han(1)=plot(x,y); hold on;
	ylabel('Power Spectral Density')
	xlabel('Period (hour)');
	legend(han,figlabels);

end;
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

% Hopts.Fs=ADfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pad=psd(h,AD.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[23:0.01:25]);

if bands,
figure; 
	x=1./Padd.Frequencies;
	y=Padd.Data;
	han(2)=plot(x,y,'g'); hold on;
	x=1./Pvmd.Frequencies;
	y=Pvmd.Data;
	han(1)=plot(x,y); hold on;
	ylabel('Power Spectral Density')
	xlabel('Period (hour)');
	legend(han,figlabels);
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

% Hopts.Fs=ADfh; Hopts.ConfLevel=0.9; % Hopts.Nfft=4096;
% Pad=psd(h,AD.spd,Hopts, ...
	% 'FreqPoints','User Defined','FrequencyVector',1./[11.5:0.001:13.5]);

if bands,
figure; 
	x=1./Pads.Frequencies;
	y=Pads.Data;
	han(2)=plot(x,y,'g'); hold on;
	x=1./Pvms.Frequencies;
	y=Pvms.Data;
	han(1)=plot(x,y); hold on; 
	ylabel('Power Spectral Density')
	xlabel('Period (hour)');
	legend(han,figlabels);

end;

% figure; subplot(2,1,1); psd(h,diff(VM.spd),'Fs',VMf,'ConfLevel',0.9);
% 	subplot(2,1,2); psd(h,diff(AD.spd),'Fs',ADf,'ConfLevel',0.9); 

% can only compare speeds and directions if the series overlap?
if overlap,

% plotting speeds against speeds

figure; qqplot(VM.spd,AD.spd)
	xlabel(['Quantiles of ' labels{1} ' speeds']);
	ylabel(['Quantiles of ' labels{2} ' speeds']);


% extract data at the same time bases (reduce to aquadopp
% sampling frequency)
% VMCM has the higher sampling frequency

if VMf>ADf,
	X=interp1(VM.yday,VM.spd,AD.yday);
	Y=AD.spd;
	% for directions, interpolate on an unwrapped series
	W=wrapTo180(interp1(VM.yday,unwrapd(VM.dir),AD.yday));
	Z=wrapTo180(AD.dir);
else
	X=VM.spd;
	Y=interp1(AD.yday,AD.spd,VM.yday);
	% for directions, interpolate on an unwrapped series
	W=wrapTo180(VM.dir);
	Z=wrapTo180(interp1(AD.yday,unwrapd(AD.dir),VM.yday));
end;

f(1)=figure;
	plot(X,Y,'.');
	hold on;
	xlabel(['v_{' labels{1} '}']);
	ylabel(['v_{' labels{2} '}']);


f(2)=figure; plot(X,X-Y,'.')
	xlabel(['v_{' labels{1} '}']);
	ylabel(['v_{' labels{1} '}-v_{' labels{2} '}']);


f(3)=figure; plot(W,Z,'.');
	xlabel([ labels{1} ' direction']);
	ylabel([ labels{2} ' direction']);

f(4)=figure; plot(W,W-Z,'.');
	xlabel([ labels{1} ' direction']);
	ylabel([ labels{1} '-' labels{2} ' direction']);

% find 10th percentile, exclude amount below from regression
% (assumption that low velocities lead to great error in the
% direction.

speedslegends={'<25% speed','25-75% speed','>75% speed'};

cutoff_lo=prctile(X,25);
cutoff_hi=prctile(X,75);

K=find(X>cutoff_hi);
J=find(X>cutoff_lo);
figure(f(1));
	hold on;
	plot(X(J),Y(J),'r.');
	plot(X(K),Y(K),'g.');
	% xlabel('v_{VMCM}');
	% ylabel('v_{Aquadopp}');

	[P,S]=polyfit(X,Y,1);
	x=minmax(X); 
	plot(x,polyval(P,x),'k','linewidth',2');
	legend(speedslegends);

% keyboard
if any( isnan(X)),
	Ierr=find(isnan(X)); 
	X(Ierr)=[];
	Y(Ierr)=[];
end;
if any( isnan(Y)),
	Ierr=find(isnan(Y)); 
	X(Ierr)=[];
	Y(Ierr)=[];
end;

% tlsr is taking a long time!
% 	[A,B,C]=tlsr(X.',Y.'); 

% tlsr returns [slope,inter] in A, polyval expects [inter,slope]
% 	plot(x,polyval(fliplr(A),x),'y','linewidth',2)


figure(f(3));
	hold on;
	plot(W(J),wrapTo180(Z(J)),'r.');
	plot(W(K),wrapTo180(Z(K)),'g.');
	% xlabel('VMCM direction');
	% ylabel('VMCM-Aquadopp direction');
	legend(speedslegends);

figure(f(4));
	hold on;
	plot(W(J),W(J)-Z(J),'r.');
	plot(W(K),W(K)-Z(K),'g.');
	% xlabel('VMCM direction');
	% ylabel('VMCM-Aquadopp direction');
	legend(speedslegends);

end; % if overlap,

return;

