function Cost = ThreeBar_truss_design_Cost(x)

x1 = x(1);
x2 = x(2);

% Cost
l=100; %cm

Cost = (2*sqrt(2)*x1 + x2)*l;

