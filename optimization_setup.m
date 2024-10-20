%% load and parametrize track
load("track1_fixed.mat");
chckpnts = Parametrize(innerConePosition, outerConePosition, 500)
%% plot bounds and checkpoints
plot(innerConePosition(:,1), innerConePosition(:,2), "g-");
hold on;
axis equal
plot(outerConePosition(:,1), outerConePosition(:,2), "g-");
for I = 1:size(chckpnts,1)
    plot([chckpnts(I,1) chckpnts(I,3)], [chckpnts(I,2) chckpnts(I,4)], "r-");
end

%% optimize path
x0 = zeros(size(chckpnts, 1),1);
lb = x0;
ub = x0+1;
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3);

sol = fmincon(@(alphas) get_length(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
sol2 = fmincon(@(alphas) get_length2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
%% plot solution
pts = get_points(chckpnts, sol);
plot(pts(:,1), pts(:,2), "go");

pts2 = get_points(chckpnts, sol2);
plot(pts2(:,1), pts2(:,2), "bo");