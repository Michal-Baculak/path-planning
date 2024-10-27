function plot_trajectory(base, alphas)
    pts = get_points(base, alphas);
    hold on;
    plot(pts(:,1), pts(:,2), "kx-");
end