% Thuat toan lai giua thuat toan di truyen - GA
% Le Xuan Thang 
% 22 - 05 - 2019
% Dai hoc Giao thong van tai - University of Transport and Communications
% Khoa Cong Trinh - Department of Civil Engineering
% Bo mon Cau Ham  - Section Bridge and Tunnel
% Lien he: + 84.359-876-787
% Email: lxt1021997lxt@gmail.com

function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=GA(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction);

if (size(VarMin,2) == 1)
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end


MaxIt=Max_iter;      % Maximum Number of Iterations
%%
% GA parameters
pc=0.7;                 % Crossover Percentage, Phan tram lai cheo
nc=2*round(pc*nPop/2);  % Number of Offsprings (also Parnets), So phan tu duoc phep lai cheo
gamma=0.4;              % Extra Range Factor for Crossover

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants
mu=0.1;         % Mutation Rate
beta=8;

empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);
GlobalBest.Cost=inf;

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

% Khoi tao ngau nhien vi tri cua hat, vector,...
for i=1:nPop
    
    for j=1:nVar
    % Tao ngau nghien vi tri tu VarMin den VarMax cho VarSize phan tu
    pop(i).Position(1,j)=unifrnd(VarMin(j),VarMax(j));
    end
    % Tinh gia tri cua vi tri do
    pop(i).Cost=CostFunction(pop(i).Position(1,:));      
    
    % Nhap vi tri cho hat
    particle(i).Position=pop(i).Position;                      
    
    % Lay gia tri tinh duoc cua Ham cho tung gia tri cua hat
    particle(i).Cost=pop(i).Cost;                   
    
    % Cap nhat vi tri tot nhat cua Hat
    particle(i).Best.Position=particle(i).Position; % Vi tri tot nhat cua Hat
    particle(i).Best.Cost=particle(i).Cost;         % Gia tri tot nhat tuong ung cua hat
    
    % Cap nhat vi tri tot nhat toan cau
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;        % So sanh gia tri tot nhat cua Hat voi Nhom
        
    end
end


Costs=[pop.Cost];                   % Dinh nghia gia tri
[Costs, SortOrder]=sort(Costs);     % Lay gia tri sap xep tu nho den lon theo cot, va thu tu sap xep cua no
pop=pop(SortOrder);                 % Sap xep lai thu tu cua dan so

% Array to Hold Best Cost Values
BestCosts=zeros(MaxIt,1);            % Tao ma tran gia tri tot nhat

% Store Cost
WorstCost=pop(end).Cost;            % Gia tri xau nhat
% Store
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);
for iter=1:MaxIt
    
    P=exp(-beta*Costs/WorstCost);   % p(0)=e^(-beta*Costs/WorstCost)
    P=P/sum(P);                     % P(1)=P(0)/sum(p(0))
    
    % Khoi tao kich thuoc ma tran population crossover theo hang
    pop_crossover=repmat(empty_individual,nc/2,2);
    
    % Chon 1 nua trong so phan tu duoc lai cheo
    for k=1:nc/2
        
        % Chon ngau nhien the he cha me de lai giong
        % Select Parents Indices
        i1=RouletteWheelSelection(P);   % Gen cua cha
        i2=RouletteWheelSelection(P);   % Gen cua me
        p1=pop(i1);                     % Lay Gen cua cha
        p2=pop(i2);                     % Lay Gen cua cha
        
        % Apply Crossover
        % Lai cheo 
        [pop_crossover(k,1).Position, pop_crossover(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax,nVar);
        
        % Evaluate Offsprings
        pop_crossover(k,1).Cost=CostFunction(pop_crossover(k,1).Position);
        pop_crossover(k,2).Cost=CostFunction(pop_crossover(k,2).Position);
        
    end
    pop_crossover=pop_crossover(:);
    
    % Mutation
    pop_mutation=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        pop_mutation(k).Position=Mutate(p.Position,mu,VarMin,VarMax,nVar);
        
        % Evaluate Mutant
        pop_mutation(k).Cost=CostFunction(pop_mutation(k).Position);
        
    end
    
    % Create Merged Population
    pop=[pop
        pop_crossover
        pop_mutation]; %#ok
    
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Cost Ever Found
    
    for i=1:nPop
        if pop(i).Cost<=particle(i).Cost
            particle(i).Position = pop(i).Position;
            particle(i).Cost = pop(i).Cost;
        end
        Cx(i) = particle(i).Cost;
    end
    [BestCosts(iter),r]=min(Cx);
    GlobalBest.Cost=particle(r).Cost;
    GlobalBest.Position=particle(r).Position;
    
    if mod(iter,100)==0
        display(['At iteration ', num2str(iter), ' the best solution fitness is ', num2str(GlobalBest.Cost)]);
    end
end
GlobalBest_Cost = GlobalBest.Cost;
GlobalBest_Position = GlobalBest.Position;
% Store
Store(iter).GlobalBest_Position = GlobalBest_Position;
Store(iter).GlobalBest_Cost = GlobalBest_Cost;
end
