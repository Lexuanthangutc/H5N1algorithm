function f = Disc_Brake_Cost(x)
% Disc Brake Design Problem
% x = [57.95, 78.57, 2736.72, 2];
x1 = x(1); % Ri : the inner radius of the discs, in mm = x1
x2 = x(2); % Ro : outer radius of the discs, in mm = x2
x3 = x(3); % F  : engaging force, in N = x3
x4 = x(4); % n  : number of the friction surfaces (integer) = x4

% The objective functions
% Mass of the Brake, in kg
f1 = 4.9E-5 * (x2^2 - x1^2)*(x4 - 1);

% Stopping time: in s
f2 = (9.82E6*(x2^2 - x1^2))/(x3*x4*(x2^3-x1^3));

f = [f1;f2];
