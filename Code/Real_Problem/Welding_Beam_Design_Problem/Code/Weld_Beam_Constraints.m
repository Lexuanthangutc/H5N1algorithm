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
% Weld Beam Design Problem

function [g,geq] = Weld_Beam_Constraints(x)
% x = [0.30039      2.1776      9.0366     0.20573];
% x = [0.300469317313889	2.17690671618920	9.03662391673390	0.205729639445833];
% x = [0.301412910239874	2.17067610393130	9.05200612587849	0.205684834668924];
% ];
% Have
P = 6000; %lb
L = 14; %in
delta_max = 0.25; %in
E = 30E6; %psi
G = 12E6; %psi
tau_max = 13600; %psi
sigma_max = 30000; %psi

% Variables
x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);

% Where
M = P*(L + x2/2);
R = sqrt(((x2^2)/4) + ((x1+x3)/2)^2);
J = 2*(sqrt(2)*x1*x2*((x2^2)/12 + ((x1+x3)/2)^2));
tau_comma_1 = P/(sqrt(2)*x1*x2);
tau_comma_2 = (M*R)/J;
tau = sqrt(tau_comma_1^2 + 2*tau_comma_1*tau_comma_2*(x2/(2*R)) + tau_comma_2^2);

sigma = (6*P*L)/(x4*(x3^2));
delta = (4*P*L^3)/(E*x3^3*x4);
Pc = ((4.013*E*sqrt((x3^2*x4^6)/36))/L^2) * (1 - (x3/(2*L))*sqrt(E/(4*G)));



% Subject to 
g1 = tau - tau_max;
g2 = sigma - sigma_max;
g3 = x1 - x4;
g4 = 0.10471*x1^2 + 0.04811*x3*x4*(14+x2) - 5.0;
g5 = 0.125 - x1;
g6 = delta - delta_max;
g7 = P - Pc;

g = [g1,g2,g3,g4,g5,g6,g7];
% Equality contraints
geq=[];

