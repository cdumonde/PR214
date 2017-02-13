%% CORDIC Implementation on Matlab
function [X, Y] = CORDIC(m, epsilon, x0, y0, theta, niter)

x = x0;
y = y0;
z = theta;

for i = 1 : niter + 1
    sgn = (z(i) >= 0)*2 - 1;
    x(i + 1) = x(i) - m*sgn*y(i)*2^(-i);
    y(i + 1) = y(i) + sgn*x(i)*2^(-i);
    z(i + 1) = z(i) - sgn*epsilon(i);
    if(z(i) == 0)
        X = x(i);
        Y = y(i);
    break
    end
end 


end
