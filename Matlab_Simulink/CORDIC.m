%% CORDIC Implementation on Matlab
function [X, Y] = CORDIC(m, epsilon, x0, y0, theta, niter)

x = x0;
y = y0;
z = theta;

for i = 1 : niter + 1
    sgn = (z(i) >= 0)*2 - 1;
    if(i == 4 || i == 13 || i == 40 || i == 121)
        x(i + 1) = x(i) - m*sgn*y(i)*2^(-i);
        y(i + 1) = y(i) + sgn*x(i)*2^(-i);
        z(i + 1) = z(i) - sgn*epsilon(i);
        temp = x(i + 1);
        sgn = (z(i+1) >= 0)*2 - 1;
        x(i + 1) = x(i+1) - m*sgn*y(i+1)*2^(-i);
        y(i + 1) = y(i+1) + sgn*temp*2^(-i);
        z(i + 1) = z(i+1) - sgn*epsilon(i);
    else
        x(i + 1) = x(i) - m*sgn*y(i)*2^(-i);
        y(i + 1) = y(i) + sgn*x(i)*2^(-i);
        z(i + 1) = z(i) - sgn*epsilon(i);
    end
end
X = x(niter + 1);
Y = y(niter + 1);

end
