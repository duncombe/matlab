function [X,Yave,Yvar,N]=cases(x,y)
%CASES - 	finds the values of the categories and calculates some stats
% 
%USAGE -	[X,Yave,Yvar,N]=cases(x,y)
%
%EXPLANATION -	X	categories
%		Yave	average of the values of the categories
%		Yvar	variance of ditto
%		N	number of values per category
%		x	vector of the categories
%		y	vector of the values
%
%SEE ALSO -	uniq, stats
%
%COMMENT -	This strikes me as some kind of histogramming function.
%		Am I reinventing the wheel here? Stats packages?

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2002-04-22
%
%PROG MODS -	
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

X=uniq(sort(x));
Yave=zeros(size(X,1),1);
Yvar=zeros(size(X,1),1);
N=zeros(size(X,1),1);
for i=1:length(X),
	I=find(x==X(i));
	[Yave(i),Yvar(i),N(i)]=stats(y(I));
end;
return;
