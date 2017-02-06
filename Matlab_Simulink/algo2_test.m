clear;
clc;
close all;
k = [5.5452 2.7726 1.3863 0.6931 0.4055 0.2231 0.1178 0.0308 0.0155 0.0078];
e = [256 16 4 2 3/2 5/4 9/8 17/16 33/32 65/64 129/128];
exposant = input('Quel est l exposant ? ');
val = 0;
res = 0;
j = 1;
for i = 1 : length(k)
    if ((val + k(i)) <= exposant)
        val = val + k(i);
        indice(j) = i;
        j = j + 1;
    end
end
for j = 1 : length(indice)
   res = res + e(indice(j)); 
end
res
exp(exposant)