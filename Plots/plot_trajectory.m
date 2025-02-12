function plot_trajectory(base, alphas)
    pts = get_points(base, alphas);
    if(base(1,:) == base(end,:))
        pts = [pts; pts(1,:)];
    end
    plot(pts(:,1), pts(:,2), "kx-");
end