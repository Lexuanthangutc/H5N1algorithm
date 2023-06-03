% Le Xuan Thang
% Cuckoo search (CS)
% 26-06-2019
% University of Transport and Communications
% Project: Modal updating problem
function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=CS(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction,F_ID)


%% Parameters
MaxIt=Max_iter; % Maximum iteration
if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end
% Discovery rate of alien eggs/solutions
pa=0.25;

%% Structure
GlobalBest.Cost = Inf;
empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
particle=repmat(empty_particle,nPop,1);
for i = 1 : nPop
    particle(i).Best.Cost=10^10;
    particle(i).Best.Position=[];
end

%% Initialization
for i = 1 : nPop
    for j = 1 : nVar
        % Position

        particle(i).Position(1,j) = unifrnd(VarMin(j),VarMax(j));

    end
    % Evaluation
    particle(i).Cost=CostFunction(particle(i).Position,F_ID);
    
    % Update Particle Best Solution
    if particle(i).Cost < particle(i).Best.Cost
        particle(i).Best.Cost=particle(i).Cost;
        particle(i).Best.Position=particle(i).Position;
        if  particle(i).Best.Cost<GlobalBest.Cost
            GlobalBest=particle(i).Best;
        end
    end
end

% Store
empty.popPosition = [];
empty.popCost = [];

empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];

Store = repmat(empty,Max_iter,1);

%% Main Loop
iter = 0;
BestCosts=zeros(MaxIt,1);
while iter<MaxIt
    iter=iter+1;
    % Get new solution but keep current best
    % Levy exponent and coefficient
    % For details, see equation (2.21), Page 16 (chapter 2) of the book
    % X. S. Yang, Nature-Inspired Metaheuristic Algorithms, 2nd Edition, Luniver Press, (2010).
    beta=3/2;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/...
        (gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    nest = vertcat (particle(:).Position);
    for i = 1 : nPop
        s=nest(i,:);
        u =randn(size(s))*sigma;
        v=randn(size(s));
        step=u./abs(v).^(1/beta);
        stepsize=0.01*step.*(s-GlobalBest.Position);
        % Now the actual random walks or flights
        s=s+stepsize.*randn(size(s));
        
        % Apply limit Position
        for j = 1:nVar
            s(1,j) = max(s(1,j),VarMin(j));
            s(1,j) = min(s(1,j),VarMax(j));
        end
        particle(i).New.Position=s;
        particle(i).New.Cost=CostFunction(particle(i).New.Position,F_ID);
        if particle(i).New.Cost < particle(i).Best.Cost
            particle(i).Best=particle(i).New;
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
        end
    end
    BestCosts(iter,1)=GlobalBest.Cost;
%     disp(['Iteration = ' num2str(it) '********** BestCost = ' num2str(BestCosts(it,1))])
    % Update the counter
    iter=iter+1;
    % Discovery and randomization
    for i = 1:nPop
        nest(i,:) = vertcat(particle(i).Best.Position);
    end
    % Discovered or not -- a status vector
    K=rand(size(nest))>pa;
    % New solution by biased/selective random walks
    stepsize=rand*(nest(randperm(nPop),:)-nest(randperm(nPop),:));
    new_nest=nest+stepsize.*K;
    for i = 1:nPop
        s=new_nest(i,:);
        % Apply Limits
        for j = 1:nVar
            s(1,j) = max(s(1,j),VarMin(j));
            s(1,j) = min(s(1,j),VarMax(j));
        end
        particle(i).New.Position=s;
        % Evaluate
        particle(i).New.Cost=CostFunction(particle(i).New.Position,F_ID);
        if particle(i).New.Cost < particle(i).Best.Cost
            particle(i).Best=particle(i).New;
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
        end
    end
    BestCosts(iter,1)=GlobalBest.Cost;
%     disp(['Iteration = ' num2str(it) '********** BestCost = ' num2str(BestCosts(it,1))])
    %Print the best solution details after every 50 iterations
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


