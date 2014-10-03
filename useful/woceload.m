function [data, vars, station, cast, header] = woceload(str)
%
% WOCELOAD - 	loads data from WOCE format file into variables named 
% 		according to s87 format data specifiers.
%
% USAGE - 	[data, vars, station, cast, header] = woceload(file);
% 
% EXPLANATION -	data:	 matrix containing data
%		vars:	 matrix containing variable names
%               station: station number
%               cast:    cast number
%		header:	 string matrix containing file headers
%		file:	 input filename
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.3 $
%	$Date: 2011-04-09 14:05:14 $
%	$Id: woceload.m,v 1.3 2011-04-09 14:05:14 duncombe Exp $
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

% open data file

fidd = fopen(str);
if fidd > -1
  
  % get first header from file, cut out position
  
  rec = fgetl(fidd);
  if rec == -1 
    return
  end
  header = rec;
  rec = fgetl(fidd);
  if rec == -1
    return
  end
  header = sprintf('%s\n%s',header,rec);
  rec = strrep(rec,' ',setstr(9));
  while ~isempty(findstr(rec,[setstr(9) setstr(9)])), 
    rec = strrep(rec,[setstr(9) setstr(9)],setstr(9)); 
  end;
  irec = findstr(rec,setstr(9));
  station = str2num(rec(irec(1):irec(2)));
  cast = str2num(rec(irec(3):irec(4)));
  rec = fgetl(fidd);
  if rec == -1 
    return
  end
  header = sprintf('%s\n%s',header,rec);
  rec = fgetl(fidd);
  if rec == -1 
    return
  end
  header = sprintf('%s\n%s',header,rec);
  while ~isempty(findstr(rec,[ '  '])), 
    rec = strrep(rec,[ '  '],' '); 
  end;
  rec = deblank(fliplr(deblank(fliplr(rec))));
  irec = findstr(rec,' ');
  irec = [0 irec length(rec)+1];
  vars = '';
  for i = 1:length(irec)-1
    vars = str2mat(vars,rec(irec(i)+1:irec(i+1)-1));
  end
  vars = vars(2:size(vars,1),:);
  nvars = size(vars,1);

  % read units line;
  rec = fgetl(fidd);
  if rec == -1 
    return
  end
  header = sprintf('%s\n%s',header,rec);
  rec = fgetl(fidd);
  if rec == -1 
    return
  end
  
  % read data:
  S = fscanf(fidd,'%g');
  nquan = length(S)/nvars;
  data = reshape(S,nvars,nquan)';
  fclose(fidd);
  
  % change vars to s87 ....
  for i = 1:nvars
    if ~isempty(findstr(vars(i,:),'PRS'))
      vars(i,1:2) = 'PR';
    elseif ~isempty(findstr(vars(i,:),'PRES'))
      vars(i,1:2) = 'PR';
    elseif ~isempty(findstr(vars(i,:),'TMP'))
      vars(i,1:2) = 'TE';
    elseif ~isempty(findstr(vars(i,:),'SAL'))
      vars(i,1:2) = 'SA';
    elseif ~isempty(findstr(vars(i,:),'NUM'))
      vars(i,1:2) = 'NO';
    elseif ~isempty(findstr(vars(i,:),'OXY'))
      vars(i,1:2) = 'OX';
    elseif ~isempty(findstr(vars(i,:),'QUAL'))
      vars(i,1:2) = 'QC';
    end
  end
  vars = vars(:,1:2);
else
  disp([ 'File ' str ' unable to be opened.'])
end
return
  
