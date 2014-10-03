function [Tval,DoF,Tcrit]=myttest(Y1,V1,N1,Y2,V2,N2,alpha)
%MYTTEST - 	calculates t-statistics from mean and variance
% 
%USAGE -	[Tval,DoF,Tcrit]=myttest(Y1,V1,N1,Y2,V2,N2,alpha)
%
%EXPLANATION -	Y means
% 		V variance
% 		N number of samples
% 		alpha significance level
% 		Tval t-value
% 		DoF degrees of freedom
% 		Tcrit critical values
% 
%REFERENCES -	Engineering Statitics Handbook, Exploratory Data Analysis
%		http://www.itl.nist.gov/div898/handbook/eda/section3/eda353.htm
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2009/03/17 
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: myttest.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
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

	Tval = (Y1-Y2)./ (sqrt(V1./N1 + V2./N2));

	DoF = (V1./N1 + V2./N2).^2 ./ ...
		((V1./N1).^2./(N1-1)+(V2./N2).^2./(N2-1));

	Tcrit=tinv(1-alpha,DoF);

return;

