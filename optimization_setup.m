%% load and parametrize track
load("track1_fixed.mat");
chckpnts = Parametrize(innerConePosition, outerConePosition, 100)
%% plot bounds and checkpoints
figure;
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(chckpnts);

%% algorithm setup
x0 = zeros(size(chckpnts, 1),1);
lb = x0;
ub = x0+1;
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);

%% optimize based od length
sol = fmincon(@(alphas) get_length(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol);
%% optimize based on length^2
sol2 = fmincon(@(alphas) get_length2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol2);
%% optimize based on curvature^2
sol3 = fmincon(@(alphas) get_curvature2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol3);




