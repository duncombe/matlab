function [cont,J]=levels(c)
% LEVELS        the contourlevels from the contourmatrix c
% 
% cont = levels(c)
%
% c    = contourmatrix as described in CONTOURC
%
% cont = vector of contourlevels (like the one you give into CONTOUR
%        when you want manual control of the contourlevels).
%
% BEWARE: In the contourmatrix from CONTOURF there may occur a "fictive"
% contourlevel, nemely min(min(data)), even when giving explicit input of
% desired levels. This is just a warning, LEVELS does not counteract this.
%
% See also CONTOURC ECOLORBAR

%Time-stamp:<Last updated on 07/03/14 at 10:56:29 by even@nersc.no>
%File:</Home/even/matlab/evenmat/levels.m>

%PROGRAM - 	
%
%CREATED -	Even Nilsen
% 	Obtained from http://www.nersc.no/~even/ - 2011-02-18 
% 
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: levels.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%
%

error(nargchk(1,1,nargin));
cont=[];

i=1;j=0;
while i <= size(c,2) 
  j=j+1; 
  cont(j)=c(1,i);
  pairs=c(2,i);
  i=i+pairs+1;
  J(j)=i;
%   if j==1 | cont(j)~=cont(j-1)
%   end
end

%cont=cont(1:end-1);
[cont,J]=unique(cont);		% remove repetitions from "islands"
J=J';

