function ARRAY=cellstructfun(FUN,CELL,FIELD)
% 
%CELLSTRUCTFUN - do a function on a common field of a cell array of structures	
% 
%USAGE -	ARRAY=cellstructfun(FUN,CELL,FIELD)
%
%EXPLANATION -	
% 	Impossible to refer to and perform an operation on  a
% 	cell array of possibly dissimilar structures with the
% 	common field, eg.  A=function(C.field), which seems to me
% 	to be a perfectly reasonable thing to want to do.
% 	Nevertheless Matlab will not allow it.
% 
% 	FUN -	function handle for the function to apply
% 		to the field FIELD of the structures in CELL
% 	CELL - 	cell array of structures
% 	FIELD - fieldname to use
% 
% 	ARRAY - scalar array of the same size as CELL with the
% 		results of FUN.  If the FIELD does not exist  in
% 		a particular element of CELL then return NaN.
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2010/12/23 

%	$Revision: 1.8 $
%	$Date: 2012-08-28 18:20:55 $
%	$Id: cellstructfun.m,v 1.8 2012-08-28 18:20:55 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-08-28 
% 	Generalising awkward shaped fields
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

% if exist('ARGIN')~=1, ARGIN=[]; end;
if ~isa(FUN,'function_handle'), error('Pass a function handle'); end;

ARRAY=nan(size(CELL));

for i=1:length(CELL),
	if isfield(CELL{i},FIELD),
		% if isempty(varargin),
			% ARRAY(i)=FUN(CELL{i}.(FIELD));
		% else
			% ARRAY(i)=FUN(CELL{i}.(FIELD));
			C{i}=FUN(CELL{i}.(FIELD));
		% end;
	else % try this trick, see if it works
	    try
		cmd=['FUN(CELL{i}.' FIELD ');'];
		ARRAY(i)=eval(cmd);
	    catch
		ARRAY(i)=NaN;
	    end;
	end;
end; 

if exist('C','var'), ARRAY=cell2mat(C); end

return;

