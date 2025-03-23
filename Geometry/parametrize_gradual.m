function [base] = parametrize_gradual(innerCones, outterCones, ds, is_closed)

    %1. calculate splines for origin and direction
    %2. move with resolution ds
    %3. On each point construct a line perpendicular to local derivative, and
    %   mark point, where it intersects outterCones
    %4. Save the 2 points as line segment in base

    %% 1. calculate splines for origin and direction
    base = [];
    outterCones(end+1,:) = outterCones(1,:);

    t_orig =  [];
    origins_x = [];
    origins_y = [];

    t_dir = [];
    dir_x = [];
    dir_y = [];
    totalLength = 0;
    if(is_closed)
        t_orig = zeros(length(innerCones),1);
        origins_x = t_orig;
        origins_y = t_orig;
        cones = [innerCones(end,:);innerCones;innerCones(1,:);innerCones(2,:)];
        for i = 1:(length(t_orig))
            t_orig(i) = totalLength;
            origins_x(i) = cones(i+1,1);
            origins_y(i) = cones(i+1,2);
            totalLength = totalLength + distance(cones(i+1,:), cones(i+2,:));
        end
        t_orig(end+1) = totalLength;
        origins_x(end+1) = cones(2,1);
        origins_y(end+1) = cones(2,2);
        t_dir = zeros(length(innerCones) + 2,1);
        dir_x = t_dir;
        dir_y = t_dir;
        %consider the last cone as the first, then subtract accordingly
        s = 0;
        for i = 1:length(t_dir)
            % find dx, dy
            % construct direction vector
            % set the location of calculated vector to the middle of
            % current side
            dx = cones(i+1,1) - cones(i,1);
            dy = cones(i+1,2) - cones(i,2);
            dist = distance(cones(i+1,:), cones(i,:));
            s = s + dist;
            t_dir(i) = s - dist/2;
            dir_x(i) = -dy;
            dir_y(i) = dx;
        end
        % shift back to the real beginning of track
        t_dir = t_dir - distance(cones(1,:), cones(2,:));
    else
        % open track
        cones = innerCones;
        t_orig = zeros(length(cones)-1, 1);
        origins_x = t_orig;
        origins_y = t_orig;
        for i = 1:length(t_orig)
            t_orig(i) = totalLength;
            origins_x(i) = cones(i,1);
            origins_y(i) = cones(i,2);            
            totalLength = totalLength + distance(cones(i,:), cones(i+1,:));
        end
        t_orig(end+1) = totalLength;
        origins_x(end+1) = cones(end,1);
        origins_y(end+1) = cones(end,2);
        t_dir = zeros(length(cones) -1,1);
        dir_x = t_dir;
        dir_y = t_dir;
        s = 0;
        for i = 1:length(t_dir)
            dx = cones(i+1,1) - cones(i,1);
            dy = cones(i+1,2) - cones(i,2);
            dist = distance(cones(i+1,:), cones(i,:))
            s = s + dist;
            t_dir(i) = s - dist/2;
            dir_x(i) = -dy;
            dir_y(i) = dx;          
        end
        t_dir = [0; t_dir; totalLength];
        dir_x = [dir_x(1);dir_x; dir_x(end)];
        dir_y = [dir_y(1);dir_y; dir_y(end)];
    end
    
    %% 2. Move along innerCones with step size
    for s = 0:ds:totalLength
        s
        p1_x = interp1(t_orig, origins_x,s,"linear");
        p1_y = interp1(t_orig, origins_y,s,"linear");
        k_x = interp1(t_dir, dir_x,s,"linear");
        k_y = interp1(t_dir, dir_y,s,"linear");
        p1 = [p1_x, p1_y];
        k_n = [k_x, k_y];
    %% 5. On each point construct a line perpendicular to local derivative, and
    %   mark point, where it intersects outterCones
        p_s = []; %intersection points, will check for the closest one
        for J = 1: (size(outterCones,1)-1)
            [out p] = crossesBetween(outterCones(J,:), outterCones(J+1,:), p1, k_n);
            if(out)
                p_s = [p_s; p];
            end
        end
        p2 = p_s(1,:);
        min_dist = distance(p1, p2);
        for J = 1: size(p_s,1)
            dst = distance(p1, p_s(J,:));
            if(dst < min_dist)
                min_dist = dst;
                p2 = p_s(J,:);
            end
        end       

        %Check for crossing with previous lines
        if(size(base,1) > 1)
            prev_A = [base(end,1) base(end,2)];
            prev_B = [base(end,3) base(end,4)];
            [check ~] = crossesBetween(prev_A, prev_B, p1, p2-p1);
            
            if(check)
                %line crosses previous line, do not add to base
                continue;
            end
        end
        
        %% 6. Save the 2 points as line segment in base
        base = [base; p1(1), p1(2), p2(1),p2(2)];
    end
end




