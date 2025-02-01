function out = grad_w(base, alphas, w)
% calculates gradient of curvature^2-length given weight between the terms
% with respect to vector alpha
    alpha_mid = ones(size(alphas))*0.5;
    out = w*grad_k2(base, alphas)/get_curvature2(base, alpha_mid) +...
        (1-w)*grad_length(base,alphas)/get_length(base, alpha_mid);

end