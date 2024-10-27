function plot_base(base)
    hold on;
    for I = 1:size(base,1)
        plot([base(I,1) chckpnts(I,3)], [base(I,2) base(I,4)], "r-");
    end
end