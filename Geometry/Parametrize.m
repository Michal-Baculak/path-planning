function [base] = Parametrize(innerCones, outterCones, resolution)
    %1. Compute all distances between innerCones
    %2. Compute total length
    %3. Determine step size from resolution
    %4. Move along innerCones with step size
    %5. On each point construct a line perpendicular to local derivative, and
    %   mark point, where it intersects outterCones
    %6. Save the 2 points as line segment in base
    %% 1. Compute all distances between innerCones
    dist = [];
    base = [];
    for I = 1:(size(innerCones, 1)-1)
        dx = innerCones(I,1) - innerCones(I+1,1);
        dy = innerCones(I, 2) - innerCones(I+1,2);
        dist (I) = sqrt(dx^2 + dy^2);
    end
    dx = innerCones(end, 1) - innerCones(1, 1);
    dy = innerCones(end,2) - innerCones(1, 2);
    dist(end+1) = sqrt(dx^2 + dy^2);

    %% 2. compute total length
    len = sum(dist);
    %% 3. Determine step size from resolution
    ds = len/resolution;
    %% 4. Move along innerCones with step size
    for I = 1:resolution
        s = I*ds
        %find out, between which points we lie 
        pos = 1;
        while(s > 0)
            if(pos > length(dist)) % residual `s` cause by rounding errors 
                s = 0;
                break;
            end
            s = s - dist(pos);
            pos = pos + 1;
        end
        pos = pos - 1;
        %pos = index of last point
        s = s + dist(pos); %undo last subtraction to find remaining dist
        k = innerCones(mod(pos, size(innerCones,1)) + 1, :) - innerCones(pos, :);
        % point along innerCones
        p1 = innerCones(pos, :) + k*s/dist(pos) 
    %% 5. On each point construct a line perpendicular to local derivative, and
    %   mark point, where it intersects outterCones
        k_n = [-k(2), k(1)]; % perpendicular vector to the left (right or left doesnt matter)
        p_s = [] %intersection points, will check for the closest one
        for J = 1: (size(outterCones,1)-1)
            [out p] = crossesBetween(outterCones(J,:), outterCones(J+1,:), p1, k_n);
            if(out)
                p_s = [p_s; p];
            end
        end
        [out p] = crossesBetween(outterCones(end,:), outterCones(1,:), p1, k_n);
        if(out)
            p_s = [p_s; p];
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




