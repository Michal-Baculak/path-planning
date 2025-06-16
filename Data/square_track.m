function [innerCones outerCones] = square_track(side, ds)
    %cone every ds meters
    %_____c_____
    %|  __g___  |
    %| |      | |
    %d h      f |
    %| |___e__| b
    %|____a_____|
    n_1 = ceil((side+6)/ds);
    a = [linspace(0,side+6, n_1)', zeros(n_1, 1)];
    b = [ones(n_1,1)*(side+6), a(:,1)];
    c = [linspace(side+6, 0, n_1)', ones(n_1,1) *(side+6)];
    d = [zeros(n_1, 1), linspace(side+6, 0, n_1)'];
    
    outerCones = [a(2:end,:);b(2:end,:);c(2:end,:);d(2:end,:)];

    n_2 = ceil(side/ds);
    e = [linspace(3, side + 3, n_2)', ones(n_2, 1)*3];
    f = [ones(n_2,1) * (3 + side), linspace(3,side + 3,n_2)'];
    g = [linspace(side+3, 3, n_2)', ones(n_2, 1)*(side+3)];
    h = [ones(n_2, 1)*3, linspace(side+3, 3, n_2)'];

    innerCones = [e(2:end,:);f(2:end,:);g(2:end,:);h(2:end,:)];
    figure;
    plot(outerCones(:,1), outerCones(:,2), "bo"); 
    hold on;
    plot(innerCones(:,1), innerCones(:,2), "bo");
end
