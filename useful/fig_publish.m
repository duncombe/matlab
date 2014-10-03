function fig_publish(fig,fontname)
%PUBLISH - increase fonts and linewidths to ready a figure for publication	
% 
%USAGE -	publish(fig,fontname)
%
%EXPLANATION -	resets a lot of stuff on a matlab figure so 
% 	that it comes out readable when put in a document
%
%SEE ALSO -	
%
%BUGS -
% 	This is a very blunt force instrument. If fonts and sizes
% 	are already set, then they are blindly overwritten, so it
% 	is not appropriate for figures that depend on line widths
% 	for differentiating data sets. 

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	
%	$Revision: 1.4 $
%	$Date: 2011-12-12 14:52:21 $
%	$Id: fig_publish.m,v 1.4 2011-12-12 14:52:21 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
%  2010/11/12 
% 	rename
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

% determine global handle visibility
showhiddenhandles=get(0,'showhiddenhandles');
set(0,'showhiddenhandles','on');

if exist('fig')~=1, fig=[]; end;
if isempty(fig), fig=gcf; end;

for l=1:length(fig)
figure(fig(l));

% if required, ensure all the fonts are the same
AH=findobj(fig(l),'-property','fontname');
if exist('fontname')==1, 
	set(AH,'fontname',fontname);
end;

% children of the figures are axes
aah=get(fig(l),'Children');

% for each axis
for k=1:length(aah),
  ah=aah(k);

  % children of the axes can be a lot of things
  ak=get(ah,'children');
  for i=1:length(ak),
	% H is a structure describing the graphics object
	H=get(ak(i));

	if strcmpi(get(ak(i),'Type'),'text'),
		set(ak(i),'Fontsize',12);
	end;
	if strcmpi(get(ak(i),'Type'),'line'),
		mw=get(ak(i),'MarkerSize');
		set(ak(i),'MarkerSize',mw+2);
		% lw=get(ak(i),'LineWidth');
		% set(ak(i),'LineWidth',lw.*2);
	end;


	if isfield(H,'LineWidth'),
		set(ak(i),'LineWidth',2);
	end;

	h=get(ak(i),'children');
	for j=1:length(h),
		if strcmpi(get(h(j),'Type'),'text'),
			set(h(j),'Fontsize',12);
		end;
	end;
  end;

  % these need some special attention
  bh=findobj(ah,'-property','linewidth');
	set(bh,'LineWidth',2);
  bh=findobj(ah,'-property','fontsize');
	set(bh,'FontSize',14,'FontWeight','bold');

  th=findobj(ah,'-property','Title');
  	set(th,'FontSize',18,'FontWeight','bold');

  xh=findobj(ah,'-property','XLabel');
  	set(xh,'FontSize',14,'FontWeight','bold');

  yh=findobj(ah,'-property','YLabel'); 
  	set(yh,'FontSize',14,'FontWeight','bold'); 

end;

% print
% return hidden handles to the called state
set(0,'showhiddenhandles',showhiddenhandles);

end % for l=1:length(fig)

return;

