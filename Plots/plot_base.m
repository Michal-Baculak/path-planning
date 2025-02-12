function plot_base(base)
    % Closed track checking
    sz = size(base,1);
    if(base(end,:) == base(1,:))
        sz = sz-1;
    end

    h_status = ishold; %save for restoring
    for I = 1:sz
        plot([base(I,1) base(I,3)], [base(I,2) base(I,4)], "r-");
        hold on;
    end
    if(~h_status)
        hold off;
end