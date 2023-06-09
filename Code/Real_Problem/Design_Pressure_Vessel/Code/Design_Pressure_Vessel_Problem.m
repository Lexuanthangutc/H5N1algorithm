function [goal,Cost] = Design_Pressure_Vessel_Problem(x)

Cost = Design_Pressure_Vessel_Cost(x);
    
    Z=0;
    % Penalty constant
    lam =10^15;
    lameq =10^15;
    [g,geq] = Design_Pressure_Vessel_Constraints(x);
    % Inequality constraints
    for k=1: length (g)
        Z=Z+lam * g(k)^2*getH(g(k));
    end
    
    % Equality constraints (when geq= [], length->0)
    for k=1 : length(geq)
        Z=Z+ lameq*geq(k)^2*geteqH(geq(k)) ;
    end
    
    % Penalty function
    goal = Cost+Z;

end

% Test if inequalities hold
function H=getH(g)
    if g<=0
        H = 0;
    else
        H=1;
    end
end

% Test if equalities hold
function H=geteqH(g)
    if g==0
        H = 0;
    else
        H = 1;
    end
end