clc;
close all;
clear;

%% input param
nb = input('Nombre de bits ? ');
theta = -1:0.01:1;
nitter = 20;
k = 1 : nitter + 1;
%% erreur itterations
for i = 1:nb-2
    f = i;
    K = fi(0.99804536134807915012679782538069, 1, nb, f);
    epsilon = fi(atanh(2.^-k), 1, nb, f);
    for j = 1:length(theta)
        x0 = fi(1.2051341749659683078021998881013, 1, nb, f);
        y0 = fi(0, 1, nb, f);
        [X(j), Y(j)] = CORDIC(-1, epsilon, x0.data, y0.data, theta(j), nitter);
        E(j) = (X(j) + Y(j))/K.data;
    end 
    err(i) = sum(abs(E-exp(theta)))/length(E);
end
figure;
semilogy(err);
grid on;