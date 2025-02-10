function a = get_angle(A, B, C)
    %A----B
    %  (a) \
    %       C
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