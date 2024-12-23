%% load and parametrize track
load("vehicle_F1.mat");
load("track1_fixed.mat");
chckpnts = Parametrize(innerConePosition, outerConePosition, 100)
%% plot bounds and checkpoints
figure;
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(chckpnts);

%% optimize based od length
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol = fmincon(@(alphas) get_length(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol);
%% optimize based on length^2
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol2 = fmincon(@(alphas) get_length2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol2);
%% optimize based on curvature^2
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol3 = fmincon(@(alphas) get_curvature2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol3);
lap_time = sum(get_time_profile(chckpnts, sol3, vehicle))

%% optimize based on time (in progress)
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol4 = fmincon(@(alphas) sum(get_time_profile(chckpnts, alphas, vehicle)),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol4);
lap_time = sum(get_time_profile(chckpnts, sol4, vehicle))

%% optimize based on curvature^2 and length
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol5 = fmincon(@(alphas) get_cost_weighted(chckpnts,alphas, 0),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(chckpnts, sol5);
lap_time = sum(get_time_profile(chckpnts, sol5, vehicle))
