clc;
clear;
close all;
Lutcos = cosh (0:1:10);
Lutsin = sinh (0:1:10);
epsilon = [0.54931 0.25541 0.12566 0.06258 0.03126 0.01563 0.00781 0.00391 0.00391 0.00195 0.00097 0.00049 0.00024 0.00012 6E-5]; 
n = input('Combien d iterations ? ');
K = 0.80;
m=-1;
k = 1 : n+1;
epsilon = atanh(2.^-k);
theta = 0:0.1:10;
for j = 1:length(theta)
    frac = mod(theta(j),1);
    int = theta(j) - frac;
    for i = 1:length(theta)
        x0 = prod(cosh(epsilon));
        y0 = 0;
        [x, y] = CORDIC(m, epsilon, x0, y0, frac, n);
    end
    e(j)= vpa(cosh( int))*x+vpa(sinh(int))*y+vpa(cosh( int))*y+vpa(sinh( int))*x;   
end
figure,     
plot(theta, e)
hold on
plot(theta, exp(theta),'r')
figure;
plot(theta, (exp(theta)-e));