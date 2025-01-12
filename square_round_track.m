function [innerCones, outerCones] = square_round_track(a, b, r, w, ds)
    % Inputs:
    %   a - inner rectangle length in x-direction
    %   b - inner rectangle length in y-direction
    %   r - radius of the rounded corners for the inner rectangle
    %   w - track width (distance between inner and outer boundaries)
    %   ds - spacing between cones along the track

    % Output:
    %   innerCones - Nx2 array of [x, y] positions of cones for the inner boundary
    %   outerCones - Nx2 array of [x, y] positions of cones for the outer boundary

    % Initialize arrays for storing cone positions
    innerCones = [];
    outerCones = [];

    [x_inner, y_inner] = square_round(a, b, r, ds);
    [x_outer, y_outer] = square_round(a+2*w, b+2*w, r+w, ds);

    innerCones = [x_inner', y_inner'];
    outerCones = [x_outer'-w, y_outer'-w];
end
function [x, y] = square_round(a, b, r, ds)
    radial_spacing = ds/r;

    t1 = -pi:radial_spacing:-pi/2;
    x_c1 = cos(t1)*r + r;
    y_c1 = sin(t1)*r + r;
    hold on;
    axis equal

    x_l1 = r:ds:a-r;
    y_l1 = zeros(size(x_l1));
    if(x_l1(1) == x_c1(end) && y_l1(1) == y_c1(end))
        %2 same points
        x_l1 = x_l1(2:end);
        y_l1 = y_l1(2:end);
    end
    
    t2 = -pi/2:radial_spacing:0;
    x_c2 = cos(t2)*r + a - r;
    y_c2 = sin(t2)*r + r;
        % if(x_c2(1) == x_l1(end) && y_c2(1) == y_l1(end)) <-- always true
    %2 same points
    x_c2 = x_c2(2:end);
    y_c2 = y_c2(2:end);

    y_l2 = r:ds:b-r
    x_l2 = ones(size(y_l2))*a;
    if(x_l2(1) == x_c2(end) && y_l2(1) == y_c2(end))
        %2 same points
        x_l2 = x_l2(2:end);
        y_l2 = y_l2(2:end);
    end

    t3 = 0:radial_spacing:pi/2;
    x_c3 = cos(t3)*r+a-r;
    y_c3 = sin(t3)*r+b-r;
        % if(x_c3(1) == x_l2(end) && y_c3(1) == y_l2(end)) <-- always true
    %2 same points
    x_c3 = x_c3(2:end);
    y_c3 = y_c3(2:end);


    x_l3 = a-r:-ds:r;
    y_l3 = ones(size(x_l3))*b;
    if(x_l3(1) == x_c3(end) && y_l3(1) == y_c3(end))
        %2 same points
        x_l3 = x_l3(2:end);
        y_l3 = y_l3(2:end);
    end

    t4 = pi/2:radial_spacing:pi;
    x_c4 = cos(t4)*r + r;
    y_c4 = sin(t4)*r + b - r;
        % if(x_c4(1) == x_l3(end) && y_c4(1) == y_l3(end)) <-- always true
    %2 same points
    x_c4 = x_c4(2:end);
    y_c4 = y_c4(2:end);

    y_l4 = b-r:-ds:r;
    x_l4 = zeros(size(y_l4));

        % if(x_c1(1) == x_l4(end) && y_c1(1) == y_l4(end)) <-- always true
    %2 same points
    x_c1 = x_c1(2:end);
    y_c1 = y_c1(2:end);

    x = [x_c1,x_l1,x_c2,x_l2,x_c3,x_l3,x_c4,x_l4];
    y = [y_c1,y_l1,y_c2,y_l2,y_c3,y_l3,y_c4,y_l4];
end
