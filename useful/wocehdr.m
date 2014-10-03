function [pos, station, cast, time, code, date, data_type, platform_code, ...
      country_code, cruise, secondary_header] = wocehdr(sumfile)

% USAGE: [pos, station, cast, time, code, date, data_type, platform_code, country_code, ...
%          cruise, secondary_header] = wocehdr(sumfile);

% Author: D. A. Byrne ?

if nargin < 1
  help wocehdr
  return
end

fid = fopen(sumfile,'r');
if fid == -1
  disp(' ')
  disp([ 'wocehdr: Sumfile "' sumfile '" unable to be opened.'])
  disp(' ')
  pos = [];
  return
end

% get the header line
line = fgetl(fid);
if line == -1
  return
end
ppcc = '0000';
disp(' ')
disp([blanks(10) line])
disp(' ')
shipidstring = input('Please type in the ship ID string you would like to try (CR to skip) >> ','s');
if ~isempty(shipidstring)
  shipnames = gship(shipidstring);
  if ~isempty(shipnames)
    disp(' ')
    disp('Matches: ')
    str = '';
    for i = 1:size(shipnames,1)
      str(i,:) = sprintf('%2i. ', i);
    end
    disp([str char(shipnames)])
    if size(shipnames,1) > 1
      disp(' ')
      whichshipname = input('Please type in the number of the one you would like to use. (CR to skip) >> ');
      if ~isempty(whichshipname)
	ppcc = char(shipnames(whichshipname));
      end
    else
      disp(' ')
      whichshipname = input('Is this correct (Yes or No)? [Y] >> ','s');
      if isempty(whichshipname), whichshipname = 'Y'; end
      if strcmp(upper(whichshipname(1)),'Y')
	ppcc = shipnames;
      end
    end
  end
end
platform_code = ppcc(1:2);
country_code = ppcc(3:4);

disp(' ')
cruise = input('Please type in a cruise ID string >> ','s');
disp(' ')

for i = 1:3
  line = fgetl(fid);
end

k = 1;
line = fgetl(fid);
while line > -1
  line = strrep(line,setstr(9),setstr(32));
  while ~isempty(findstr(line,'  '))
    line = strrep(line,'  ',' ');  
  end
  irec = findstr(line,' ');
  irec = [0 irec length(line)+1];
  
  % get station
  sta = str2num(line(irec(3)+1:irec(4)-1));
  station(k) = sta;
  
  % get cast number
  cast(k) = str2num(line(irec(4)+1:irec(5)-1));
  
  % get data type
  type = line(irec(5)+1:irec(6)-1);
  if strcmp(type,'ROS')
    data_type(k) = 'C';
  elseif strcmp(type,'XBT')
    data_type(k) = 'X';
  elseif strcmp(type,'ADC')
    data_type(k) = 'D';
  elseif strcmp(type,'LVS')
    data_type(k) = 'C';
  else
    data_type(k) = ' ';
    % skip this record!
  end

  % here are other things we want to read/generate
  dt = str2num(line(irec(6)+1:irec(7)-1));
  base = 100*floor(dt/100);
  yr = dt - base;
  dt = (dt - yr)/100;
  base = 100*floor(dt/100);
  day = dt - base;
  mo = (dt - day)/100;
  date(k,:) = [yr+1900 mo day];
  
  % time
  tm = str2num(line(irec(7)+1:irec(8)-1));
  base = 100*floor(tm/100);
  mm = tm - base;
  hh = base/100;
  ss = 0;
  time(k,:) = [hh mm ss];
  
  % CODE
  code{k} = line(irec(8)+1:irec(9)-1);
  
  % get latitude
  tmp(1) = str2num(line(irec(9)+1:irec(10)-1));
  tmp(2) = str2num(line(irec(10)+1:irec(11)-1));
  direc = line(irec(11)+1:irec(12)-1);
  tmplat = tmp(1) + tmp(2)/60;
  if strcmp(direc,'S')
    tmplat = -tmplat;
  end
  
  % get longitude
  tmp(1) = str2num(line(irec(12)+1:irec(13)-1));
  tmp(2) = str2num(line(irec(13)+1:irec(14)-1));
  direc = line(irec(14)+1:irec(15)-1);
  tmplon = tmp(1) + tmp(2)/60;
  if strcmp(direc,'W')
    tmplon = -tmplon;
  end
  pos(k,:) = [tmplon tmplat];

  % make secondary_header (depth)
  ZZ = line(irec(16)+1:irec(17)-1);
  if str2num(ZZ) == -9
    ZZ = line(irec(17)+1:irec(18)-1);
  end
  if str2num(ZZ) == -9
    secondary_header{k} = '';
  else
    secondary_header{k} = ['&ZZ=' ZZ];
  end
  
  line = fgetl(fid);
  k = k + 1;
end
station = station(:);
cast = cast(:);
code = code(:);
data_type = data_type(:);
secondary_header = secondary_header(:);

fclose(fid);
return
