function P = get_points(base, alphas)
    P = [];
    for I = 1:length(alphas)
        A = base(I,1:2);
        B = base(I,3:4);
        P = [P; A + alphas(I)*(B-A)];
    end
end