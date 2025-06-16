innerCones = importdata("Data\LogFolder\trackLeft.txt");
outerCones = importdata("Data\LogFolder\trackRight.txt");
base = importdata("Data\LogFolder\base.txt");
alphas = importdata("Data\LogFolder\alphas.txt");
vel_prof = importdata("Data\LogFolder\velProf.txt");
info = importdata("Data\LogFolder\misc.txt");
%%
rrt_pts = importdata("Data\LogFolder\RRTPoints.txt");
rrt_velprof = importdata("Data\LogFolder\RRTVelProf.txt");
%%
reg_info = importdata("Data\reginfo_parsed.txt");
%%
input_excel = importdata("Data\input_excel.txt");
%%
alphas_w = []
for i = 0:20;
    alphas = importdata("Data\Experiments\FSG\Different W alphas\alphas" + i + ".txt")
    alphas_w(:,i+1) = alphas;
end
%%
figure;
plot_track(innerCones,outerCones);
hold on;
plot_base(base);
plot_trajectory(base, alphas);
print_markers(base, alphas);