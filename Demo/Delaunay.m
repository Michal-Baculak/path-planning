%Get two sides of the track
%Constrain each side of the track - each point [x y] is a vertex, and we are
%constraining V1-V2, V2-V3, ... V(N-1)-V(N), V(N)-V1

inner = innerConePosition
outer = outerConePosition

C1 = getConstr(inner);
C2 = getConstr(outer);
C2 = C2 + size(C1, 1);


P = [inner; outer];
C = [C1; C2];

DT = delaunayTriangulation(P,C);

%Plot
figure(1);
% for I = 1: size(P,1)
%     plot(P(I,1),P(I,2), "o");
%     hold on;
%     pause(0.2);
% end
plot(P(:,1), P(:,2), "o");
axis equal;
hold on;

IO = isInterior(DT);
triplot(DT(IO,:), DT.Points(:,1), DT.Points(:,2));

%get all the midpoints
%to do that we need to neglect the boundary of the track.
%we can do that simply if we acknowledge, that inner and outer boundary are
%two different datasets concatenated at specific index.
%To neglect the boundaries, we are looking for edges connecting inner and
%outer cones. 
%that means that in such a edge, one cone will be from first interval and
%the other from the second interval.
%lets querry through all edges, evaluate both points and see if their
%interval differs

con = DT(IO,:) %connections of interest
%edges to be investigated
edges = [ con(:,1) con(:,2); con(:,2) con(:,3); con(:,1) con(:,3)] 
c_edges = [];
for I = 1:size(edges,1)
    int1 = edges(I,1) <= size(inner,1); %1 if from innerPoints
    int2 = edges(I,2) <=size(inner,1);
    if(int1 ~= int2)
        if(int1)
            c_edges = [c_edges; edges(I,1) edges(I,2)];
        else
            c_edges = [c_edges; edges(I,2) edges(I,1)];
        end
        x1 = DT.Points(edges(I,1), 1);
        x2 = DT.Points(edges(I,2), 1);
        y1 = DT.Points(edges(I,1), 2);
        y2 = DT.Points(edges(I,2), 2);
        plot([x1 x2], [y1 y2], "r-");
    end
end
%sort the edges

c_edges = sortrows(unique(c_edges, "rows"), [1 2])
%get the midpoints of the edges
m_points = []
for I = 1:size(c_edges,1)
    A = DT.Points(c_edges(I,1),:);
    B = DT.Points(c_edges(I,2),:);
    C = (A + B)./2;
    m_points = [m_points; C];
    plot(C(1),C(2), "go")
end
plot(m_points(:,1), m_points(:,2), "ro");

%construct splines
t_in = linspace(0,1, size(m_points,1));
ppx = spline(t_in, m_points(:,1));
ppy = spline(t_in, m_points(:,2));

t_out = linspace(0,1,10000);

x_s = ppval(ppx, t_out);
y_s = ppval(ppy, t_out);

plot(x_s, y_s, "g-");

%%

function C = getConstr(in)
    C_s = size(in, 1);
    C = [(1:(C_s-1))' (2:C_s)'; C_s 1];
end



