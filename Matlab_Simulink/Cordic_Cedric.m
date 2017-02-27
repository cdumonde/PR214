%% test cordic
clc;
clear;
close all;

m = -1;
theta = -10:0.01:10;
n = input('Combien d iterations ? ');
k = 1 : n+1;
K = 0.99804536134807915012679782538069;
epsilon = atanh(2.^-k);
for i = 1:length(theta)
    frac = mod(theta(i),1);
    int = theta(i) - frac;
    x0 = prod(cosh(epsilon));
    y0 = 0;
    [X(i), Y(i)] = CORDIC(m, epsilon, x0, y0, frac, n);
    E(i) = (X(i) + Y(i))/K*exp(int);
end
figure;
plot(theta, E, theta, exp(theta));
figure;
plot(theta, abs(E - exp(theta))./exp(theta));