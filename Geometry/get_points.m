function P = get_points(base, alfas)
    P = [];
    for I = 1:size(base,1)
        A = base(I,1:2);
        B = base(I,3:4);
        P = [P; A + alfas(I)*(B-A)];
    end
end