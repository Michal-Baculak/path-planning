function plot_trajectory(base, alphas)
    pts = get_points(base, alphas);
    pts = [pts; pts(1,:)];
    plot(pts(:,1), pts(:,2), "kx-");
end