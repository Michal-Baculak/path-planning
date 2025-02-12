function l = get_length_profile(base, alphas)
    l = zeros(length(alphas),1);
    pts = get_points(base, alphas);
    if(base(1,:)==base(end,:))
        
        % Closed track - first point comes after the last
        pts = [pts;pts(1,:)];  
        for I = 1:length(pts)-1
            l(I,1) = distance(pts(I,:), pts(I+1,:));
        end
        return;
    end    

    % Open track
    l(end) = NaN;
    for I = 1:length(alphas)-1
        l(I,1) = distance(pts(I,:), pts(I+1,:));
    end
end