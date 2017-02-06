%% test cordic
clc;
clear;
close all;

m = -1;
theta = 0:0.01:pi/2;
n = input('Combien d iteration ? ');
k = 1 : n+1;
K = 0.80;
epsilon = atanh(2.^-k);
for i = 1:length(theta)
    x0 = 1.20513;
    y0 = 0;
    [X(i), Y(i)] = CORDIC(m, epsilon, x0, y0, theta(i), n);
end
plot(theta, Y*K);
hold on;
plot(theta, sinh(theta));
