%%  FA %%

function [GlobalBest_Cost,GlobalBest_Position,BestCosts]=FA(nPop,MaxIt,VarMin,VarMax,nVar,CostFunction)

if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end

VarSize=[1 nVar];


%% Firefly Algorithm Parameters

% MaxIt=1000;         % Maximum Number of Iterations

% nPop=25;            % Number of Fireflies (Swarm Size)

gamma=1;            % Light Absorption Coefficient

beta0=2;            % Attraction Coefficient Base Value

alpha=0.2;          % Mutation Coefficient

alpha_damp=0.98;    % Mutation Coefficient Damping Ratio

delta=0.05*(VarMax-VarMin);     % Uniform Mutation Range

m=2;

if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

%% Initialization

% Empty Firefly Structure
firefly.Position=[];
firefly.Cost=[];

% Initialize Population Array
pop=repmat(firefly,nPop,1);

% Initialize Best Solution Ever Found
BestSol.Cost=inf;

% Create Initial Fireflies
for i=1:nPop
    for j = 1: nVar
        pop(i).Position(1,j) = unifrnd(VarMin(j),VarMax(j));
    end
    pop(i).Cost=CostFunction(pop(i).Position);
    
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end
end

% Array to Hold Best Cost Values
BestCosts=zeros(MaxIt,1);

%% Firefly Algorithm Main Loop

for it=1:MaxIt
    
    newpop=repmat(firefly,nPop,1);
    for i=1:nPop
        newpop(i).Cost = inf;
        for j=1:nPop
            if pop(j).Cost < pop(i).Cost
                rij=norm(pop(i).Position-pop(j).Position)/dmax;
                beta=beta0*exp(-gamma*rij^m);
                e=delta.*unifrnd(-1,+1,VarSize);
                %e=delta*randn(VarSize);
                
                newsol.Position = pop(i).Position ...
                    + beta*rand(VarSize).*(pop(j).Position-pop(i).Position) ...
                    + alpha*e;
                
        % Apply limits Position
        for k = 1:nVar
            newsol.Position(1,k)=max(newsol.Position(1,k),VarMin(k));
            newsol.Position(1,k)=min(newsol.Position(1,k),VarMax(k));
        end
        
                newsol.Cost=CostFunction(newsol.Position);
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost<=BestSol.Cost
                        BestSol=newpop(i);
                    end
                end
                
            end
        end
    end
    
    % Merge
    pop=[pop
        newpop];  %#ok
    
    % Sort
    Costs=[pop.Cost];  
    [~, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Store Best Cost Ever Found
    BestCosts(it)=BestSol.Cost;
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    
    if mod(it,50)==0
        display(['At iteration ', num2str(it), ' the best solution fitness is ', num2str(BestSol.Cost)]);
    end
    
end
GlobalBest_Cost = BestSol.Cost;
GlobalBest_Position = BestSol.Position;
end
