function out = get_angle_profile(base, alphas)
    pts = get_points(base, alphas);    
    out = zeros(length(alphas),1);
    % Closed track
    if(base(1,:) == base(end, :))
        pts = [pts(end,:); pts; pts(1,:)];
        for i = 2:length(alphas)+1
            out(i-1) = get_angle(pts(i-1,:),pts(i,:),pts(i+1,:));
        end
        return;
    end

    %Open track
    out(1) = NaN;
    out(end) = NaN;
    for i = 2:length(alphas)-1
        out(i) = get_angle(pts(i-1,:),pts(i,:),pts(i+1,:));
    end
end