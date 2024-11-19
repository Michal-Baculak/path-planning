function simulate_profile(vel_profile, innerCones, outterCones, base, alphas,t_s)
    figure
    plot_track(innerCones,outterCones)
    hold on
    plot_base(base);
    plot_trajectory(base, alphas);
    % Prepare the figure
    h = plot(nan, nan, 'bo', 'MarkerSize', 10); % Initialize point   

    % prepare data - simulate through time
    t = 0;
    s = 0;
    I = 0;
    l_i = get_length_profile(base, alphas);
    s_m = sum(l_i);
    coords = []
    while (1)
        [x, y, I] = get_coords_by_dist(base, alphas, s);
        coords = [coords; [x, y, s, t]];
        s = s + vel_profile(I)*t_s;
        if(s > s_m)
            break;
        end
        t = t + t_s;
    end
    
    %simulate
    for J = 1:length(coords)
        set(h, 'XData', coords(J,1), 'YData', coords(J,2)); % Update point position
        drawnow; % Render updates
        pause(t_s); % Pause to control speed
        coords(J,3)
        coords(J,4)
    end
end
function [x, y, I] = get_coords_by_dist(base, alphas, dist)
    l_i = get_length_profile(base, alphas);
    I = 0;
    while (dist >= 0)
        I = I + 1;
        dist = dist - l_i(I);
    end
    %dist is negative 
    dist = dist + l_i(I);
    pts = get_points(base, alphas);
    pts = [pts; pts(1,:)];
    out = pts(I,:) + (pts(I+1,:) - pts(I,:))*dist/l_i(I);
    x = out(1);
    y = out(2);
end