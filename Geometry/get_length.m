function l = get_length(base, alphas)
    prof = get_length_profile(base,alphas);
    if(isnan(prof(end)))
        l = sum(prof(1:end-1));
        return;
    end
    l = sum(prof);
end