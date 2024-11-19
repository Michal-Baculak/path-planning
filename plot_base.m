function plot_base(base)
    for I = 1:size(base,1)
        plot([base(I,1) base(I,3)], [base(I,2) base(I,4)], "r-");
    end
end