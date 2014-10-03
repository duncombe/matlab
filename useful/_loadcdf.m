function loadcdf(fname, null)
%LOADCDF - 	function to load a netcdf file into Matlab variables
% 
%USAGE -	loadcdf(fname, null)
%
%EXPLANATION -	
%
%SEE ALSO -	
%

%PROGRAM - 	MATLAB code by deirdre a. byrne
%
%CREATED -	2006/07/11
%
%PROG MODS -	by c.m. duncombe rae
%		2007/06/18: added comments and portability. update
%			for versions running on my computers
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOADCDF  function to load a netcdf file into Matlab variables.
% USAGE:   LOADCDF(FILENAME, NULL_VALUE);
%
% If null_value is included, null values will be converted to NaNs.
%

% Deirdre Byrne, dbyrne@umeoce.maine.edu, 2006/07/11

%%%%% put mexnc in the startup!
% addpath('/work/matlab/mexnc')

% [fid]= mexcdf60('open',fname);
[fid]= mexnc('open',fname);

if fid < 0
  disp('loadcdf: File not found')
  return
end

% disp(['CMDR: file opened: ',num2str(fid)])
[ndims, nvars, ngatts, unlimdim, status] = mexnc ( 'inq', fid );

% disp(['CMDR: vars inqd (',num2str(nvars),')'])

% get all variables
global cdfdata
evalin('base','global cdfdata')
for i = 0:nvars-1
% disp(['CMDR: ',num2str(fid),' ',num2str(i)])
  name{i+1} = mexnc('VARINQ', fid, i);
  if strcmp(name{i+1},'header')
    [cdfdata, status] = mexnc ( 'get_var_text', fid, i);
    cdfdata = cdfdata';
  else
    [cdfdata, status] = mexnc ( 'get_var_double', fid, i);
  end
  if nargin == 2
    cdfdata(find(cdfdata == null)) = nan;
  end
% disp(['CMDR: ', name{i+1}])
  evalin('base', sprintf('%s = cdfdata;', name{i+1}))
end
clear cdfdata
evalin('base','clear cdfdata')
% mexcdf60('close',fid)
mexnc('close',fid);
%%%% CMDR
return;
