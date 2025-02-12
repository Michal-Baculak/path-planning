function s = get_length2(base, alphas)
    prof = get_length_profile(base,alphas).^2;
    if(isnan(prof(end)))
        s = sum(prof(1:end-1));
        return;
    end
    s = sum(prof);
end