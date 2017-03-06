clc;
close all;
clear;

%% input param
d = input('Nombre de bits partie entiere ? ');
f = input('Nombre de bits partie decimale ? ');
nb = d+f;
theta = -1:0.01:1;

K = fi(0.99804536134807915012679782538069, 1, nb, f);
%% erreur itterations
for i = 1:25
    k = 1 : i + 1;
    epsilon = atanh(2.^-k);
    for j = 1:length(theta)
        x0 = fi(1.2051341749659683078021998881013, 1, nb, f);
        y0 = fi(0, 1, nb, f);
        [X(j), Y(j)] = CORDIC(-1, epsilon, x0.data, y0.data, theta(j), i);
        E(j) = (X(j) + Y(j))/K.data;
    end 
    err(i) = sum(abs(E-exp(theta)))/length(E);
end
figure;
semilogy(err);
grid on;