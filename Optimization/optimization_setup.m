%% load and parametrize track
load("vehicle_FS.mat");
load("track1_fixed.mat");
% [innerConePosition, outerConePosition] = square_round_track(100, 50, 4, 4, 2);
% base = Parametrize(innerConePosition, outerConePosition, 400);
innerConePosition = flip(innerConePosition,1);
outerConePosition = flip(outerConePosition, 1);
[innerConePosition, outerConePosition] = safety_margin(innerConePosition, outerConePosition, 1);
base = parametrize_gradual(innerConePosition,outerConePosition,2,1);
base(end+1,:) = base(1,:);
%base = parametrize_delaunay(innerConePosition,outerConePosition);
% plot bounds and checkpoints
figure;
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(base);

%% optimize based od length
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol = fmincon(@(alphas) get_length(base,alphas),x0, [], [], [], [], lb, ub, [], options);
plot_trajectory(base, sol);

%% optimize based on length^2
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol2 = fmincon(@(alphas) get_length2(base,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol2);

%% optimize based on curvature^2
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol3 = fmincon(@(alphas) get_curvature2(base,alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol3);
lap_time = sum(get_time_profile(base, sol3, vehicle))

%% optimize based on time (in progress)
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol4 = fmincon(@(alphas) sum(get_time_profile(base, alphas, vehicle)),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol4);
lap_time = sum(get_time_profile(base, sol4, vehicle))

%% optimize based on curvature^2 and length
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol5 = fmincon(@(alphas) get_cost_weighted(base,alphas, 0.5),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol5);
lap_time = sum(get_time_profile(base, sol5, vehicle))

%% optimize based on curvature^1/2
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",20e3, "StepTolerance",1e-10);
sol6 = fmincon(@(alphas) sum(sqrt(abs(get_curvature_profile(base,alphas)))),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol6);
lap_time = sum(get_time_profile(base, sol6, vehicle))

%% optimize based on |curvature|
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",40e3, "StepTolerance",1e-10);
sol7 = fmincon(@(alphas) sum(abs(get_curvature_profile(base,alphas))),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol7);
lap_time = sum(get_time_profile(base, sol7, vehicle))

%% optimize based od length with gradient
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20, "SpecifyObjectiveGradient",true);
sol8 = fmincon(@(alphas) func_l(base, alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol8);
lap_time = sum(get_time_profile(base, sol8, vehicle))

%% optimize based od k^2 with gradient
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20, "SpecifyObjectiveGradient",true);
sol9 = fmincon(@(alphas) func_k(base, alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol9);
lap_time = sum(get_time_profile(base, sol9, vehicle))

%% optimize based od k^2 and length weighted with gradient
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = lb;
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20, "SpecifyObjectiveGradient",true);
sol10 = fmincon(@(alphas) func_w(base, alphas,0.5),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol10);
lap_time = sum(get_time_profile(base, sol10, vehicle))
func_w(base, sol10, 0.5)
%% optimize first half based od k^2 and length weighted with gradient
% In progress
lb = zeros(size(base, 1),1);
ub = ones(size(base, 1),1);
x_opt = ones(floor(size(base, 1)/2),1);
x_pers = ones((size(base,1) - size(x_opt,1)) ,1);

options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20, "SpecifyObjectiveGradient",true);
sol11 = fmincon(@(alphas) func_w(base, [alphas; x_pers],1),x_opt, [], [], [], [], lb, ub, [], options)
sol11 = [sol11; x_pers];
plot_trajectory(base, sol11);
lap_time = sum(get_time_profile(base, sol11, vehicle))

%% optimize based od l^2 with gradient
lb = zeros(size(base, 1)-1,1);
ub = ones(size(base, 1)-1,1);
x0 = ones(size(base, 1)-1,1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20, "SpecifyObjectiveGradient",true);
sol12 = fmincon(@(alphas) func_l2(base, alphas),x0, [], [], [], [], lb, ub, [], options)
plot_trajectory(base, sol12);
lap_time = sum(get_time_profile(base, sol12, vehicle))

function [f, g] = func_l(base, alphas)
    f = get_length(base, alphas);
    g = grad_length(base, alphas);
end

function [f, g] = func_l2(base, alphas)
    f = get_length2(base, alphas);
    g = grad_l2(base, alphas);
end

function [f, g] = func_k(base, alphas)
    f = get_curvature2(base, alphas);
    g = grad_k2(base, alphas);
end
function [f, g] = func_w(base, alphas, w)
    f = get_cost_weighted(base, alphas, w);
    g = grad_w(base, alphas, w);
end
function [f, g] = func_w_partial(base, alphas, w, breakpoint)
    f = get_cost_weighted(base, alphas, w);
    g = grad_w(base, alphas, w);
end