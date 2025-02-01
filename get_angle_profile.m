function out = get_angle_profile(base, alphas)
    pts = get_points(base, alphas);
    pts = [pts(end,:); pts; pts(1,:)];
    out = ones(size(alphas));
    for i = 2:length(alphas)+1
        out(i-1) = get_angle(pts(i-1,:),pts(i,:),pts(i+1,:));
    end
end