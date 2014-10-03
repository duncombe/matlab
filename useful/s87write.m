function out = s87write(fname, prec_flag, data_type, plat_code, ...
    cty_code, sta_no, cast_no, lat, lon, dt, time, cruise, secondary_hdr, ...
    comments, vars, data, null);
%
% S87WRITE  V1.0 Write files in s87 format.  A brief description of the format
%                and required fields follows.  For more information, please see
%                format.s87 and sample.s87.  For NODC country and platform
%                codes, see GSHIP.M, or use gship (UNIX) or gship.bat (DOS).
%
% USAGE:        s87write(file_name, precision_flag, data_type, platform_code, ... 
%	        country_code, station_no, cast_no, lat, lon,  ...
%	        date, time, cruise, secondary_hdr, comments, ...
%	        variables, data);
%             
%                                >>>>>>> OR <<<<<<<<<
%                    
%               s87write(file_name, precision_flag, header, variables, data);
%
%               All fields are tab-delimited (ASCII char(9)). Data are recorded
%               columnwise. All fields must be entered, although nulls are in
%               general permissable and appropriate null values are given below.
%
%               1. FILENAME: (string) Name of file to be written.
%               2. PRECISION_FLAG: (modified boolean) 
%                            0 for %g write (rounds to 4 decimal places)
%                            # for high-precision write (specify decimal places)
%                              must be a positive integer
%               3. DATA_TYPE: (1 character string) instrument type. '' for null.
%               4. PLATFORM_CODE: (2-character string) NODC platform code, if 
%                  applicable. '' for null. (will appear as '00')
%               5. COUNTRY_CODE: (2-character string) NODC country code.  
%                  United States is '32'.
%               6. STATION_NO: (integer) station or mooring number.
%               7. CAST_NO: (integer) 0 for null.
%               8. LATITUDE: (double precision floating point).  0 for null.
%               9. LONGITUDE: (double precision floating point).  0 for null.
%                  Longitude and latitude are in DECIMAL DEGREES.
%                  South latitudes and West Longitudes are NEGATIVE.
%              10. DATE: (1x2 or 1x3 integer vector) 
%                  [year yearday] or [year month day]
%              11. TIME: (1x3 integer vector) [hour minute second] 
%                           ----> TIME IS IN GMT <----
%              12. CRUISE: (string) Optional cruise identifier.  
%                  Empty string '' for null.
%              13. SECONDARY_HEADER: (string).  This is for specific types of
%                  additional information and is not a comment line.  Please
%                  see s87 documentation for details. Empty string '' for null.
%              14. COMMENTS: (string matrix) Processing history.  For multi-line 
%                  comments, use STR2MAT (qv).  An additional comment will be
%                  added automatically, 'Written from s87write.m on [date]'.
%                  Empty string '' for null. Comment lines may not begin with
%                  '&' or '@'.
%              15. VARIABLES: (n x 2 string matrix). Column identification line. 
%                  N is number of variables to be written.  See STR2MAT for
%                  help creating this matrix. Empty string '' for null.
%              16. DATA: (m x n floating point matrix) N is number of variables.
%                  Note: s87write will support the use of NaN's as null values
%                  in the data matrix, but at this time I do not know of any
%                  way to get Matlab to correctly parse them when reading the
%                  s87 file back in with fscanf.
%              17. NULL DATA VALUE: (optional) The default value is -9 for 
%                  reasons discussed above, but if you are using something else,
%                  or just wish to document what you use, specifying your choice 
%                  here will add a comment line to that effect.
% 
%              S87 FORMAT OVERVIEW
%
%              Line 1: Header: REQUIRED. Fields described above.
%              Line 2: secondary header: OPTIONAL. See format.s87.
%              Comment Lines: OPTIONAL. Described above.
%              Column Identification Line: REQUIRED. A list of defined s87
%              variable identification tags, is contained in 'format.s87' (qv).
%              If you define a new variable or instrument tag, please email me:
%                                  dbyrne@umeoce.maine.edu
%              Data lines: OPTIONAL
%
%              The header will look roughly like this:
%     TPPCC SSSS CC SDD.DDDD SDDD.DDDD YY/MM/DD YDA HH:MM:SS  CRUISE_ID
%
%              Originally written by Deirdre Byrne, L-DEO, 97/03/27.

if nargin >= 16
  fid = fopen(fname,'w');
  if fid > -1
    % check the fields
    if max(size(dt)) == 2, jday = dt(2); dt = datec(dt);
    elseif max(size(dt)) == 3, jday = yearday(dt); jday = jday(2); end
    % Y2K bug -- eliminated 1/3/2003
    %if dt(1) > 1900, dt(1) = dt(1) - 1900; end
    if isempty(plat_code),
      plat_code = '00'; 
    else
      if ~all(size(plat_code) == [1 2])
	plat_code = plat_code(1:2);
      end
    end
    if isempty(cty_code), 
      cty_code = '00'; 
    else
      if ~all(size(cty_code) == [1 2])
	cty_code = cty_code(1:2);
      end
    end
    if isempty(sta_no), sta_no = -9; end
    if isempty(cast_no), cast_no = 0; end
    if isempty(lat), lat = -9; end
    if isempty(lon), lon = -9; end
    if isempty(time)
      time = [-9 -9 -9];
    elseif all(size(time) == [1 2])
      time = [floor(time) 0];
    end
    if prec_flag == 0
      fprintf(fid,['%c%2s%2s\t%i\t%i\t%g\t%g\t%2.2i/%2.2i/%2.2i\t%3.3i\t', ...
	  '%2.2i:%2.2i:%2.2i\t%s\n'], data_type, plat_code, cty_code, ...
          sta_no, cast_no, lat, lon, dt, jday, time, cruise);
    else
      arg = sprintf('%s%i%s%i%s', 'fprintf(fid,''%c%2s%2s\t%i\t%i\t%.', ...
	  prec_flag,'f\t%.',prec_flag,['f\t%2.2i/%2.2i/%2.2i\t%3.3i\t%2.2i',...
	      ':%2.2i:%2.2i\t%s\n'', data_type, plat_code, cty_code, ', ...
	      'sta_no, cast_no, lat, lon, dt, jday, time, cruise);']);
      eval(arg)
    end
    if ~isempty(secondary_hdr),
      if ~strcmp(secondary_hdr(1),'&')
	secondary_hdr = ['&' secondary_hdr];
      end
      fprintf(fid,'%s\n',secondary_hdr);
    end
    s = size(comments,1)+1;
    if s == 1,
      comments = ['Written from s87write.m on ' date];
    else
      comments = str2mat(comments,['Written from s87write.m on ' date]);
    end
    if nargin > 16
      comments = str2mat(comments, ...
	  ['Null data value in this file is: ', num2str(null)]);
      s = s+1;
    end
    for i = 1:s
      fprintf(fid,'%s\n',deblank(comments(i,:)));
    end
  else
    if nargout, out = -1; end
    disp('File unable to be opened')
    return
  end
elseif nargin == 5
  header = data_type; 
  vars = plat_code;
  data = cty_code;
  clear data_type plat_code cty_code
  fid = fopen(fname,'w');
  if fid > -1
    % strip out 'written from Matlab' if it is in header
    j = findstr(header,'Written from Matlab on ');
    if ~isempty(j)
      k = findstr(header(j:length(header)),setstr(10));
      if ~isempty(k)
	if k == length(header)
	  header = header(1:j-1);
	else
	  header = [header(1:j-1) header(k+j:length(header))];
	end
      else
	header = header(1:j-1);
      end
    end

    % strip out 'written from s87write' if it is in header
    j = findstr(header,'Written from s87write');
    if ~isempty(j)
      k = findstr(header(j:length(header)),setstr(10));
      if ~isempty(k)
	if k == length(header)
	  header = header(1:j-1);
	else
	  header = [header(1:j-1) header(k+j:length(header))];
	end
      else
	header = header(1:j-1);
      end
    end

    % add in a write ID tag
    if strcmp(header(length(header)),setstr(10))
      header = header(1:length(header)-1);
    end
    header = sprintf('%s\n%s',header, ['Written from s87write.m on ' date]);
    
    fprintf(fid,'%s\n',header);
  else
    if nargout, out = -1; end
    disp('File unable to be opened')
    return
  end
else
  disp([ 'USAGE: s87write(file_name, precision_flag, data_type, platform_code, ' ....
	  'country_code, station_no, cast_no, lat, lon, ', ...
	  'date, time, cruise, secondary_hdr, comments, ',...
	  'variables, data);'])
  disp('          >>>>>>>>>> OR <<<<<<<<<<<<<<<<                ')
  disp([ 'USAGE: s87write(file_name, precision_flag, ' ....
	  'header, variables, data);'])
  if nargout == 1, out = -1; end
  return
end
% if we've gotten this far, we've opened the file and written the
% header ....
N = size(vars,1);
fprintf(fid,'@');
for i = 1:N-1
  fprintf(fid,'%2s%c',vars(i,1:2),setstr(9));
end
if N > 0
  fprintf(fid,'%2s\n',vars(N,1:2));
else
  fprintf(fid,'\n');
  i = fclose(fid);
  if i == 0
    disp([ 'Successful write of: ' fname])
  end
  if nargout, out = 1; end
  return
end
% finally we are writing the DATA
if size(data,2) ~= N
  disp([fname ': Number of data columns unequal to number of defined variables'])
  fclose(fid);
  if nargout, out = 0; end
  return
else
  if prec_flag == 0
    % this changes the data!
    i = find(abs(data) < eps);
    data(i) = 0;
    % write the spec:
    fspec = [];
    for iii = 1:N-1, fspec = [fspec '%g\t']; end;
    fspec = [fspec '%g\n'];
    cmd = sprintf('fprintf(fid,''%s'',data'');',fspec);
    eval(cmd)
    i = fclose(fid);
    if i == 0
      disp([ 'Successful write of: ' fname])
    end
    if nargout, out = 1; end
    return
  else
    fspec = [];
    for iii = 1:N-1, fspec = [fspec '%.' num2str(prec_flag) 'f\t']; end;
    fspec = [fspec '%.' num2str(prec_flag) 'f\n'];
    cmd = sprintf('fprintf(fid,''%s'',data'');',fspec);
    eval(cmd)
    i = fclose(fid);
    if i == 0
      disp([ 'Successful write of: ' fname])
    end
    if nargout, out = 1; end
    return
  end
end
