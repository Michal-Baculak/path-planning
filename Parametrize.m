% innerConePosition = innerBoundary;
% outerConePosition = outerBoundary;
chckpnts = parametrize(innerConePosition, outerConePosition, 200)
%% Track and chcecpoints plotting
plot(innerConePosition(:,1), innerConePosition(:,2), "g-");
hold on;
axis equal
plot(outerConePosition(:,1), outerConePosition(:,2), "g-");
for I = 1:size(chckpnts,1)
    plot([chckpnts(I,1) chckpnts(I,3)], [chckpnts(I,2) chckpnts(I,4)], "r-");
end

%% Paths demo
% path1 = get_points(chckpnts, ones(size(chckpnts,1),1)./2);
% plot(path1(:,1), path1(:,2), "k-");
% path2 = get_points(chckpnts, zeros(size(chckpnts,1),1));
% plot(path2(:,1), path2(:,2), "k-");
% path3 = get_points(chckpnts, (sin(1:size(chckpnts,1)) + ones(1,size(chckpnts,1)))./2)
% plot(path3(:,1), path3(:,2), "k-");

function [checkpoints] = parametrize(innerCones, outterCones, resolution)
    %1. Compute all distances between innerCones
    %2. Compute total length
    %3. Determine step size from resolution
    %4. Move along innerCones with step size
    %5. On each point construct a line perpendicular to local derivative, and
    %   mark point, where it intersects outterCones
    %6. Save the 2 points as line segment in checkpoints
    %% 1. Compute all distances between innerCones
    dist = [];
    checkpoints = [];
    for I = 1:(size(innerCones, 1)-1)
        dx = innerCones(I,1) - innerCones(I+1,1);
        dy = innerCones(I, 2) - innerCones(I+1,2);
        dist (I) = sqrt(dx^2 + dy^2);
    end
    dx = innerCones(end, 1) - innerCones(1, 1);
    dy = innerCones(end,2) - innerCones(end, 2);
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
        k_n = [-k(2), k(1)]; % perpendicular vector to the left
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
        if(size(checkpoints,1) > 1)
            prev_A = [checkpoints(end,1) checkpoints(end,2)]
            prev_B = [checkpoints(end,3) checkpoints(end,4)]
            [check ~] = crossesBetween(prev_A, prev_B, p1, p2-p1);
            
            if(check)
                %line crosses previous line, do not add to checkpoints
                continue;
            end
        end
        
        %% 6. Save the 2 points as line segment in checkpoints
        checkpoints = [checkpoints; p1(1), p1(2), p2(1),p2(2)];
    end
end




