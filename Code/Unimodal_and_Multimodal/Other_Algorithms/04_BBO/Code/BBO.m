%%  BBO %%

function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=BBO(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction);

if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end


%% BBO Parameters

MaxIt=Max_iter;          % Maximum Number of Iterations

% nPop=50;            % Number of Habitats (Population Size)

KeepRate=0.2;                   % Keep Rate
nKeep=round(KeepRate*nPop);     % Number of Kept Habitats

nNew=nPop-nKeep;                % Number of New Habitats

% Migration Rates
mu=linspace(1,0,nPop);          % Emmigration Rates
lambda=1-mu;                    % Immigration Rates

alpha=0.9;

pMutation=0.1;

sigma=0.02*(VarMax-VarMin);

%% Initialization

% Empty Habitat
habitat.Position=[];
habitat.Cost=[];

% Create Habitats Array
pop=repmat(habitat,nPop,1);

% Initialize Habitats
for i=1:nPop
    for j = 1: nVar
        pop(i).Position(1,j) = unifrnd(VarMin(j),VarMax(j));
    end
    pop(i).Cost=CostFunction(pop(i).Position);
end

% Sort Population
[~, SortOrder]=sort([pop.Cost]);
pop=pop(SortOrder);

% Best Solution Ever Found
BestSol=pop(1);

% Array to Hold Best Costs
BestCosts=zeros(MaxIt,1);
% Store
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);

%% BBO Main Loop

for iter=1:MaxIt
    
    newpop=pop;
    for i=1:nPop
        for k=1:nVar
            % Migration
            if rand<=lambda(i)
                % Emmigration Probabilities
                EP=mu;
                EP(i)=0;
                EP=EP/sum(EP);
                
                % Select Source Habitat
                j=RouletteWheelSelection(EP);
                
                % Migration
                newpop(i).Position(k)=pop(i).Position(k) ...
                    +alpha*(pop(j).Position(k)-pop(i).Position(k));
                
            end
            
            % Mutation
            if rand<=pMutation
                newpop(i).Position(k)=newpop(i).Position(k)+sigma(k)*randn;
            end
        end
        
        % Apply limits Position
        for k = 1:nVar
            newpop(i).Position(1,k)=max(newpop(i).Position(1,k),VarMin(k));
            newpop(i).Position(1,k)=min(newpop(i).Position(1,k),VarMax(k));
        end
        
        % Evaluation
        newpop(i).Cost=CostFunction(newpop(i).Position);
    end
    
    % Sort New Population
    [~, SortOrder]=sort([newpop.Cost]);
    newpop=newpop(SortOrder);
    
    % Select Next Iteration Population
    pop=[pop(1:nKeep)
         newpop(1:nNew)];
     
    % Sort Population
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    
    % Update Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
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


