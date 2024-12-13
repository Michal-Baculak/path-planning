function simulate_profile(vel_profile, innerCones, outterCones, base, alphas,t_s, vehicle)
    
    % Prepare the tire figure
    figure
    t = linspace(0,2*pi,100);
    x_ell = vehicle.a_max_lat*cos(t)
    y_ell = vehicle.a_max_brake*sin(t);
    plot(x_ell, y_ell, "k");
    hold on;
    h_tire = plot(nan, nan, 'bo', 'MarkerSize', 10); % Initialize point
    axis equal;
    hold off;

    % Prepare the track figure
    figure
    plot_track(innerCones,outterCones)
    hold on
    plot_base(base);
    plot_trajectory(base, alphas);
    h_track = plot(nan, nan, 'bo', 'MarkerSize', 10); % Initialize point 
    
    % prepare data - simulate through time
    t = 0;
    s = 0;
    I = 0;
    l_i = get_length_profile(base, alphas);
    s_m = sum(l_i);
    coords = []; % coords of the formula on map
    a_coords = []; % tire dynamics
    a_prof = get_acceleration_profile(base, alphas, vel_profile);
    while (1)
        [x, y, I] = get_coords_by_dist(base, alphas, s);
        coords = [coords; [x, y, s, t]];
        s = s + vel_profile(I)*t_s;
        a_coords = [a_coords; a_prof.a_lat(I), a_prof.a_long(I)];
        if(s > s_m)
            break;
        end
        t = t + t_s;
    end
    
    %simulate
    for J = 1:length(coords)
        set(h_track, 'XData', coords(J,1), 'YData', coords(J,2)); % Update point position
        set(h_tire, 'XData', a_coords(J,1), 'YData', a_coords(J,2)); % Update point position
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