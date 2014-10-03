function binout = woceconvert(wocelist,sumfile,destdir)

% Author: D. A. Byrne ?

if nargin < 3
  disp('usage: woceconvert(wocelist,sumfile,dest_dir)')
  return
end

% make sure wocelist can be read
fid = fopen(wocelist, 'r');
if fid == -1
  disp(' ')
  disp([ 'woceconvert: WOCE file list "' wocelist '" unable to be opened.'])
  disp(' ')
  return
end

pos = [];
[pos, station, cast, time, code, date, data_type, pcode, ccode, ...
      cruise, sec_hdr] = wocehdr(sumfile);

if isempty(pos)
  % error string will already have been displayed by wocehdr.m
  return
end

% make sure destination directory spec is correct.
if ~strcmp(destdir(length(destdir)),'/')
  destdir = [destdir '/'];
end

line = fgetl(fid);
while all(line > -1)
  [data,vars,sta,cst] = woceload(line);
  i = find((station == sta) & (cast == cst));
  if length(i) == 0
    % try again, and be less picky!
    i = find(station == sta);
  end

  if length(i) > 1
    % make sure it's CTD data
    k = strmatch('C',data_type(i));
    if length(k > 0)
      i = i(k);
    else
      disp([ 'Warning: Data type not CTD in header for: ' line])
    end
    % if there's still confusion, take the beginning of the cast ...
    if length(i) > 1
      k = strmatch('BE', code(i));
      if length(k > 0)
	i = i(k);
      end
    end
    % if there's STILL confusion, take cast closest to the given cast ...
    if length(i) > 1
      k = find(abs(cast(i) - cst) == min(abs(cast(i) - cst)));
      if length(k > 0)
	i = i(k);
      end
    end
    if length(i) > 1
      % if there's STILL confusion, simply report it
      disp(['NOT ABLE TO DETERMINE CORRECT HEADER FOR FILE: ' line])
      disp(['      CHOICES ARE RECORDS ' num2str(i(:)')])
      disp('PLEASE SELECT ONE AT THE PROMPT BY TYPING "i=[number];"')
      keyboard
    end
  end
  if length(i) == 1
    % change extension and subdirectories in filename to write
    j = findstr(line,'.'); 
    k = max(findstr(line, '/'));
    fname = [line(k+1:j) 's87'];
    fname = [destdir fname];
    s87write(fname, 0, data_type(i), pcode, ccode, sta, cst, ...
	pos(i,2), pos(i,1), date(i,:), time(i,:), cruise,sec_hdr{i}, ...
	'', vars, data);
  elseif length(i) == 0
    disp(['NO HEADER FOUND FOR FILE: ' line])
  end
  line = fgetl(fid);
end
fclose(fid);

clear i j k fid line vars data sta cst fname
