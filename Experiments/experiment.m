% This script contains experiments that are conducted across different
% versions of the workspace. Each experiments has its own, tagged commit on
% git. Running this script on a particular version will reproduce the
% experiment. No outside-of-repository dependency files are required

% Experiment code begins below:

% Experiment 1: get_cost_weighted unit test
%% load and parametrize track
load("vehicle_F1.mat");
load("track1_fixed.mat");
chckpnts = Parametrize(innerConePosition, outerConePosition, 100)

%% optimize based od length
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol_l = fmincon(@(alphas) get_length(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)

%% optimize based on curvature^2
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol_k = fmincon(@(alphas) get_curvature2(chckpnts,alphas),x0, [], [], [], [], lb, ub, [], options)

%% optimize based on curvature^2 and length
lb = zeros(size(chckpnts, 1),1);
ub = ones(size(chckpnts, 1),1);
x0 = ones(size(chckpnts, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol_w_1 = fmincon(@(alphas) get_cost_weighted(chckpnts,alphas, 1),x0, [], [], [], [], lb, ub, [], options)
sol_w_0 = fmincon(@(alphas) get_cost_weighted(chckpnts,alphas, 0),x0, [], [], [], [], lb, ub, [], options)
sol_w_0_5 = fmincon(@(alphas) get_cost_weighted(chckpnts,alphas, 0.5),x0, [], [], [], [], lb, ub, [], options)

%% compare length optimizations
figure(1);
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(chckpnts);
pts_l = get_points(chckpnts, sol_l);
pts_w_0 = get_points(chckpnts, sol_w_0);
plot(pts_l(:,1), pts_l(:,2), "Color","cyan","Marker","x");
plot(pts_w_0(:,1), pts_w_0(:,2), "Color","black","Marker","x");
disp("comparing length: [original, cost_weighted]");
[get_length(chckpnts, sol_l), get_length(chckpnts, sol_w_0)]
disp("comparing lap time: [original, cost_weighted]");
[sum(get_time_profile(chckpnts, sol_l, vehicle)), sum(get_time_profile(chckpnts, sol_w_0, vehicle))]
savefig(figure(1), "..\Experiments\Experiment_1\Figure1.fig")
saveas(figure(1), "..\Experiments\Experiment_1\Figure1.pdf")
saveas(figure(1), "..\Experiments\Experiment_1\Figure1.jpg")

%% compare curvature^2 optimizations
figure(2);
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(chckpnts);
pts_k = get_points(chckpnts, sol_k);
pts_w_1 = get_points(chckpnts, sol_w_1);
plot(pts_k(:,1), pts_k(:,2), "Color","cyan","Marker","x");
plot(pts_w_1(:,1), pts_w_1(:,2), "Color","black","Marker","x");
disp("comparing curvature^2: [original, cost_weighted]");
[get_curvature2(chckpnts, sol_k), get_curvature2(chckpnts, sol_w_1)]
disp("comparing lap time: [original, cost_weighted]");
[sum(get_time_profile(chckpnts, sol_k, vehicle)), sum(get_time_profile(chckpnts, sol_w_1, vehicle))]
savefig(figure(2), "..\Experiments\Experiment_1\Figure2.fig")
saveas(figure(2), "..\Experiments\Experiment_1\Figure2.pdf")
saveas(figure(2), "..\Experiments\Experiment_1\Figure2.jpg")

%% compare curvature^2 and weighted optimization
figure(3);
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(chckpnts);
pts_k = get_points(chckpnts, sol_k);
pts_w_0_5 = get_points(chckpnts, sol_w_0_5);
plot(pts_k(:,1), pts_k(:,2), "Color","cyan","Marker","x");
plot(pts_w_0_5(:,1), pts_w_0_5(:,2), "Color","black","Marker","x");
disp("comparing lap time: [k^2, cost_weighted w = 0.5]");

[sum(get_time_profile(chckpnts, sol_k, vehicle)), sum(get_time_profile(chckpnts, sol_w_0_5, vehicle))]
disp("total length: ");
get_length(chckpnts, sol_w_0_5)
disp("total k^2: ");
get_curvature2(chckpnts, sol_w_0_5)
savefig(figure(3), "..\Experiments\Experiment_1\Figure3.fig")
saveas(figure(3), "..\Experiments\Experiment_1\Figure3.pdf")
saveas(figure(3), "..\Experiments\Experiment_1\Figure3.jpg")

%% save workspace
save("..\Experiments\Experiment_1\Workspace.mat");



