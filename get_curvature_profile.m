function k = get_curvature_profile(base, alphas)
    pts = get_points(base, alphas);
    sz = size(pts,1);
    pts = [pts(end,:); pts; pts(1,:)];
    k = []
    for I = 2:sz+1
        a = get_angle(pts(I-1,:), pts(I,:), pts(I+1,:));
        d = distance(pts(I,:), pts(I+1,:)); %TODO: shouldnt this be pts(I-1,:),pts(I,:)
        k(I-1) = a/d;
    end
end

function a = get_angle(A, B, C)
    %A----B
    %  (a) C
    l1 = B-A;
    l2 = C-B;
    a1 = atan2(l1(2), l1(1));
    a2 = atan2(l2(2), l2(1));
    a = a2 - a1;
    if(a > pi)
        a = a - 2*pi;
    end
    if(a < -pi)
        a = a + 2*pi;
    end
end