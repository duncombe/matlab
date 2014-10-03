function [cid, alpha, mu] = circ_clust(alpha, numclust, disp)
%
% [cid, alpha, mu] = circClust(alpha, numclust, disp)
%   Performs a simple agglomerative clustering of angular data.
%
%   Input:
%     alpha     sample of angles
%     numclust  number of clusters desired, default: 2
%     disp      show plot at each step, default: false
%
%   Output:
%     cid       cluster id for each entry of alpha
%     alpha     sorted angles, matched with cid
%     mu        mean direction of angles in each cluster
%
%   Run without any input arguments for demo mode.
%
% Circular Statistics Toolbox for Matlab

% By Marc J. Velasco, 2009
% velasco@ccs.fau.edu
% Distributed under Open Source BSD License


if nargin < 2, numclust = 5; end;
if nargin < 3, disp = 0; end
if nargin < 1
    % demo mode
    n = 20;
    alpha = 2*pi*rand(n,1)-pi;
    numclust = 4;
    disp = 1;
end;

n = length(alpha);
if n < numclust, error('Not enough data for clusters.'), end

% prepare data
alpha = sort(alpha);
cid = (1:n)';
z = exp(i*alpha);

% clean up from last run....
h = figure(1); close(h);
h = figure(2); close(h);
h = figure(3); close(h);

% plot original data
if disp
    figure(1);
    polar(angle(z), abs(z), '.')
    figure(1);
end

% main clustering loop
num_unique = length(unique(cid));
num_clusters_wanted = numclust;

while(num_unique > num_clusters_wanted)

    % find centroid means...
    
    % calculate the means for each putative cluster
    for j=1:n
        if ~isempty(alpha(cid==j))
            mu(j) = angle(sum(exp(i*alpha(cid==j))));
            r(j) = abs((1/length(alpha(cid==j)))*sum(exp(i*alpha(cid==j))));
        else
            mu(j) = NaN; r(j) = NaN;
        end
    end
    
    % make mu column
    if size(mu,1) == 1
        mu = mu';
        r = r';
    end

    % find distance between centroids...
    mudist = abs(circ_dist2(mu));

    % find closest pair of clusters/datapoints
    mindist = min(mudist(tril(mudist)~=0));
    [row, col, val] = find(abs((mudist-mindist)) <1e-10);
    
    % update cluster id's
    cid(cid==max(row)) = min(row);

    % update stop criteria
    num_unique = length(unique(cid));

    % plot, if wanted
    if disp
        figure(3);
        clf;
        
        % calculate means with new cluster assignments
        for j=1:n
            if ~isempty(alpha(cid==j))
                mu(j) = angle(sum(exp(i*alpha(cid==j))));
                r(j) = abs((1/length(alpha(cid==j)))*sum(exp(i*alpha(cid==j))));

            else
                mu(j) = NaN; r(j) = NaN;
            end
        end
        
        % plot output
        z2 = exp(i*alpha);
        plotColor(real(z2), imag(z2), cid, 3)
        
        % scale down r a little
        zmu = .9*r.*exp(i*mu);
        plotColor(real(zmu), imag(zmu), cid, 3, '*', 10, 1)
        set(gca, 'XLim', [-1, 1]);
        set(gca, 'YLim', [-1, 1]);
        
        display('paused... hit space to continue.')
        pause
        
    end
end

% renumber cluster ids (so cids [1 3 7 10] => [1 2 3 4]
cid2 = cid;
uniquecids = unique(cid);
for j=1:length(uniquecids)
   cid(cid2==uniquecids(j)) = j;
end

% compute final cluster means
for j=1:n
    if ~isempty(alpha(cid==j))
        mu(j) = angle(sum(exp(i*alpha(cid==j))));      
        r(j) = abs((1/length(alpha(cid==j)))*sum(exp(i*alpha(cid==j))));
    else
        mu(j) = NaN; r(j) = NaN;
    end
end

% make mu column
if size(mu,1) == 1
    mu = mu';
end

if disp
    % plot output
    z2 = exp(i*alpha);
    plotColor(real(z2), imag(z2), cid, 2)
    zmu = r.*exp(i*mu);
    plotColor(real(zmu), imag(zmu), cid, 2, '*', 10, 1)

    set(gca, 'XLim', [-1, 1]);
    set(gca, 'YLim', [-1, 1]);
end



function plotColor(x, y, c, varargin)
% FUNCTION plotColor(x, y, c, [figurenum], [pstring], [markersize], [overlay_tf]);
% plots a scatter plot for x, y, using color values in c (c should be
% categorical info), with c same size as x and y;
% fourth argument can be figure#, otherwise, uses figure(1);
%
% colors should be positive integes

% copyright (c) 2009 Marc J. Velasco

if nargin < 4
    figurenum = 1;
else
   figurenum = varargin{1}; 
end
if nargin < 5
    pstring = '.';
else
   pstring = varargin{2}; 
end
if nargin < 6
    ms = 10;
else
   ms = varargin{3}; 
end
if nargin < 7
    overlay = 0;
else
   overlay = varargin{4}; 
end

csmall = unique(c);
figure(figurenum);
if ~overlay, close(figurenum); end
figure(figurenum);

colors={'y', 'b', 'r', 'g', 'c', 'k', 'm'};

hold on;
for j=1:length(csmall);
    
   ci = (c == csmall(j));
   plot(x(ci), y(ci), strcat(pstring, colors{mod(j, length(colors))+1}), 'MarkerSize', ms);
    
end
if ~overlay, hold off; end
figure(figurenum)






