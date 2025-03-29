function k = get_curvature_profile(base, alphas)
    k = get_angle_profile(base, alphas)./get_length_profile(base,alphas);
    % pts = get_points(base, alphas);
    % sz = size(pts,1);
    % pts = [pts(end,:); pts; pts(1,:)];
    % k = [];
    % for I = 2:sz+1
    %     a = get_angle(pts(I-1,:), pts(I,:), pts(I+1,:));
    %     d = distance(pts(I,:), pts(I+1,:)); %TODO: shouldnt this be pts(I-1,:),pts(I,:) - NO
    %     k(I-1) = a/d;
    % end
end
