function [C,H,v]=isospice(p,Dr,COL,labels) 	% {{{
%ISOSPICE -	draws lines of equal spiciness on a TS plot
%
%USAGE -	[C,H,v]=isospice(p,Dr,COL,labels)
%
%EXPLANATION -	p - pressure level to compute spiciness (dbar) [always 0
% 			there is no pressure dependence of
% 			spiciness calculated]
%		Dr - matlab vector of spiciness contour levels to draw
%		COL - colour string
%		labels - label contours or not [not]
%
%SEE ALSO -
% 	spice, isopycnal

% }}}


%PROGRAM - 	MATLAB code by c.m.duncombe rae	% {{{
%
%CREATED -	2011-04-12 copied from isopycnal
%
%PROG MODS -	
% 
% }}}

% LICENSE	% {{{
% -------
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
% }}}

% figure(gcf);

if exist('p')~=1, p=[]; end; 
if isempty(p), p=0; end;

if exist('COL')~=1, COL=[]; end;
if isempty(COL), COL='r'; end;

if exist('Dr')~=1, Dr=0.1; end;
if isempty(Dr), Dr=0.1; end;

if exist('labels')~=1, labels=[]; end;
if isempty(labels), labels=0; end;

a=axis;
ra=(a(2)-a(1))./(a(4)-a(3));
da=[(a(2)-a(1)),a(4)-a(3)]./20 ;
s=a(1):da(1):a(2);
t=a(3):da(2):a(4);

S=s'*ones(1,size(t,2));
T=ones(size(s,2),1)*t;
R=spice(S,T,p);


% Fix min(v) so that it is an integral multiple of dr

if (max(size(Dr))==1),
	v=floor(min(min(R))./Dr).*Dr:Dr:ceil(max(max(R)));
else
	v=Dr;
end;

[C,H]=contour(s,t,R.',v,COL);
axis(a);

% Label isopycnals

if labels,
	n0=0; n1=0;
	while n1<length(C),
		n0=n1+1;
		n1=n1+C(2,n0)+1;
		l=C(1,n0);
		c=C(:,(n0+1):n1);
		[junk,I]=sort(c(1,:));
		c=c(:,I);
		% Only do the top right
		% ang=atan( (c(2,2)-c(2,1))./(c(1,2)-c(1,1))).*180./pi;
		% H=text(c(1,1),c(2,1),[' ' num2str(l)]);
		% set(H,'rotation',ang);
		n=length(c);
%
% 		multiply by the ratio (ra) of the axis scales
		ang=atan(    ra.* (c(2,n)-c(2,n-1))		...
				./			...
			     (c(1,n)-c(1,n-1)))          .*180./pi;
		% disp(ang)
		H=text(c(1,n),c(2,n),[' ' num2str(l-1000)]);
		set(H,'rotation',ang);
	end;
end;



return;
