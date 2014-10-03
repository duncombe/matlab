function [D,nr,c] = unique(R)
% UNIQUE  Extraction of unique rows out of matrix
%	[D,NR,C] = UNIQUE(R)  Returns matrix D containing
%	unique rows of input matrix R,
%	vector NR (size(R,1) by 1) showing index into rows
%	of D for each row of R,
%	vector C (size(D,1) by 1) containing number of
%	occurences (count) in R of each row of D.

%  Based on the program MUNIQUE.M by Richard Aufrichtig
%  (winner of M-file contest V3.0)

%  Copyright (c) 1995  by Kirill K. Pankratov
%	kirill@plume.mit.edu
%	8/10/94, 05/12/95

if nargin==0, help unique, return, end

y = R*rand(size(R,2),1);
[y,i] = sort(y);
y = find([1; diff(y)]);

nr = zeros(size(R,1),1);
nr(y) = [i(1); diff(i(y))];
nr(i) = cumsum(nr);
y = sort(nr);
c = find(diff([y; length(nr)+1]));
c = [c(1); diff(c)];

y = zeros(size(nr));
y(nr) = ones(size(nr));
i = find(y);
y(i) = 1:length(i);
nr = y(nr);
D(nr,:) = R;

