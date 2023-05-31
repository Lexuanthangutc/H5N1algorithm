function [goal,Cost] = ThreeBar_truss_design_Problem(x)

Cost = ThreeBar_truss_design_Cost(x);
    
    Z=0;
    % Penalty constant
    lam =10^5;
    lameq =10^5;
    [g,geq] = ThreeBar_truss_design_Contrains(x);
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
    if g<0
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