%%  pso %%

function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=PSO(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction)

%% Parameters
MaxIt=Max_iter; % Maximum iteration
if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end

VarSize=[1 nVar];


c1=2;
c2=2;

w=1;
wdamp=0.99;


VelMax = 0.2*(VarMax-VarMin);
VelMin = -VelMax;
% The particle template
% particle
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];

% Best
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

particle=repmat(empty_particle,nPop,1);

GlobalBest.Cost=inf;

%% Intialization

for i = 1:nPop
    
    % tao ngau nhien vecto van toc
    particle(i).Velocity=zeros(VarSize);
    % tao ngau nhien vecto vi tri
    for j = 1: nVar
        particle(i).Position(1,j) = unifrnd(VarMin(j),VarMax(j));
    end
    % Voi moi hat i, tinh gia tri cua ham
    particle(i).Cost=CostFunction(particle(i).Position);
    
    % Cap nhat vi tri tot nhat cua hat
    particle(i).Best.Position= particle(i).Position;
    particle(i).Best.Cost= particle(i).Cost;
    
    if particle(i).Best.Cost < GlobalBest.Cost
        GlobalBest=particle(i).Best;
    end
end
% End Intialization

BestCosts=zeros(MaxIt,1);
% Store
empty.popPosition = [];
empty.popCost = [];
empty.popBestPosition = [];
empty.popBestCost = [];
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);
%% Main Loop
for iter=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        for j = 1:nVar
            particle(i).Velocity(1,j) = w*particle(i).Velocity(1,j)  ...
                + c1*rand()*(particle(i).Best.Position(1,j)-particle(i).Position(1,j))...
                + c2*rand()*(GlobalBest.Position(1,j)-particle(i).Position(1,j));
        end
        % Apply limits Velocity
        for k = 1:nVar
            particle(i).Velocity(1,k)=max(particle(i).Velocity(1,k),VelMin(k));
            particle(i).Velocity(1,k)=min(particle(i).Velocity(1,k),VelMax(k));
        end
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Apply limits Position
        for k = 1:nVar
            particle(i).Position(1,k)=max(particle(i).Position(1,k),VarMin(k));
            particle(i).Position(1,k)=min(particle(i).Position(1,k),VarMax(k));
        end
        
        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost < particle(i).Best.Cost
            
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = particle(i).Cost;
            
            % Update Global Best
            if particle(i).Best.Cost < GlobalBest.Cost
                GlobalBest = particle(i).Best;
            end
            
        end
        
    end
    
    % Store the Best Cost Value
    BestCosts(iter) = GlobalBest.Cost;
    % Damping Inertia Coefficient
    w = w * wdamp;
    
    if mod(iter,1)==0
        display(['At iteration ', num2str(iter), ' the best solution fitness is ', num2str(GlobalBest.Cost)]);
    end
    
end
GlobalBest_Cost = GlobalBest.Cost;
GlobalBest_Position = GlobalBest.Position;

% Store
Store(iter).GlobalBest_Position = GlobalBest_Position;
Store(iter).GlobalBest_Cost = GlobalBest_Cost;

end











