function [STP,fh,ah,POS,TIM]=plotctd(inarg,legs,titlestr,isopyc)  % {{{
%PLOTCTD - plots t/p, s/p and t/s graphs side-by-side	
% 
%USAGE -	[STP,fh,ah,POS]=plotctd(inarg,legs,titlestr,isopyc) 
%
%EXPLANATION -	
% 		inarg - inarg can be seasoft cnv filename, or stp matrix 
% 			filename can be provided as fully 
% 		legs - write a legend on the plots
% 		titlestr - plot title
% 		isopyc - draw isopycnals on the plot
% 		STP - output STP array
% 		fh  - figure handles
% 		ah  - axis handles
% 		POS - station positions
% 
%
%SEE ALSO -	SHOWCTD, SEASOFTS
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	about 2012-09-27 (on SPURS-1 deployment, Knorr KN-209)
% 
%	$Revision: 1.4 $
%	$Date: 2013-03-31 07:27:11 $
%	$Id: plotctd.m,v 1.4 2013-03-31 07:27:11 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2013-03-26 
% 	Edits to help text
%  2013-03-30 
% 	return the time also
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

if exist('isopyc','var')~=1, isopyc=false; end

if exist('inarg','var')~=1, inarg=[]; end
if isempty(inarg), error('what to plot?'); end

if exist('legs','var')~=1
	legs=[];
end

if islogical(legs)
	justdata=true;
else
	justdata=false;
end

if exist('titlestr','var')~=1
	titlestr=[];
end

if ~iscell(inarg)
	inarg={inarg};
end


N=length(inarg);

if ~justdata,

	fh=figure; 

	if N<8
		% colo='brgcmyk';
		colo=[ 0 0 1 ; 1 0 0; 0 1 0; 0 1 1; 1 0 1; 1 1 0; 0 0 0];
	else
		colo=colorcube(N+2); 
		colo(end,:)=[];
	end

else
	fh=[]; 
end

for i=1:N
	filename=inarg{i};

if ischar(filename) 
	morestate=get(0,'more');
	more off;
	warning('off', 'MATLAB:strrep:InvalidInputType');
	[stp,pos,tim]=seasofts(filename);
	warning('on', 'MATLAB:strrep:InvalidInputType');
	more(morestate);
else
	stp=filename;
	pos=NaN;
end

I=find(stp==-9.99e-29); stp(I)=NaN; 
I=find(all(isnan(stp(:,[1 2 4]).')));
if ~isempty(I)
	stp(I,:)=[];
	warning(['Seasoft missing value depths removed (file number ' num2str(i) ')']); 
end

if ~ismember(length(tim),[3,6])
	tim=[tim zeros(1,6)];
	tim=tim(1:6);
end

tim=datenum(tim);

if N==1
	STP=stp;
	POS=pos;
	TIM=tim;
else
	STP{i}=stp;
	POS(i)=pos;
	TIM(i)=tim;
end

if ~justdata, 

% dept=sw_dpth(stp(:,1),stp(:,2),stp(:,3),25);
salt=stp(:,1);
pres=stp(:,3);
temp=stp(:,2);

if exist('depthrange','var')~=1,
	depthrange=[0 inf];
end
	minp=inf;
	maxp=-inf;
II=between(pres,depthrange);

	ah(1)=subplot(1,3,1);
	plot(salt(II),pres(II),'Color',colo(i,:)); hold on;

	ah(2)=subplot(1,3,2);
	h(i)=plot(temp(II),pres(II),'Color',colo(i,:)); hold on;

	ah(3)=subplot(1,3,3);
	plot(salt(II),temp(II),'Color',colo(i,:)); hold on;

	minp=min([pres;minp]);
	maxp=max([pres;maxp]);



end  % ~justdata


end % for i=1:length(inarg)

if justdata, ah=[]; return; end

	subplot(ah(1));
	xlabel('Salinity (PSU)');
	ylabel('Pressure (dbar)');
	set(gca,'ydir','reverse');
	% yaxis([0,1100]);
	yaxis([min([minp;0])-1 maxp+5]);
	title('P/S') 

	subplot(ah(2));
	xlabel('Temperature ( ^\circ{}C)');
	ylabel('Pressure (dbar)');
	set(gca,'ydir','reverse');
	% yaxis([0,1100]);
	% yaxis([min([minp;0])-1 maxp+5]);
	yaxis([minp-1 maxp+5]);
	title('P/T') 
	if ~isempty(legs)
		legend(h,legs,'location','southeast');
	end

	subplot(ah(3));
	ylabel('Temperature ({}^\circ{}C)');
	xlabel('Salinity (PSU)');
	title('T/S') 

orient('landscape')

if ~isempty(titlestr)
	% suplabel(titlestr,'t');
	suptitle(titlestr);
end


