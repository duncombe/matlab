function DAT = normaliz(DAT,null,dim,stan)
% NORMALIZE   Removes the mean and divides by the standard deviation.
%
% USAGE       NORMALIZ(data,null,dim,stan) 
%		
%             Null value is your bad data flag.  NaN ok.
%

%PROGRAM - Deirdre Byrne, 20 jan 1995
%
%CREATED -	
%	$Revision: 1.2 $
%	$Date: 2012-11-09 13:47:34 $
%	$Id: normaliz.m,v 1.2 2012-11-09 13:47:34 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2012-11-08  CMDR
% 	add option to normalize along a dimension by rows/columns
% 	retain the option to normalize the entire matrix if dim is not
% 	given. can specify a standard dev instead of calculated from data.
% 
% }}}

if exist('dim','var')~=1

% look for good data
if nargin == 1
   null = NaN;
end

if nargin ~= 0
  if isnan(null)
    i = find(~isnan(DAT));
  else
    i = find(DAT ~= null);
  end
% calculate mean and std of valid points; normalize
  if isempty(i)
    DAT = (DAT - mean(DAT))./std(DAT);
  else
    NDAT = DAT(i);
    NDAT = (NDAT - mean(NDAT))./std(NDAT);
    DAT(i) = NDAT;
  end
end

clear i null NDAT

return;

else  % if exist('dim','var')~=1

	if exist('null','var')~=1, null=[]; end
	if isempty(null), null=NaN; end
	if ~isnan(null), I=find(DAT==null); DAT(I)=NaN; end

NDAT=DAT;
mn=nanmean(NDAT,dim);
if exist('stan','var')~=1, stan=[]; end
if isempty(stan)
	sd=nanstd(NDAT,0,dim);
else
	sd=zeros(size(mn))+stan;
end

[m,n]=size(NDAT);
c=[size(mn)~=[m,n]];
d=[m,n].*c+~c;

DAT=(NDAT-repmat(mn,d))./repmat(sd,d);

if ~isnan(null), DAT(I)=null; end

end

