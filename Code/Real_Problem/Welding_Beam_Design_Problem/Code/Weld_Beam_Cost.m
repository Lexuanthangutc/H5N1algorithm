function Cost = Weld_Beam_Cost(x)
% caculate weight of tension/compression of spring design problem
% x = [0.30106704	2.171754164	9.036623724	0.205729661];
x1 = x(1); % h
x2 = x(2); % l
x3 = x(3); % t
x4 = x(4); % b

Cost = 1.10471*x1^2*x2 + 0.04811*x3*x4*(14+x2);