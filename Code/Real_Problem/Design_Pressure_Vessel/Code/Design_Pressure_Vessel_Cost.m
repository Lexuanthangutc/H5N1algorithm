function f = Design_Pressure_Vessel_Cost(x)
% caculate

x1 = x(1); % Ts: thickness of shell
x2 = x(2); % Th: thickness of head
x3 = x(3); % R: inner radius
x4 = x(4); % L: length of the cylindrical section of the vessel not including the head


f = 0.6224*x1*x3*x4 + 1.7781*x2*x3^2 + 3.1661*x1^2*x4 + 19.84*x1^2*x3;