function t = get_time_profile(base, alphas, v_prof)
    pts = get_points(base, alphas);
    ds = get_length_profile(base, alphas);
    % s = v*t, t = s/v
    t = ds./v_prof;
end