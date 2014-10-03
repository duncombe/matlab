function [aprioriT, aprioriS]=apriori(S, T, v, dd, indx);
%  --------------------------------------------------------------
%  function [aprioriT, aprioriS]=a_priori(S, T, v, dd, indx);
%
%  S & T    mxn
%  v        a vector of differences in travel time: TAUi-TAUj
%  dd       a vector of TAU differences you want to look at, from
%           a large difference and going towards zero.
%  indx     a vector of all the TAU differences.
%
%  S, T, v, and indx are found by using tau_diff.  You need to
%  supply dd yourself.
%
%  This finds the station pairs that meet the difference range and 
%  computes the a priori error as:
%
%  apriori^2 = 1/2 <(Ti-Tj)^2>   for the limit as the difference
%                                in tau goes to zero.
%
%  --------------------------------------------------------------
for ii=1:length(dd)

  jj=find(abs(v)<=dd(ii));               % MUST use absolute value.
  hh=indx(jj);

  first=floor(hh/length(T(1,:)))+1;      % First station in pair
  second=hh-((first-1)*length(T(1,:)));  % Second station in pair

  Tdiff=T(:,first)-T(:,second);
  Sdiff=S(:,first)-S(:,second);

  if length(Tdiff(1,:))>1
    Tap=.5*(mean(Tdiff.^2')'); % HUH?  apriori^2 = 1/2 <(Ti-Tj)^2>  for the limit
    Sap=.5*(mean(Sdiff.^2')'); % as the difference in tau goes to zero.
    aprioriT(:,ii)=sqrt(Tap);
    aprioriS(:,ii)=sqrt(Sap);
  else 
    aprioriT(:,ii)=.5*Tdiff.^2;
    aprioriS(:,ii)=.5*Sdiff.^2;
  end

end
return

