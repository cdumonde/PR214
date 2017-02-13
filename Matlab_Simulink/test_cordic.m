%% test cordic
clc;
clear;
close all;

m = -1;
theta = -1:0.01:1;
n = input('Combien d iterations ? ');
k = 1 : n+1;
K = 0.80;
epsilon = atanh(2.^-k);
for i = 1:length(theta)
    x0 = prod(cosh(epsilon));
    y0 = 0;
    [X(i), Y(i)] = CORDIC(m, epsilon, x0, y0, theta(i), n);
end
figure;
plot(theta, (X+Y), theta, exp(theta));
figure;
plot(theta, abs((X+Y) - exp(theta))./exp(theta)*100);