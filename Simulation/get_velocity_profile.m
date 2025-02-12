%output contains:
%   out.v;          - velocity profile
%   out.a_lat;      - lateral acceleration profile
%   out.a_long;     - longtitudal acceleration profile
%   out.t_tot;      - total lap time
%   out.t           - time profile (time for each segment)

function v = get_velocity_profile(base, alphas, vehicle)

    %evaluate profiles
    k = get_curvature_profile(base, alphas);
    ds = get_length_profile(base, alphas);

    %max speed in corners
    v_k_based = sqrt(vehicle.a_max_lat./abs(k));

    %max speed of vehicle
    v_speed_limit = min(vehicle.v_max, v_k_based);

    %max speed of steering
    v_steering = zeros(size(v_k_based));
    k_closed = [k; k(1)];
    for i = 1:length(ds)
        dk = abs(k_closed(i+1) - k_closed(i));
        v_steering(i) = vehicle.c_steering*ds(i)/dk;
    end 

    v_speed_limit = min(v_speed_limit, v_steering);

    v_struct.k_based = v_k_based;
    % v_struct.steering_based = v_steering;
    v_struct.speed_limit= v_speed_limit;

    % video suggests to include v0 in inputs as a starting velocity
    % I say that I dont need to have starting velocity and position
    % specified
    % instead I can calculate the minimal velocity based on the curvature
    % and consider that velocity and position as the base point
    % from which we can only accelerate 
    % and which is guaranteed to be reached.  
    i_V_min = find(v_speed_limit == min(v_speed_limit)); %TODO: possibly multiple values returned
    V_min = v_speed_limit(i_V_min);
    v_struct.v_lat = v_speed_limit;

    % shift the track so that it starts at the point of minimal velocity
    v_speed_limit = [v_speed_limit(i_V_min:end); v_speed_limit(1:i_V_min-1)];
    k = [k(i_V_min:end); k(1:i_V_min-1)];
    ds = [ds(i_V_min:end); ds(1:i_V_min-1)];
    v = v_speed_limit;
    
    % forward pass
    for I = 1:length(v_speed_limit)-1
        if(v(I) >= v(I+1))
            continue;
        end
        a_lat = v(I)^2*k(I);
        a_tires = vehicle.a_max_front*sqrt(1-(a_lat/vehicle.a_max_lat)^2);
        a_tires = real(a_tires); % due to floating point rounding errors, a_tires is sometimes complex
        a_motor = get_max_acc_long(vehicle, v(I));% vehicle.a_max_front; %TODO - use power model to retrieve max motor acc
        a_avail = min(a_tires, a_motor);
        v_next_avail = sqrt(v(I)^2 + 2*a_avail*ds(I));
        v(I+1) = min(v(I+1), v_next_avail);
    end

    %save unshifted
    len = length(v_speed_limit); 
    v_struct.v_forward = [v(len - i_V_min + 2:end); v(1:len - i_V_min + 1)];
    
    % **backwards pass**
    % we need to take into account that racing track is closed loop, and so
    % that we need to ba able to brake from the last point of the track to
    % the first one (closing the loop)
    % that is why we modify the track so that after the last point of the
    % track comes the first point, and start our algorithm from this last
    % point
    v = [v;v(1)];
    k = [k; k(1)];
    ds = [ds; ds(1)];
    for I = length(v):-1:2
        if(v(I-1) < v(I))
            continue; %no breaking necessary 
        end
        Cx = 1/(2*ds(I-1)*vehicle.a_max_brake);
        Cy = k(I-1)/vehicle.a_max_lat;
        v_avail = sqrt( (2*Cx^2*v(I)^2+sqrt(4*Cx^4*v(I)^4-4*(Cx^2+Cy^2)*(Cx^2*v(I)^4-1))) / (2*(Cx^2+Cy^2)) );
        v(I-1) = min(v_avail, v(I-1));
    end

    % unshift !!!!
    v = v(1:end-1); % remove the last element
    %we need to undo the following line:
    %   v_model_based = [v_model_based(i_V_min:end); v_model_based(1:i_V_min-1)];
    % reminder: len = length(v_speed_limit); 
    v_unshift = [v(len - i_V_min + 2:end); v(1:len - i_V_min + 1)];
    v = v_unshift; % value to be returned
    v_struct.v_backward = v;

    % figure;
    % plot(1:length(v_struct.k_based),v_struct.k_based,"r");
    % hold on;
    % % plot(1:length(v_struct.k_based),v_struct.steering_based,"b");
    % plot(1:length(v_struct.k_based),v_struct.speed_limit,"g");
    % plot(1:length(v_struct.k_based),v_struct.v_forward,"Color","magenta");
    % plot(1:length(v_struct.k_based),v_struct.v_backward,"k");
    % 
    % legend("maximálna rýchlosť v zákrutách", "obmedzenie steeringu","maximálna rýchlosť","zohľadnenie zrýchlenia", "zohľadnenie brzdenia");
    % ylabel("v (m/s)");
    % xlabel("bod trajektórie");
end

function a = get_max_acc_long(vehicle, velocity)
    % Simple version - do not take engine power into account
    %a = vehicle.a_max_front; 

    % Elaborate version: acceleration depends upon actual velocity
    % P = F*v = m*a*v; a = P/(m*v)
    a = vehicle.max_power/(velocity*vehicle.mass);
end