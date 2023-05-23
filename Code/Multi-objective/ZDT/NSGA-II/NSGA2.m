%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function [Store,M]=NSGA2(nPop,Max_iter,lb,ub,dim,CostFunction,nObj,Problem_Name)

% nVar = 3;             % Number of Decision Variables

VarSize = [1 dim];   % Size of Decision Variables Matrix

% lb = -5;          % Lower Bound of Variables
% ub = 5;          % Upper Bound of Variables

% % Number of Objective Functions
% nObj = numel(CostFunction(unifrnd(VarMin, VarMax, VarSize)));


%% NSGA-II Parameters

% MaxIt = 100;      % Maximum Number of Iterations

% nPop = 50;        % Population Size
nRep = 100;
pCrossover = 0.7;                         % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation = 0.4;                          % Mutation Percentage
nMutation = round(pMutation*nPop);        % Number of Mutants

mu = 0.02;                    % Mutation Rate

sigma = 0.1*(ub-lb);  % Mutation Step Size


%% Initialization

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];

pop = repmat(empty_individual, nPop, 1);

%% value store for visualization

% Store
empty.popPosition = [];
empty.popCost = [];
empty.Archive_member_no = [];
empty.Archive_F = [];
empty.Archive_X = [];
% parameters
Store = repmat(empty,Max_iter,1);

for i = 1:nPop
    
    pop(i).Position = unifrnd(lb, ub, VarSize);
    
    pop(i).Cost = CostFunction(pop(i).Position,Problem_Name);
    
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop);

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop

for iter = 1:Max_iter
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);
        
        popc(k, 1).Cost = CostFunction(popc(k, 1).Position,Problem_Name);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position,Problem_Name);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        
        i = randi([1 nPop]);
        p = pop(i);
        
        popm(k).Position = Mutate(p.Position, mu, sigma);
        
        popm(k).Cost = CostFunction(popm(k).Position,Problem_Name);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1});
    Archive_member_no = numel(F1);
%% Show Iteration Information
    for i = 1:nPop
        popPosition(i,:) = pop(i).Position;
        popCost(i,:) = pop(i).Cost;
    end
    for i_F = 1:Archive_member_no
        Archive_X(i_F,:) = F1(i_F).Position;
        Archive_F(i_F,:) = F1(i_F).Cost ;
    end
    fprintf('Number of Rep Members at Iteration %4.0f is: %3.0f \n',iter, Archive_member_no)
    % Store
    Store(iter).popPosition = popPosition;
    Store(iter).popCost = popCost;
    Store(iter).Archive_member_no = Archive_member_no;
    Store(iter).Archive_F = Archive_F;
    Store(iter).Archive_X = Archive_X;
    
end

%% Resluts
%% Reference Point, Pareto Front, Set
M_empty.IGD = [];
M_empty.GD = [];
M_empty.HV = [];
M_empty.Spacing = [];
M_empty.Spread = [];
M_empty.DeltaP = [];
M = repmat(M_empty,1,1);

x=linspace(0,1,nRep);
y = x;
L=size(x,2);

if nObj == 2
    True_Pareto = zeros(L,nObj);
    for i=1:L
        True_Pareto(i,:)=CostFunction([x(i) 0 0 0],Problem_Name);
    end
    M.IGD=IGD(Archive_F,True_Pareto);
%     M.GD=GD(Archive_F,True_Pareto);
%     M.HV=HV(Archive_F,True_Pareto);
%     M.Spacing=Spacing(Archive_F,True_Pareto);
%     M.Spread=Spread(Archive_F,True_Pareto);
%     M.DeltaP=DeltaP(Archive_F,True_Pareto);

elseif nObj == 3
    SetPareto = zeros(L,L);
    for i=1:L
        for j=1:L
            Z=CostFunction([x(i) y(j) 0 0],Problem_Name);
            SetPareto(i,j) = Z(3);
        end
    end
    M.IGD=IGD(Archive_F,SetPareto(:));
end

