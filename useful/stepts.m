function stepts(CTD,POS,TIM,FIL,STN,CTDindex)
%STEPTS - 	Steps station by station through CTD data output from VIEWS87S
% 
%USAGE -	stepts(CTD,POS,TIM,FIL,STN,CTDindex)
%
%EXPLANATION -	CTD, POS, TIM, FIL, STN, CTDindex: are outputs from VIEWS87S
%
%SEE ALSO -	views87s
%

%PROGRAM - 	MATLAB code by c.m.duncombe rae
%
%CREATED -	2002-06-07
%
%PROG MODS -	
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

M=size(CTDindex,1);

% figure(tsfig);
posfig=figure; set(posfig,'position',[1,200,497,576]);
	plot(POS,'.');
	hold on;
	for k=1:M,
		S=[S; plot(POS(k),'go','visible','off')];
	end;
	axis('equal');
	coast;
	
tsfig=figure; set(tsfig,'position',[500,200,497,576]);
	plot(CTD(:,1),CTD(:,2),'.');
	hold on;
	for k=1:M,
		i=CTDindex(k,1);
		j=CTDindex(k,2);
		P=[	P; 
			plot(CTD(i:j,1),CTD(i:j,2),'g',...
				'visible','off',...
				'linewidth',3)
		];
	end;

	BUTTON=0; k=0;
	more off;
	while BUTTON ~= 2,
		[x,y,BUTTON]=ginput(1);
		if k>0,
			set(P(k),'visible','off');
			set(S(k),'visible','off');
		end
		title('');
		if BUTTON==1,
			k=k-1;
			if k<1, k=M; disp('wrapped to end'); end; 
		end;
		if BUTTON==3,
			k=k+1;
			if k>M, k=1; disp('wrapped to start'); end;
		end;
		if BUTTON~=2,
			disp(FIL(k,:));
			set(P(k),'visible','on');
			set(S(k),'visible','on');
			title(STN(k,:));
		end;
	end;
	more on;
return;

