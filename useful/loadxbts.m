function [POS,SA,TE,PR,DE]=loadxbts(expr)

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
if ~exist('expr');
  expr='*.s87';
else
  if isempty(expr),
    expr='*.s87';
  end;
end;

[DIR,N]=dirlist(expr);

POS=[]; SA=[]; TE=[]; DE=[]; PR=[];


if ~isempty(DIR),

  [rec,DIR]=strtok(DIR);

  while ~isempty(rec),

    if ~exist(rec),
      disp([rec ' not found']);
    else
      more off;
      disp(rec);
      more on;
      % [stp,pos,tim,header,stn,grd]=s87loads(rec);
	[pos,hdr,sa,te,pr,de]=s87load(rec);
	POS=[POS pos];
	if isempty(sa), sa=NaN; end;
	if isempty(te), te=NaN; end;
	if isempty(de), de=NaN; end;
	if isempty(pr), pr=NaN; end;
	[SA,sa]=samerows(SA,sa); SA=[SA sa];
	[TE,te]=samerows(TE,te); TE=[TE te];
	[PR,pr]=samerows(PR,pr); PR=[PR pr];
	[DE,de]=samerows(DE,de); DE=[DE de];

      if isempty(pos),
        disp([rec ': Invalid position reported']);
        pos=NaN;
      end;
      % if isempty(tim),
      %   disp([rec ': Invalid time reported']);
      %   tim=NaN.*ones(1,5);
      % end;

    end;
    [rec,DIR]=strtok(DIR);
  end;

end;

return;

