function cost = get_cost_weighted(base, alphas, weight)
% get_cost_weighted computes the cost of track based on length and
% curvature squared, given the weight
% Inputs:
%   base    - track parametrization
%   alphas  - position on the track with given parametrization
%   weight  - continuous value from interval (0;1), where 0 is optimization
%               purely based on length, 1 is based solely on curvature squared
k = get_curvature2(base, alphas);
l = get_length(base, alphas);

% transform both parameters to the same base (length is orders of magnitude
% larger than curvature of a track
% idea: normalize by comparing to the midpoint track
k_midpoint = get_curvature2(base, ones(size(base))*0.5);
l_midpoint = get_length(base, ones(size(base))*0.5);

k_norm = k/k_midpoint;
l_norm = l/l_midpoint;

cost = weight*k_norm + (1-weight)*l_norm;
end
