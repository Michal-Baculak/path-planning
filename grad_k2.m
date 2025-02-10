function out = grad_k2(base, alphas)
    out = ones(size(alphas));
    pts = get_points(base, alphas);
    angles = get_angle_profile(base, alphas);
    angles = [angles(end);angles;angles(1)];
    base = [base(end,:); base; base(1,:); base(2,:)];
    pts = [pts(end,:); pts; pts(1,:); pts(2,:)];
    for i = 2:length(alphas)+1
        xi = pts(i+1,1)-pts(i,1);
        yi = pts(i+1,2)-pts(i,2);
        xim1 = pts(i,1)-pts(i-1,1);
        yim1 = pts(i,2)-pts(i-1,2);
        xip1 = pts(i+2,1)-pts(i+1,1);
        yip1 = pts(i+2,2) - pts(i+1,2);
        fip1 = angles(i+1);
        A = -angles(i-1);   %(fim2-fim1);
        B = angles(i);      %(fi-fim1);
        C = (base(i,3)-base(i,1));
        D = (base(i,4)-base(i,2));
        E = xi^2+yi^2;
        F = xim1^2+yim1^2;
        G = angles(i+1);    %fip1-fi;
        dkim1_dai = (2*yim1*A-(-A)^2*2*xim1)*C/F^2+...
                    (2*xim1*(-A)-(-A)^2*2*yim1)*D/F^2;
        dki_dai = ((2*yi*(-B)*(-C)/E + 2*yim1*B*C/F+2*xi*B*(-D)/E+2*xim1*(-B)*D/F)*E-...
                    B^2*(2*xi*(-C) +2*yi*(-D)))/E^2;
        dkip1_dai = (2*yi*G*(-C)/E + 2*xi*(-G)*(-D)/E)/(xip1^2 + yip1^2);
        
        out(i-1) = dkim1_dai + dki_dai + dkip1_dai;
    end
end