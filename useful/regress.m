function [ SLOPE,INTERCEPT,N,RSQUARE,STDERR,SLOERR,INTERR ] = regress(X,Y,display)
%REGRESS -	returns the linear regression slope and intercept 
%			and errors of vectors x and y 
%
%USAGE - 	[SL,IN,N,RSQU,STERR,SLERR,INERR] = regress(X,Y,display)
% 
%EXPLANATION -
% 		display - Optional. Display the results in a
% 			formatted table. (logical)
% 		SL -	slope
%		IN -	intercept
%		N -	number of points
%		RSQU -	r-square of the fit
%		STERR -	standard error of the estimate
%		SLERR -	error of the slope
%		INERR -	error of the intercept
%
%SEE ALSO - 	REGRPLOT, POLYFIT, POLYVAL
% 
%BUGS 
%   -	What book did this recipe come out of? (Possibly it was Underhill?)
%   -	Note that the Matlab function polyfit can do the same linear
%   	regression task (without providing the error estimates). For data
%   	sets shorter than about 6500 elements, regress runs quicker than
%   	polyfit. For vectors longer than that, polyfit is quicker. The same
%   	result can also be obtained with [ones(length(X),1) X]\Y
% 
%

% PROGRAM - 	MATLAB code by c.m.duncombe rae SFRI & L-DEO
%
% PROG MODS -	96-09-14
%  2010/10/18 
% 	ensure inputs are columns 
%  2010/10/21 
% 	add ability to display results in formated string 
%  2013-03-26 
% 	edits to help text. make argument tests conform to (my) standard.
% 
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

if exist('display','var')~=1, display=[]; end
if isempty(display), display=0; end
if ~isboolean(display), error('display argument should be logical'); end 

I=find(~isnan(X));X=X(I);Y=Y(I);
I=find(~isnan(Y));X=X(I);Y=Y(I);

x=X(:);
y=Y(:);

N=size(x,1); 

if N==0, 
	SLOPE=nan; 
	INTERCEPT=nan; 
	RSQUARE=nan; 
	STDERR=nan; 
	SLOERR=nan; 
	INTERR=nan; 
	return;
	end;

Sx = sum(x);
Sy = sum(y);
Sxx = sum(x.*x);
Syy = sum(y.*y);
Sxy = sum(x.*y);

Cxy = Sxy - Sx.*Sy./N; % this is \equiv Zar eqn 17.3
Cxx = Sxx - Sx.*Sx./N; 
Cyy = Syy - Sy.*Sy./N; 

if Cxx==0, SLOPE=nan; else, SLOPE = Cxy./Cxx; end; % this is \equiv Zar eqn 17.4

INTERCEPT = ( Sy - SLOPE.*Sx )./N ; 

if (Cxx.*Cyy)==0, 
	RSQUARE=nan; 
else, 
	RSQUARE = (Cxy.*Cxy)./(Cxx.*Cyy); 
end;

%  calc estimates from x; subtract y vals; square; sum; divide deg freedom; sqrt

if N==2, 
	uncertain=nan; 
else, 
	uncertain =  sum( (y- (x.*SLOPE+INTERCEPT) ).^2 ) ./ (N-2) ; 
end;

STDERR = sqrt( uncertain );
if Cxx==0, 
	SLOERR=nan; 
else, 
	SLOERR = sqrt( uncertain ./ Cxx ); 
end;
if (N.*Cxx)==0, 
	INTERR=nan; 
else, 
	INTERR = sqrt( uncertain .* Sxx ./ (N.*Cxx) ); 
end;

minusplus=['-+'];

if display,
	disp(['Y = ' num2str(SLOPE) ' X ' minusplus(sign(INTERCEPT)./2+1.5)  num2str(abs(INTERCEPT)) ]);
	disp(['Error in estimate = ' num2str(STDERR)]);
	disp(['Error in slope = ' num2str(SLOERR)]);
	disp(['Error in intercept = ' num2str(INTERR)]);
end;

return;


