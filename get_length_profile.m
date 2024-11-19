function l = get_length_profile(base, alphas)
    pts = get_points(base, alphas);
    pts = [pts;pts(1,:)]  % assume closed track - first point comes after the last
    l = [];
    for I = 1:length(pts)-1
        l(I) = distance(pts(I,:), pts(I+1,:));
    end
end