function k = get_curvature2(chckpnts, alphas)
    pts = get_points(chckpnts, alphas);
    sz = size(pts,1);
    pts = [pts(end,:); pts; pts(1,:)];
    k = 0;
    for I = 2:sz+1
        a = get_angle(pts(I-1,:), pts(I,:), pts(I+1,:));
        d = distance(pts(I,:), pts(I+1,:));
        k = k + (a/d)^2;
    end
end