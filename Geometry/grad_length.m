function g = grad_length(base, alphas)
    % calculates the gradient of total length with respect to alphas
    % gradient = vector of partial derivatives (d{s}/d{alpha})
    pts = get_points(base, alphas);

    % connect the track
    pts = [pts(end,:); pts; pts(1,:)];
    base = [base(end,:); base; base(1,:)];

    g = zeros(size(alphas));
    for i = 2:length(alphas) + 1
        x_im1 = pts(i,1) - pts(i-1,1);
        y_im1 = pts(i,2) - pts(i-1,2);
        x_i = pts(i+1,1) - pts(i,1);
        y_i = pts(i+1,2) - pts(i,2);
        gi =    (base(i,3)-base(i,1))*( x_im1/sqrt(x_im1^2 + y_im1^2) - x_i/sqrt(x_i^2+y_i^2))+...
                (base(i,4)-base(i,2))*( y_im1/sqrt(x_im1^2 + y_im1^2) - y_i/sqrt(x_i^2+y_i^2));
        g(i-1) = gi;
    end
end