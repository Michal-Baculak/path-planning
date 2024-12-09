function print_markers(base, alphas)
    pnts = get_points(base, alphas);
    n = length(pnts);
    for I = 1:n
        text(pnts(I,1)+0.2, pnts(I,2), string(I));
    end
end