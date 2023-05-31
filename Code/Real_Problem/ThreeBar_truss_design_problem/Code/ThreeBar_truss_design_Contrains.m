%_________________________________________________________________________________
%  H5N1 algorithm source codes version 1.0
%
%  Developed in MATLAB R2022a
%
%  Author and programmer: Le Xuan Thang
%
%         e-Mail: lxt1021997lxt@gmail.com
%                 lexuanthang.official@outlook.com
%
%
%   Main paper:
%   DOI:
%____________________________________________________________________________________
% three bar truss 


function [g,geq] = ThreeBar_truss_design_Contrains(x)

x1 = x(1);
x2 = x(2);

% Problem parameters
l=100; %cm
P = 2; %KN/cm2
sigma = 2; %KN/cm2

g(1) = ((sqrt(2)*x1 + x2)/(sqrt(2)*x1^2 + 2*x1*x2))*P - sigma;
g(2) = (x2/(sqrt(2)*x1^2 + 2*x1*x2))*P - sigma;
g(3) = (1/(sqrt(2)*x2 + x1))*P - sigma;


geq=[];
