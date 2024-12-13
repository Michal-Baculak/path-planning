%   out.a_lat
%   out.a_long
function out = get_acceleration_profile(base, alphas, v_prof)
    ds = get_length_profile(base, alphas);
    k = get_curvature_profile(base, alphas);
    out.a_lat = v_prof.^2.*k;

    % loop the velocity_profile - assume closed track
    v_prof(end+1) = v_prof(1);
    for I = 1:length(v_prof)-1
        dv = v_prof(I+1)-v_prof(I);
        out.a_long(I) = dv/ds(I)*(v_prof(I)+1/2*dv);
    end
end