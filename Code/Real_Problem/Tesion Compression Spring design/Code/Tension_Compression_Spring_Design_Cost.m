function f = Tension_Compression_Spring_Design_Cost(x)
% caculate weight of tension/compression of spring design problem

x1 = x(1);
x2 = x(2);
x3 = x(3);

f = (x3+2)*x2*x1^2;