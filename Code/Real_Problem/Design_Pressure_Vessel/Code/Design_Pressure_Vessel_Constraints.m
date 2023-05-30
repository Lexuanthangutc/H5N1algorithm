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


function [g,geq] = Design_Pressure_Vessel_Constraints(x)

x1 = x(1); % Ts: thickness of shell
x2 = x(2); % Th: thickness of head
x3 = x(3); % R: inner radius
x4 = x(4); % L: length of the cylindrical section of the vessel not including the head

g1 = -x1 +0.0193*x3;
g2 = -x2 + 0.00954*x3;
g3 = -pi*x3^2*x4 - (4/3)*pi*x3^3 + 1296000;
g4 = x4 - 240;


g = [g1,g2,g3,g4];


% Equality contraints
geq=[];
