function [Out,Ind]=outliers(Y,mult)
%outliers - 	find outliers of Y
% 
%USAGE -	[Out,Ind]=outliers(Y,mult)
%
%EXPLANATION -	
% 		Y: array of data columns
% 		mult: multiplier for the interquartile range to determine
% 			outliers (default=1.5)
% 
% 		Out: outliers (cell if n>1 in [m,n]=size(Y))
% 		Ind: index to outliers in Y (same size and type as Out) 
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2009/03/26 
%	$Revision: 1.10 $
%	$Date: 2013-01-10 17:59:00 $
%	$Id: outliers.m,v 1.10 2013-01-10 17:59:00 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2009/05/19 
% 	* something is wrong here. We should be adding 1.5.*IQR to
% 	the median, not upper and lower quartile ranges.
%  2011-10-27 
% 	* change to return double (instead of cell) when the argument (Y)
% 	is a vector instead of an array. I found that the call to outliers
% 	was most often for a vector, not an array, and returning a single
% 	celled animal was unexpected and counter-productive, hence the
% 	change. Note, must use cells instead of a matrix for returning
% 	results from multiple columns because the outliers in the columns
% 	will not have all the same sizes.  
% 	* potential bug in clearing NaNs. This will only work for a vector,
% 	and will turn a matrix into a vector if tried on an array. Use
% 	quantile instead of median which will deal nicely with the NaN
% 	issue. Except that median is never used now, see next comment, so
% 	leave that out.
% 	* test for complex argument, and use the magnitude to perform test. 
% 	* Apparently my misunderstanding of the boxplot is worse than I
% 	thought. upper and lower fences are 1.5*IQR from the hinges, not
% 	from the median! eg. Frigge et al 1989; 
%  2011-11-15 
% 	apparently threatened to introduce a variable multiplier for the
% 	IQR but never actually coded it in after changing the help text.
% 	WTF?  Now it is done.
%  2013-01-10 
% 	help text edit

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

if exist('mult','var')~=1, mult=[]; end
if isempty(mult), mult=1.5; end

% X=Y(~isnan(Y));
X=Y;
[m,n]=size(X);
if m==1, X=X.'; [m,n]=size(X); end
% median
% don't need median!
% M=quantile(X,0.5); % deals better with NaNs than median 
% upper and lower quartiles
Ql=quantile(X,0.25); % Ql=prctl25(X);
Qu=quantile(X,0.75); % Qu=prctl75(X);

% upper and lower interquartile range, and outlier limits
% uIQR=Qu-M; uOL=M+uIQR.*1.5; % WRONG!
% lIQR=M-Ql; lOL=M-lIQR.*1.5; % WRONG!
IQR=Qu-Ql;
lOL=Ql-IQR.*mult; % lOL=M-IQR.*1.5;
uOL=Qu+IQR.*mult; % uOL=M+IQR.*1.5;

Out=cell(1,n);
Ind=cell(1,n);
% for each column
for i=1:n, 
	I=find(X(:,i)<lOL(i));
	J=find(X(:,i)>uOL(i));
	
	Out{i}=X([I;J],i);
	Ind{i}=[I;J];
end

if n==1, Out=cell2mat(Out); Ind=cell2mat(Ind); end

return;

