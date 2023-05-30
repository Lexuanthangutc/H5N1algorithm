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
%cantileverConstraints Calculate constraints in the stepped cantilever example


function [g,geq] = Stepped_Cantilever_Beam_Constraints(x)

% Problem parameters
P = 50000; % End load in N
l = 100; % Length of each step of the cantilever
E = 2e7; % Young's modulus in N/cm^2
deltaMax = 2.7; % Maximum end deflection / cm^2
sigmaMax = 14000; % Maximum stress in each section of the beam
AR_Max = 20; % Maximum aspect ratio in each section of the beam

% Constraints on the stress in each section of the stepped cantilever
g(1) =  (6*P*l)/(x(9)*x(10)^2) - sigmaMax;
g(2) =  (6*P*2*l)/(x(7)*x(8)^2) - sigmaMax;
g(3) =  (6*P*3*l)/(x(5)*x(6)^2) - sigmaMax;
g(4) = (6*P*4*l)/(x(3)*x(4)^2) - sigmaMax;
g(5) = (6*P*5*l)/(x(1)*x(2)^2) - sigmaMax;

% Deflection of the stepped cantilever
g(6) = (P*l^3/E)*(244/(x(1)*x(2)^3) + 148/(x(3)*x(4)^3) + 76/(x(5)*x(6)^3) + ...
    28/(x(7)*x(8)^3) + 4/(x(9)*x(10)^3)) - deltaMax;

% Aspect ratio constraints

g(7)=  x(2)/x(1) - AR_Max;
g(8) = x(4)/x(3) - AR_Max;
g(9)= x(6)/x(5) - AR_Max;
g(10)= x(8)/x(7) - AR_Max;
g(11) = x(10)/x(9) - AR_Max;


geq=[];
