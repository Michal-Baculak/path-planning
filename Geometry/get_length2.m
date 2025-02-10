function s = get_length2(base, alphas)
    pts = get_points(base, alphas);
    sz = size(pts, 1);
    pts = [pts; pts(1,:)];
    s = 0;
    for I = 1:sz
        s = s + (pts(I,1) - pts(I+1,1))^2 + (pts(I,2) - pts(I+1,2))^2;
    end
end