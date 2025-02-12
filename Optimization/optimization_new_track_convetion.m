
%% Track and trajectory generation
[inner, outer] = square_round_track(20, 20, 3, 2, 1);
base = Parametrize(inner, outer,8);
base2 = [base; base(1,:)];
sol1 = ones(8,1)./2;

%% Plotting 
figure(1)
plot_track(inner, outer);
hold on;
plot_base(base);
plot_trajectory(base, sol1);
print_markers(base, sol1);

figure(2)
plot_track(inner, outer);
hold on;
plot_base(base2);
plot_trajectory(base2, sol1);
print_markers(base2, sol1);

%% Angle profile
prof1 = get_angle_profile(base, sol1)
prof2 = get_angle_profile(base2, sol1)

%% Setting up optimization-by-parts (per partes bitch)
load("vehicle_FS.mat");
load("track1_fixed.mat");
base = Parametrize(innerConePosition, outerConePosition, 100);
bpi = 20; %break-point index
base1 = base(1:bpi,:);
base2 = base(bpi+1:end,:);

%% Optimizing by parts of the track based on length (without gradient)
figure;
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(base1);
lb = zeros(size(base1, 1),1);
ub = ones(size(base1, 1),1);
x0 = ones(size(base1, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol1 = fmincon(@(alphas) get_length(base1,alphas),x0, [], [], [], [], lb, ub, [], options);
plot_trajectory(base1, sol1);

plot_base(base2);
lb = zeros(size(base2, 1),1);
ub = ones(size(base2, 1),1);
x0 = ones(size(base2, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol2 = fmincon(@(alphas) get_length([base1;base2;base1(1,:)],[sol1;alphas]),x0, [], [], [], [], lb, ub, [], options);
plot_trajectory(base2, sol2);

%% Optimizing by parts of the track based on k^2 (without gradient)
figure;
plot_track(innerConePosition, outerConePosition);
hold on
plot_base(base1);
lb = zeros(size(base1, 1),1);
ub = ones(size(base1, 1),1);
x0 = ones(size(base1, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol3 = fmincon(@(alphas) get_curvature2(base1,alphas),x0, [], [], [], [], lb, ub, [], options);
plot_trajectory(base1, sol3);

plot_base(base2);
lb = zeros(size(base2, 1),1);
ub = ones(size(base2, 1),1);
x0 = ones(size(base2, 1),1);
options = optimoptions('fmincon','Display','iter','Algorithm','interior-point', "MaxFunctionEvaluations",10e3, "StepTolerance",1e-20);
sol4 = fmincon(@(alphas) get_curvature2([base1;base2;base1(1,:)],[sol3;alphas]),x0, [], [], [], [], lb, ub, [], options);
plot_trajectory(base2, sol4);