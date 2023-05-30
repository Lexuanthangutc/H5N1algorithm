%=========================================================================%
%  Multi-Objective Hybrid Salp Swarm Algorithm and PSO // MHSSAPSO
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
%cantileverConstraints Calculate constraints in the stepped cantilever example


function [c, ceq] = cantileverConstraints(x)

% Problem parameters
P = 50000; % End load in N
l = 100; % Length of each step of the cantilever
E = 2e7; % Young's modulus in N/cm^2
deltaMax = 2.7; % Maximum end deflection / cm^2
sigmaMax = 14000; % Maximum stress in each section of the beam
AR_Max = 20; % Maximum aspect ratio in each section of the beam

% Constraints on the stress in each section of the stepped cantilever
stress = [
    (6*P*l)/(x(9)*x(10)^2) - sigmaMax;...
    (6*P*2*l)/(x(7)*x(8)^2) - sigmaMax;...
    (6*P*3*l)/(x(5)*x(6)^2) - sigmaMax;...
    (6*P*4*l)/(x(3)*x(4)^2) - sigmaMax;...
    (6*P*5*l)/(x(1)*x(2)^2) - sigmaMax];

% Deflection of the stepped cantilever
deflection = (P*l^3/E)*(244/(x(1)*x(2)^3) + 148/(x(3)*x(4)^3) + 76/(x(5)*x(6)^3) + ...
    28/(x(7)*x(8)^3) + 4/(x(9)*x(10)^3)) - deltaMax;

% Aspect ratio constraints
aspectRatio = [
    x(2) - AR_Max*x(1);...
    x(4) - AR_Max*x(3);...
    x(6) - AR_Max*x(5);...
    x(8) - AR_Max*x(7);...
    x(10) - AR_Max*x(9)];

% All nonlinear constraints
c = [stress;deflection;aspectRatio];

% No equality constraints
ceq = [];