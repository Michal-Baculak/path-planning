function plot_track(innerCones, outerCones)
    innerCones = [innerCones; innerCones(1,:)];
    outerCones = [outerCones; outerCones(1,:)];
    plot(innerCones(:,1), innerCones(:,2), LineStyle="-", Marker="o", Color=[0 1 0]);
    h_status = ishold; %save for restoring
    hold on;
    plot(outerCones(:,1), outerCones(:,2), LineStyle="-",Marker="o", Color=[0 0 1]);
    if(~h_status)
        hold off;
    end
    axis equal;
end