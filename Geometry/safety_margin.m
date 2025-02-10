function out = safety_margin(in, margin, direction)
    len = size(in, 1);
    out = []
    for I = 1:size(in, 1)
        A = in(mod(I-2, len) +1, :);
        B = in(I, :);
        C = in(1+mod(I, len), :);
        o_p = offset_points(A,B,C, margin, direction);
        p_new = l_intersect(o_p(1,:), o_p(2,:), o_p(3,:), o_p(4,:));
        out = [out; p_new];
    end
end

function out = offset_points(A,B,C, offset, dir)
    %dir: +1 = left, -1 = right;
    k = [B-A; C-B]
    n = [-dir*k(:,2), dir*k(:,1)];
    n(1,:) = offset * n(1,:)/norm(n(1,:));
    n(2,:) = offset * n(2,:)/norm(n(2,:));
    out = [A+n(1,:); B+n(1,:); B+n(2,:); C+n(2,:)];
end

function p = l_intersect(A1,A2,B1,B2)
%https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
    x1 = A1(1); x2 = A2(1); x3 = B1(1); x4 = B2(1);
    y1 = A1(2); y2 = A2(2); y3 = B1(2); y4 = B2(2);
    t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4))/...
        ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4))

    p = [x1+t*(x2-x1), y1 + t*(y2-y1)];
end