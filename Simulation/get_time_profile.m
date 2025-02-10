function t = get_time_profile(base, alphas, vehicle)
    v_prof = get_velocity_profile(base, alphas, vehicle);
    pts = get_points(base, alphas);
    ds = get_length_profile(base, alphas);
    % s = v*t, t = s/v
    t = ds./v_prof;
end