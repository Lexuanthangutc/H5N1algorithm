function Score = IGD(ObjPF,truePF)
% <metric> <min>
% Inverted generational distance

%------------------------------- Reference --------------------------------
% C. A. Coello Coello and N. C. Cortes, Solving multiobjective optimization
% problems using an artificial immune system, Genetic Programming and
% Evolvable Machines, 2005, 6(2): 163-190.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2018-2019 BIMK Group.

%     Distance = min(pdist2(PF,PopObj),[],2);
%     Score    = mean(Distance);



q = 2; %the parameter of IGD
%STEP 1. Obtain the maximum and minimum values of the Pareto front
m1 = size(ObjPF, 1);
m = size(truePF, 1);
maxVals = max(truePF);
minVals = min(truePF);

%STEP 2. Get the normalized front
normalizedPF = (ObjPF - repmat(minVals, m1, 1)) ./ repmat(maxVals - minVals, m1, 1);
normalizedTruePF = (truePF - repmat(minVals, m, 1)) ./ repmat(maxVals - minVals, m, 1);

%STEP 3. Sum the distances between each point of the front and the nearest point in the true Pareto front
Score = 0;
for i = 1:m
    diff = repmat(normalizedTruePF(i,:), m1, 1) - normalizedPF;
    dist = sqrt(sum(diff.^2, 2));         
    Score = Score + min(dist)^q;
end
Score = Score^(1.0/q)/m;
end