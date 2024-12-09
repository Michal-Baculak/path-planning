function v = get_velocity_profile(base, alphas, vehicle)
    k = get_curvature_profile(base, alphas);
    ds = get_length_profile(base, alphas);
    v_k_based = sqrt(vehicle.a_max_lat./abs(k));
    v_model_based = min(vehicle.v_max, v_k_based);
    v_struct.k_based = v_k_based;
    v_struct.model_based = v_model_based;

    % video suggests to include v0 in inputs as a starting velocity
    % I say that I dont need to have starting velocity and position
    % specified
    % instead I can calculate the minimal velocity based on the curvature
    % and consider that velocity and position as the base point
    % from which we can only accelerate 
    % and which is guaranteed to be reached.  
    i_V_min = find(v_model_based == min(v_model_based)); %TODO: possibly multiple values returned
    V_min = v_model_based(i_V_min);
    v_struct.v_lat = v_model_based;

    % shift the track so that it starts at the point of minimal velocity
    v_model_based = [v_model_based(i_V_min:end), v_model_based(1:i_V_min-1)];
    k = [k(i_V_min:end), k(1:i_V_min-1)];
    ds = [ds(i_V_min:end), ds(1:i_V_min-1)];
    v = v_model_based;
    
    v_struct.v_lat_shift = v;
    % forward pass
    for I = 1:length(v_model_based)-1
        if(v(I) >= v(I+1))
            continue;
        end
        a_lat = v(I)^2*k(I);
        a_tires = vehicle.a_max_front*sqrt(1-(a_lat/vehicle.a_max_lat)^2);
        a_tires = real(a_tires); % due to floating point rounding errors, a_tires is sometimes complex
        a_motor = vehicle.a_max_front; %TODO - use power model to retrieve max motor acc
        a_avail = min(a_tires, a_motor);
        v_next_avail = sqrt(v(I)^2 + 2*a_avail*ds(I));
        v(I+1) = min(v(I+1), v_next_avail);
    end
    v_struct.v_forward_shift = v;
    % **backwards pass**
    % we need to take into account that racing track is closed loop, and so
    % that we need to ba able to brake from the last point of the track to
    % the first one (closing the loop)
    % that is why we modify the track so that after the last point of the
    % track comes the first point, and start our algorithm from this last
    % point
    v = [v,v(1)];
    k = [k, k(1)];
    ds = [ds, ds(1)];
    for I = length(v):-1:2
        if(v(I-1) < v(I))
            continue; %no breaking necessary 
        end
        a = v(I)^2;
        b = k(I-1)^2
        c = vehicle.a_max_lat
        d = vehicle.a_max_front;
        e = ds(I-1);
        v_avail = sqrt(c*(a*c+2*e*d*sqrt(4*e^2*b^2*d^2-a^2*b^2+c^2 ))/(c^2+4*e^2*b^2*d^2));
        v(I-1) = min(v_avail, v(I-1));
    end
    v_struct.v_backwards_shift = v;
    figure();
    A = v_struct.v_lat_shift; 
    B = v_struct.v_forward_shift;
    C = v_struct.v_backwards_shift;
    scatter(1:length(A),A, "r");
    hold on;
    scatter(1:length(B),B, "g");
    scatter(1:length(C),C, "b");

    % unshift !!!!
    v = v(1:end-1); % remove the last element
    %we need to undo the following line:
    %   v_model_based = [v_model_based(i_V_min:end), v_model_based(1:i_V_min-1)];
    len = length(v_model_based); 
    v_unshift = [v(len - i_V_min + 2:end), v(1:len - i_V_min + 1)];
    v = v_unshift; % value to be returned
    
    
    figure();
    scatter(1:length(v_struct.v_lat), v_struct.v_lat, "g");
    hold on;
    scatter(1:length(v), v, "b");
    % figure();
    % subplot(3,1,1);
    % scatter(1:100, get_curvature_profile(base, alphas));
    % subplot(3,1,2);
    % scatter(1:100, 1./(get_curvature_profile(base, alphas)))
    % subplot(3,1,3);
    % scatter(1:100, v);
end

function a = get_max_acc_long(vehicle, velocity)
    a = vehicle.a_max_front;
end