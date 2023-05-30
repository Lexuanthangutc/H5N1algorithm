%=========================================================================%
%  Multi-Objective H5N1 
%
%  Developed in MATLAB R2022a
%
%  Programmer: Le Xuan Thang
%
%  EMail: lxt102199lxt@gmail.com
%         thang4201097sdh@lms.utc.edu.vn
%
%  Date: May 2022
%=========================================================================%
% Disc Brake Design Problem

function [g,geq] = Disc_Brake_Constraints(x)
% x = [0.205986
% 3.471328
% 9.020224
% 0.20648
% ];


% Variables
x1 = x(1); % ������������, inner radius of the discs, in mm = x1
x2 = x(2); % Ro, outer radius of the discs, in mm = ������2,
x3 = x(3); % F, engaging force, in N = ������3,
x4 = x(4); % n, number of the friction surfaces (integer) = ������4

% Geometric constraints / Subject to 
% g1: Minumum distance between radii
g1 = (x2 - x1) - 20 ;
% g2: Maximum length of the brake
g2 = 30 - 2.5*(x4 + 1);
% g3: Pressure constraint
g3 = 0.4 - (x3/(pi*(x2^2 - x1^2)));
% g4: Temperature constraint
g4 = 1 - ((2.22E-3*x3*(x2^3 - x1^3))/(x2^2-x1^2)^2);
% g5: generated torque constraint
g5 = ((2.66E-2*x3*x4*(x2^3-x1^3))/(x2^2-x1^2)) - 900;

g = [g1,g2,g3,g4,g5];


% Equality contraints
geq=[];
