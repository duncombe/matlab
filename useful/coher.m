function [spectry_out,spectrz_out, coheramp_out,coherpha_out,freq]=coher(yy,zz,delt,M,title1,title2);
%COHER - 	computes a coherence (and power density)
%	of data yy(t) , zz(t), t=1,N, where N is a power of 2,
% 
% 	N is computed from the size of yhat using fft.
% 	M is window width--Daniell. delt must also be specified.
%
%	Phase convention: the phase angle is positive when the
%	2nd time series leads.
% 
%USAGE -	
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%
%CREATED -	obtained from Tom Farrar 2011/02/10 
% 
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: coher.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%% Carl Wunsch, 1987
%%function [spectry,spectrz, coheramp,coherpha,freq]=coher(yy,zz,delt,M,'title1','title2');
%
% Title arguments added 6-9-01 (JTF)
% 
% Modified to remove mean BEFORE tapering input time series (3-10-06).
%  This is important to avoid spurious low freq energy.

yy1=yy(:);zz1=zz(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modifications 1-18-02 by Tom Farrar, tomf@mit.edu.
%   'scale' term to modify frequency scale for plots.  Labels must be 
%           changed manually!
scale=1;%number timesteps per time unit
%
%   plot confidence intervals on spectrum plots as in Wunsch's 
%      "Time Series Analysis.  A Heuristic Primer.", 2000, eqn 10.70
spot=1./2.87;%10;%10^-7;%24/12.42;%24./18.2414;%1/2.87;%10^0;%x-coordinate of errorbar plot 
nu=2*M;
[low,up]=confid(.05,nu); %won't work w/o optimization toolbox
%
%
log10([low,up])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    if exist('freq')
     clear period;clear freq;
     clear specty;clear spectz;clear cohyz;
    end
    

yy1=yy1-mean(yy1);
zz1=zz1-mean(zz1);

%generate a taper window
  L=length(yy1);
  L10=fix(L/5);
  wind=ones(L,1);
  wind(1:L10,1)=1-cos([1:L10]'*pi/(2*L10));
  wind(L:-1:L-L10+1,1)=wind(1:L10,1);
  y=yy1.*wind;
  z=zz1.*wind;
if 1==2
  figure
  plot(y)
end%if 1==2
  figure
avgy=mean(y);%formerly, nanmean--->mean
avgz=mean(z);%formerly, nanmean--->mean
%y=y-avgy;
%z=z-avgz;
yhat=fft(y);
zhat=fft(z);
N=length(yhat);
yhat=yhat/(N/2);
zhat=zhat/(N/2);
%normalization is such that amplitude of a unit sine wave =1 in ft.
%not corrected for taper energy loss.
window=ones(M,1);
periody=yhat.*conj(yhat);
periodz=zhat.*conj(zhat);
perioyz=yhat.*conj(zhat);
specty=conv(window,periody);
spectz=conv(window,periodz);
cohyz=conv(window,perioyz);
%divide values by width of the averaging interval to get spectral density
% in units of cycles/delta t
specty=specty/(M/(delt*N));
spectz=spectz/(M/(delt*N));
cohyz=cohyz/(M/(delt*N));
%now decimate
s=M:M:N/2;
s1=length(s);
spectry=specty(s);
spectrz=spectz(s);
coheryz=cohyz(s)./sqrt(spectry.*spectrz);
%discarding 1/2 the fft and spectrum by symmetry
%set up frequency  scale
freq(1,1)=(M-1)/2*(1/(N*delt));
freq(2:s1,1)=freq(1)+(M/(N*delt))*[1:s1-1]';
for ii=2:s1
  period(ii,1)=1/freq(ii,1);
end
if M==1
  period(1,1)=inf;
   else
     period(1,1)=1/freq(1,1);
end
coheramp= abs(coheryz);
coherpha=angle(coheryz)*180/pi;
%now plot log log
clf
subplot;
if M~=1
subplot(221),loglog(freq*scale,spectry),grid
hold on%JTF
lowyy=var(y)*low;
    upyy=var(y)*up;
loglog(spot,var(y),'ro');
loglog([spot+10^-12 spot-10^-12], [lowyy,upyy],'r');
hold off; 
axis tight; grid on;%JTF
xlabel('FREQUENCY (cpd)'),ylabel('POWER DEN');
title(title1);
subplot(222),loglog(freq*scale,spectrz),
hold on%JTF
lowzz=var(z)*low;
    upzz=var(z)*up;
loglog(spot,var(z),'ro');
loglog([spot+10^-12 spot-10^-12], [lowzz,upzz],'r');
hold off%JTF
axis tight
grid on
xlabel('FREQUENCY (cpd)'),ylabel('POWER DEN');
title(title2);
subplot(223), semilogx(freq*scale,coheramp),axis tight,ax=axis;axis([ax(1),ax(2),0,1]);
grid
xlabel('FREQUENCY (cpd)'),ylabel('COH AMPL.');

subplot(224),semilogx(freq*scale,coherpha);axis([ax(1),ax(2),-180,180]);
%axis tight
grid
xlabel('FREQUENCY (cpd)'),ylabel('COH PHASE');
title(['\phi>0 for ' title2 ' leading ' title1])
else
loglog(freq(2:s1)*scale,spectry(2:s1),freq(2:s1)*scale,spectrz(2:s1)), grid
end
j9=length(spectry);num=[0:j9-1]';
format short e
disp(' NUMBER    FREQ.    PERIOD    POWERY     POWERZ     COHERENCE AMP.     & PHASE')
[num,freq,period,spectry,spectrz,coheramp,coherpha];
disp('note to convert to power, use delfreq, not freq(1)')
disp('power computed will be 2*the meansquare.')
format short;axis;

spectry_out=spectry;
spectrz_out=spectrz;
coheramp_out=coheramp;
coherpha_out=coherpha;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Level of no significance for coherence plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
coheramp_data=coheramp;
 num=100;
 level=95;
out_n=zeros(num,1);
for ind=1:num
yy=randn(size(yy));%replace yy with white noise
yy1=yy(:);zz1=zz(:);

     clear periody;%clear freq;
     clear specty;clear spectz;clear cohyz;


%generate a taper window
  L=length(yy1);
  L10=fix(L/10);
  wind=ones(L,1);
  wind(1:L10,1)=1-cos([1:L10]'*pi/(2*L10));
  wind(L:-1:L-L10+1,1)=wind(1:L10,1);
  y=yy1.*wind;
  z=zz1.*wind;
avgy=mean(y);
avgz=mean(z);
y=y-avgy;
z=z-avgz;
yhat=fft(y);
zhat=fft(z);
N=length(yhat);
yhat=yhat/(N/2);
zhat=zhat/(N/2);
%normalization is such that amplitude of a unit sine wave =1 in ft.
%not corrected for taper energy loss.
window=ones(M,1);
periody=yhat.*conj(yhat);
periodz=zhat.*conj(zhat);
perioyz=yhat.*conj(zhat);
specty=conv(window,periody);
spectz=conv(window,periodz);
cohyz=conv(window,perioyz);
%divide values by width of the averaging interval to get spectral density
% in units of cycles/delta t
specty=specty/(M/(delt*N));
spectz=spectz/(M/(delt*N));
cohyz=cohyz/(M/(delt*N));
%now decimate
s=M:M:N/2;
s1=length(s);
spectry=specty(s);
spectrz=spectz(s);
coheryz=cohyz(s)./sqrt(spectry.*spectrz);
%discarding 1/2 the fft and spectrum by symmetry
coheramp= abs(coheryz);
coherpha=angle(coheryz)*180/pi;



 
 amp=sort(coheramp);
 
 top5=amp(round(level*.01*end):end);
 out_n(ind)=top5(1);
 
end
 
noconfid=mean(out_n); 
hold on
subplot(223), semilogx([freq*scale freq*scale],[coheramp_data noconfid.*ones(size(period))]),axis tight, ax=axis;axis([ax(1),ax(2),0,1]);
xlabel('FREQUENCY (cpd)'),ylabel('COH AMPL.');
grid on
hold off

coheramp=coheramp_data+i.*noconfid.*ones(size(period));
