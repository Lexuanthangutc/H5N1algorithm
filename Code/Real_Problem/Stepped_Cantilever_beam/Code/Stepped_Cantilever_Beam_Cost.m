function V = Stepped_Cantilever_Beam_Cost(x)
%cantileverVolume Calculate volume of a stepped cantilever
%
%   V = cantileverVolume(x) calculates the volume of the stepped cantilever
%   in the "Solving a Mixed Integer Engineering Design Problem Using the
%   Genetic Algorithm" example. 

%   Copyright 2012 The MathWorks, Inc.

% Volume of cantilever beam
l = 100; % length each part of beam
V = l*(x(1)*x(2) + x(3)*x(4) + x(5)*x(6) + x(7)*x(8) + x(9)*x(10));

