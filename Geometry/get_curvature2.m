function k = get_curvature2(base, alphas)
    prof = get_curvature2_profile(base,alphas);
    if(isnan(prof(1)))
        k = sum(prof(2:end-1));
        return;
    end
    k = sum(prof);
end