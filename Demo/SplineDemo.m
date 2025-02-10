% demo from ChatGPT prompt at 15.9.2024 about constructing splines

%% Circle (5 points)
x = [-1,0,1,0,-1];
y = [0,1,0,-1,0];

%% Circle (n points)

fi = linspace(0, 2*pi, 20);
x = cos(fi);
y = sin(fi);
%% track 
load("track1_fixed.mat");
x = innerConePosition(:,1)';
y = innerConePosition(:,2)';

%% Spline computation
% parametric curves in 2D are not a single function - x does not depend on
% y and vice versa. Instead, there is a third independant variable - t,
% and 2 functions: x = f(t), y = g(t). We input the same value of t into
% both functions and obtain 2 values - coordinates of points

% in our case, we only have 5 points - their x and y - that is we have 5
% output values available, which we will pair with 5 input variables (whose
% bounds are ours to choose)
t_in = linspace(0,1,size(x, 2));

ppx = spline(t_in,x);
ppy = spline(t_in,y);

% we will evaluate the points finely
t = linspace(0,1,10000);

sp_x = ppval(ppx,t);
sp_y = ppval(ppy,t);

%% Graph
figure;
plot(x,y,"o");
hold on
plot(sp_x,sp_y,"-");
axis equal

%% To better ilustrate the idea behind splines:

figure;
subplot(3,1,1);
plot(sp_x,sp_y);

subplot(3,1,2);
plot(t, sp_x);

subplot(3,1,3);
plot(t, sp_y);
