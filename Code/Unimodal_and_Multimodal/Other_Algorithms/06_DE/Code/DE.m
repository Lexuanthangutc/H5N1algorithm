function  [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=DE(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction);

if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end

VarSize=[1 nVar];
%% DE Parameters

MaxIt=Max_iter;      % Maximum Number of Iterations

% nPop=100;        % Population Size

beta_min=0.2;   % Lower Bound of Scaling Factor
beta_max=0.8;   % Upper Bound of Scaling Factor

pCR=0.2;        % Crossover Probability

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

BestSol.Cost=inf;

pop=repmat(empty_individual,nPop,1);

for i=1:nPop

    for j = 1: nVar
        pop(i).Position(1,j) = unifrnd(VarMin(j),VarMax(j));
    end
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
    if pop(i).Cost<BestSol.Cost
        BestSol=pop(i);
    end
    
end

BestCosts=zeros(MaxIt,1);
% Store
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);
%% DE Main Loop

for iter=1:MaxIt
    
    for i=1:nPop
        
        x=pop(i).Position;
        
        A=randperm(nPop);
        
        A(A==i)=[];
        
        a=A(1);
        b=A(2);
        c=A(3);
        
        % Mutation
        %beta=unifrnd(beta_min,beta_max);
        beta=unifrnd(beta_min,beta_max,VarSize);
        y=pop(a).Position+beta.*(pop(b).Position-pop(c).Position);
        y = max(y, VarMin);
		y = min(y, VarMax);
		
        % Crossover
        z=zeros(size(x));
        j0=randi([1 numel(x)]);
        for j=1:numel(x)
            if j==j0 || rand<=pCR
                z(j)=y(j);
            else
                z(j)=x(j);
            end
        end
        
        NewSol.Position=z;
        NewSol.Cost=CostFunction(NewSol.Position);
        
        if NewSol.Cost<pop(i).Cost
            pop(i)=NewSol;
            
            if pop(i).Cost<BestSol.Cost
               BestSol=pop(i);
            end
        end
        
    end
    
    % Update Best Cost
    BestCosts(iter)=BestSol.Cost;
    
    if mod(iter,100)==0
        display(['At iteration ', num2str(iter), ' the best solution fitness is ', num2str(BestSol.Cost)]);
    end
end
GlobalBest_Cost = BestSol.Cost;
GlobalBest_Position = BestSol.Position;
% Store
Store(iter).GlobalBest_Position = GlobalBest_Position;
Store(iter).GlobalBest_Cost = GlobalBest_Cost;
end

