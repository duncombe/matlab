function [YD,LY] = date2day(DAT)
% DATE2DAY -	returns the day of the year from the given date
%
% USAGE - 	[YD,LY]=date2day(date);
%
% EXPLANATION -	date - vector [year month day] eg. [92 3 24]
%		YD - vector [ year dayofyear ] eg. [1992 84]
%		LY - vector leap year 1 or 0 
%		argument can be columnwise matrix 
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae
%
% PROG MODS -	1998-11-11 return whether year is leap or not
%		2007-09-09 Later versions of matlab deal
%			differently with NaNs and empty matrices.
%			Fixed error in not initializing LY before
%			returning.
%
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
%
% 

%
%
	K=[find(any(DAT.')==0)].';
	J=[find(any(DAT.'))].';
	if ~isempty(J),
		dat=DAT(J,:);
		modays=[0 31 28 31 30 31 30 31 31 30 31 30 31];
		lydays=[0 31 29 31 30 31 30 31 31 30 31 30 31];
%
		dim=[ 	cumsum(modays); cumsum(lydays) ];

% adjust year to 19?? and find leapyears (LY)
		I=find(dat(:,1)<100);
		dat(I,1)=dat(I,1)+1900;
		yr=rem(dat(:,1),100);
		I=find(yr==0);
		if ~isempty(I), yr(I)=dat(I,1)./100; end;
		lys=rem(yr,4);
		ly=(lys==0);
		LY=find(ly);
%
		days=dim(1,dat(:,2));
		if ~isempty(LY), days(LY)=dim(2,dat(LY,2)); end;
%
		YD(J,:)=[ dat(:,1) days.'+dat(:,3) ];
		LY=DAT(:,1);
		LY(J)=ly;
	end;
	if ~isempty(K), YD(K,:)=ones(size(K))*[ NaN NaN ]; end;

clear dat modays lydays dim I yr lys days 
return;

