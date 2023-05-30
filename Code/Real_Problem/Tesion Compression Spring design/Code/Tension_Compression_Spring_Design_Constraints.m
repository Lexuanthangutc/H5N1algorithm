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
% Tension/Compression spring design problem


function [g,geq] = Tension_Compression_Spring_Design_Constraints(x)

x1 = x(1);
x2 = x(2);
x3 = x(3);

g1 = 1 - ((x2^3*x3)/(71785*x1^4));
g2 = (((4*x2^2)-(x1*x2))/(12566*((x2*x1^3)-x1^4))) + (1/(5108*x1^2)) - 1;
g3 = 1 - (140.45*x1)/(x2^2*x3);
g4 = (x1 + x2)/1.5 - 1;

g = [g1,g2,g3,g4];


% Equality contraints
geq=[];
