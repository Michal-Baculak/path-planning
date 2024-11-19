function v = get_velocity_profile(base, alphas, vehicle)
    k = get_curvature_profile(base, alphas);
    v_k_based = sqrt(vehicle.a_max_lat./abs(k));
    v_model_based = min(vehicle.v_max, v_k_based);
    v = v_model_based;

    figure();
    subplot(3,1,1);
    scatter(1:100, get_curvature_profile(base, alphas));
    subplot(3,1,2);
    scatter(1:100, 1./(get_curvature_profile(base, alphas)))
    subplot(3,1,3);
    scatter(1:100, v);
end