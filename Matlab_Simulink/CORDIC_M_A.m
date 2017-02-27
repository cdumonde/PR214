clc
clear
close all

tau = 2^(-17);
IS(1)=1;

for i = 1:1:655360
IS(i+1)= IS(i)-tau*IS(i);
end
figure,
x_axis= 0:1:655360;
exptau= exp(-x_axis.*tau);
plot(x_axis, IS, 'b')
hold on
plot(x_axis,exptau,'-r')

figure,
plot(x_axis,(IS-exptau)./exptau)
