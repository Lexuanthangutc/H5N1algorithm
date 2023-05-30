% Aim function Problem

function [goal,Cost] = Weld_Beam_Design_Problem(x)
%     x = [0.30039      2.1776      9.0366     0.20573];
    Cost = Weld_Beam_Cost(x);
    Z=0;
    % Penalty constant
    lam = 3^17;
    lameq =3^17;
    [g,geq] = Weld_Beam_Constraints(x);
    
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
