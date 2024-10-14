%% Kruhovy obluk
t = linspace(-pi, pi, 100);
x = cos(t)
y= sin(t)
plot(x,y);
axis equal;

%% V tvare racionalnej funkcie
t = linspace(-100, 100, 10000);
x = (1- t.*t)./(1+ t.*t)
y = 2*t./(1+ t.*t);
plot(x,y);
axis equal;
%what??
figure()
subplot(3,1,1);
plot(x);
subplot(3,1,2);
plot(y);
subplot(3,1,3);
plot(x,y);
% teraz chápem. klasicka parametrizacia je pre uhol 0 - 360° a opisujeme
% jednotkovu kruznicu rovnomerne okolo stredu
% racionalna parametrizacia je pre sklon priamky a priesečník s kružnicou,
% vychádzajúc z bodu [-1;0]. Ten sa nikdy nezakresli, lebo sklon by musel
% byť +-infinity. Dôležitá rovnosť je x^2 + y^2 = 1