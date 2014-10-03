function A=ntasclipstruct(B,fld,rng)
%CLIPSTRUCT - extract data in the range of a reference field 
% 
%USAGE -	A=ntasclipstruct(B,fld,rng)
%
%EXPLANATION -	clip data in struct B to the range rng in B.(fld). Return
%		new clipped struct in A
%
%SEE ALSO -	
%

% }}}

%PROGRAM - 	MATLAB code by c.m.duncombe rae   % {{{
%
%CREATED -	2011-08-09 
%	$Revision: 1.4 $
%	$Date: 2012-01-11 14:01:30 $
%	$Id: ntasclipstruct.m,v 1.4 2012-01-11 14:01:30 duncombe Exp $
%	$Name:  $
%
%CHANGELOG -	
% 
% }}}

% License {{{
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

confirm=0;
didclip=0;

A=B;

I=between(B.(fld),rng); 
M=length(B.(fld)); 
L=length(I);

if M>L
    fields=fieldnames(B);
    [m,n]=size(B.(fld));

    j=find([m,n]==1);

    if length(j)==2 || length(j)==0, 
	error('search field must be a vector'); 
    end;

    N=max([m,n]);

    for i=1:length(fields),
	[m,n]=size(B.(fields{i}));
	j=find([m,n]==N);
	if length(j)>0, 
		if j==1,
			A.(fields{i})=B.(fields{i})(I,:);
		else
			A.(fields{i})=B.(fields{i})(:,I);
		end
	end
    end
    didclip=1;
end

if confirm, 
	if didclip, 
		disp(['data was clipped ' num2str(M-L) '/' num2str(M)]); 
	else 
		disp('data was not clipped');
	end
end



