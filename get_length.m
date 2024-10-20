function l = get_length(chckpnts, alphas)
    pnts = get_points(chckpnts, alphas);
    % loop the track for easier processing - add the first element to the
    % last position
    sz = size(pnts,1);
    pnts = [pnts; pnts(1,:)];
    l = 0;
    for I = 1:sz
        l = l + distance(pnts(I,:), pnts(I+1,:));
    end
end