function M=filecomp(files)
% compare a list of files for which are the same
% cell files

% programming notes: look at the functions implementing SET operations
% (intercept, union, setxor, etc.)

A=[];
for f=1:length(files),
	fid=fopen(files{f});
	a=fread(fid,[1,inf],'uchar').';
	[a,A]=samerows(a,A);
	A=[A,a]; 
	fclose(fid);
end;

I=find(isnan(A));
A(I)=Inf;

% make the A three dimensional and permute it so as to prepare to
% pass to bsxfun. bsxfun does the expansion and tests not equal.
% Use sum to determine which files have any differing characters,
% squeeze to remove singular dimensions, remove the diagonal
% (comparing each file with itself) with eye, take the lower
% triangle (acutally could forget removing the diagonal and just
% tkae lower or upper triangle) and find. 
[J,K]=find(tril(~squeeze(sum(bsxfun(@ne,A(:,:,1),permute(A,[1,3,2])),1))-eye(length(files),length(files))));

% each pair [J,K] is now files that are the same



