clc;
clear;
close all;
epsilon = [0.54931 0.25541 0.12566 0.06258 0.03126 0.01563 0.00781 0.00391 0.00391 0.00195 0.00097 0.00049 0.00024 0.00012 6E-5];
x = 1.20513;
y = 0;
theta = input('angle ? ');
z = theta;
for i = 1 : 15
    sgn = (z >= 0)*2 - 1;
    temp = x + sgn*y/(2^i);
    y = y + sgn*x/(2^i);
    x = temp;
    z = z-sgn*epsilon(i)
end
x + y
exp(theta)