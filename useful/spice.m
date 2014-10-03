function spiciness = spice(s,t,p)		% {{{
%SPICE - spiciness by Flament	
% 
%USAGE -	spiciness = spice(s,t,p)
% 		spiciness = spice(V)
%
%EXPLANATION -	
%		s,t,p = the usual
% 		if called with a single argument,
% 		V  is a matrix [s, t, p] 
%
%SEE ALSO -	
%
% Reference is:
% FLAMENT, P., 2002. A state variable for characterizing water
% 	masses and their diffusive stability: spiciness. Prog.
% 	Oceanogr., 54(1--4): 493-501.
%
% Found at http://www.phys.ocean.dal.ca/~mirshak/matlab/spice.m
% Home page at http://www.satlab.hawaii.edu/spice/
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae		% {{{
%
%CREATED -	2006/08/02 downloaded
% function spiciness = spice(p,t,s)
% adapted from algorithm developed by
% P. Flament.
%
% SCKennan(Dec92)
%
%	$Revision: 1.6 $
%	$Date: 2011-04-12 18:05:08 $
%	$Id: spice.m,v 1.6 2011-04-12 18:05:08 duncombe Exp $
%	$Name:  $
% 
%PROG MODS -	
%  2011-03-27 
% 	Vectorize original function
% 
% }}}

% LICENSE		% {{{
% -------
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

% }}}

%		notes: vectorizing is possible when s and t are
%		scalars. When s and t are vectors or matrix then
% 		this algorithm might be easiest. But still
% 		doable (using t(:) and reshape).
%
% vectorize by S=(s-35).^[0:5];T=t.^[0:4];spic=(B*T) *S; or
% something.
%
% The something would be
%	T=repmat([t(:)],1,6).^repmat([0:5],length(t),1);
%	S=repmat([(s(:)-35)],1,5).^repmat([0:4],length(s),1);
% 	spiciness=sum(T*B.*S,2);


% spice(p=0,T=15,S=33)=0.54458641375

B(1,:) = [ 0, 7.7442e-001, -5.85e-003, -9.84e-004, -2.06e-004];
B(2,:) = [ 5.1655e-002, 2.034e-003, -2.742e-004, -8.5e-006, 1.36e-005];
B(3,:) = [ 6.64783e-003, -2.4681e-004, -1.428e-005, 3.337e-005, 7.894e-006];
B(4,:) = [ -5.4023e-005, 7.326e-006, 7.0036e-006, -3.0412e-006, -1.0853e-006];
B(5,:) = [ 3.949e-007, -3.029e-008, -3.8209e-007, 1.0012e-007, 4.7133e-008];
B(6,:) = [ -6.36e-010, -1.309e-009, 6.048e-009, -1.1409e-009, -6.676e-010];

N=nargin;
if N==1, 
	if size(s,2)>=3,
		p=s(:,3);
		t=s(:,2);
		s=s(:,1);
	elseif size(s,2)==2,
		t=s(:,2);
		s=s(:,1);
		p=zeros(size(t));
	end;
end;

% should test s,t,p the same size!

[r,c] = size(t);

S=repmat([s(:)-35],1,5).^repmat([0:4],length(s(:)),1);
T=repmat([t(:)],1,6).^repmat([0:5],length(t(:)),1);

Sp = sum(T*B.*S,2);

spiciness = reshape(Sp,r,c);

return;

