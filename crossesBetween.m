function [out, p] = crossesBetween(A,B, origin, direction)
    D = origin + direction;
    x1 = A(1);          y1 = A(2);    
    x2 = B(1);          y2 = B(2);    
    x3 = origin(1);     y3 = origin(2);
    x4 = D(1);          y4 = D(2);
    
    t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4))/...
        ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
    if(t >= 0 && t <= 1)
        out = 1;
        p = [x1+t*(x2-x1), y1 + t*(y2-y1)];
    else
        out = 0;
        p = -1;
    end

end