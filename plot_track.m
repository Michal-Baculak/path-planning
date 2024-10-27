function plot_track(innerCones, outerCones)
    hold on
    plot(innerCones(:,1), innerCones(:,2), LineStyle="-", Marker="o", Color=[0 1 0]);
    hold on
    plot(outerCones(:,1), outerCones(:,2), LineStyle="-",Marker="o", Color=[0 0 1]);
    axis equal
end