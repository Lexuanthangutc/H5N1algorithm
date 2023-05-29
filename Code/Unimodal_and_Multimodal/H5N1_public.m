%_________________________________________________________________________________
%  H5N1 algorithm source codes version 1.0
%
%  Developed in MATLAB R2022a
%
%  Author and programmer: Le Xuan Thang
%
%         e-Mail: lxt1021997lxt@gmail.com
%                 lexuanthang.official@outlook.com
%
%
%   Main paper:
%   DOI:
%____________________________________________________________________________________
function [GlobalBest_Cost,GlobalBest_Position,BestCosts]=H5N1_public(nPop,Max_iter,lb,ub,dim,CostFunction)
% H5N1 - Metaheuristic optimization algorithm
% [GlobalBest_Cost,GlobalBest_Position,BestCosts]=H5N1(nPop,Max_iter,lb,ub,nVar,CostFunction)

% Inputs:
% nPop: size of the population
% Max_iter: maximum number of iterations
% lb: lower bounds for decision variables
% ub: upper bounds for decision variables
% dim: number of decision variables
% CostFunction: handle to the function that computes the cost of a candidate solution

% Outputs:
% GlobalBest_Cost: cost of the best solution found
% GlobalBest_Position: decision variable values of the best solution found
% BestCosts: vector containing the cost of the best solution in each iteration

if size(lb,2) == 1
    lb = repmat(lb,1,dim);
    ub = repmat(ub,1,dim);
end

% setting up parameter for H5N1 algorithms
P1 = 0.8; % Probability of attaching to a bird, poultry
P2 = 0.85; % Probability of survival after infection

w = 1;
wmin = 0.001;
wmax = 1;
p = 0;
m_pop = zeros(nPop,dim);                       % mutate for pop population
m_popBest = zeros(nPop,dim);                   % mutate for popBest population
rot = (0:1:nPop-1);                             % rotating index array
F=rand(nPop,dim);                              % matrix of normalization random number for all
vm=rand(nPop,1);                                % vector of normalization random number for mutate

%% Initialize the population randomly
popCost = zeros(nPop,1);                        % cost of pop of virus
popPosition  = zeros(nPop,dim);                % position of pop of virus

popBestPosition = rand(nPop, dim).*(ub-lb) + lb; % initilization first population
popBestCost = zeros(nPop, 1);

% Evaluate the objective function for each individual
for i = 1:nPop
    popBestCost(i) = CostFunction(popBestPosition(i, :));
end

% Find the best individual
[GlobalBest_Cost, bestidx] = min(popBestCost);
GlobalBest_Position = popBestPosition(bestidx, :);

%% value store for visualization
BestPosition = zeros(dim,Max_iter);            % get frame for bestposition of virus
BestCosts=zeros(Max_iter,1);                    % save best solution of every iteration

%% Main loop
for iter = 1:Max_iter
    c = exp(-4*iter/Max_iter)*rand();
    p = 1 ./ (1 + exp(-10*(iter/Max_iter-0.5))) + rand()*(1-p);
    wdamp = wmin + (wmax-wmin)*exp(-(iter/Max_iter));

    % Determine the probability of attaching to a bird
    P_attach =  rand(nPop, 1);
    % Determine the probability of survival after infection
    P_survival = rand(nPop, 1);

    ind = randperm(3);              % index pointer array
    a1  = randperm(nPop);           % permutate locations of vectors
    rt = rem(rot+ind(1),nPop);      % rotate indices by ind(1) positions
    a2  = a1(rt+1);                 % move 1 step forward
    rt = rem(rot+ind(2),nPop);      % rotate indices by ind(2) positions
    a3  = a2(rt+1);                 % move 1 step forward
    pm1 = popBestPosition(a1,:);             % permutate population 1
    pm2 = popBestPosition(a2,:);             % permutate population 2
    pm3 = popBestPosition(a3,:);             % permutate population 3
    vm= vm(a3,:);                            % permutate coefficient
    tmx=rand(nPop,dim);                     % stochastic for mutate   

    % Update the population using the infected fitness
    for i = 1:nPop
        m_pop(i,:) = tmx (i,:)< vm(i,1);                    % all random numbers < vm are 1, 0 otherwise
        m_popBest(i,:) = m_pop (i,:)< vm(i,1);              % inverse mutate pop to popBest

        % Move the individual according to the probability of survival
        % Check if the virus attaches to poultry or human
        if P_attach(i) < P1
            % Calculate the probability of survival of the poultry
            if P_survival(i) < P2 % % Good enviroment / the poultry survives

                % Get direction
                direction = GlobalBest_Position - popPosition(i,:);
                popPosition(i,:) = pm3(i,:)+ F(i,:).*direction;

            else % if it can not survivor
                xold = GlobalBest_Position ;
                xnew = popPosition(i,:) + F(i,:).*(GlobalBest_Position-popBestPosition(i,:));
                popPosition(i,:) = 1/2*c*w*(xnew+xold)*rand();
                popCost(i) = CostFunction(popPosition(i,:));

                ps = rand();
                if ps < p && popCost(i) < GlobalBest_Cost
                    GlobalBest_Position = popPosition(i,:);
                    GlobalBest_Cost = popCost(i);
                end
            end

            % attach to human
        else
            if P_survival(i) < P2 % Good enviroment /the human survives 
                % Get direction
                direction = GlobalBest_Position - popPosition(i,:);
                popPosition(i,:) = popPosition(i,:)  + pm3(i,:) + F(i,:).*direction;

            else % Bad enviroment / if human can not survivor
                xold = GlobalBest_Position ;
                xnew = popPosition(i,:) + F(i,:).*(GlobalBest_Position-popBestPosition(i,:));
                popPosition(i,:) = 1/2*c*w*(xnew+xold)*rand();
                popCost(i) = CostFunction(popPosition(i,:));

                ps = rand();
                if ps < p && popCost(i) < GlobalBest_Cost
                    GlobalBest_Position = popPosition(i,:);
                    GlobalBest_Cost = popCost(i);
                end

            end
        end
    end

    % Mutate
    popPosition = popBestPosition.*m_popBest + popPosition.*m_pop; 

    %% CheckBoundary / Clip the position to the search space
    changeRows =  popPosition > ub;   
    popPosition(changeRows) =  pm1(changeRows);
    changeRows =  popPosition < lb;
    popPosition(changeRows) = pm2(changeRows);

    popPosition = CheckBoundary
    % Evaluate new position
    for i = 1:nPop
        popCost(i,:) = CostFunction(popPosition(i,:));   % check cost of competitor
    end

    % Update for popBest and Globalbest
    for i = 1:nPop
        if (popCost(i) <= popBestCost(i))               
            popBestPosition(i,:) = popPosition(i,:);    
            popBestCost(i)   = popCost(i);             
            if (popBestCost(i) <= GlobalBest_Cost)                
                GlobalBest_Cost = popBestCost(i);               
                GlobalBest_Position = popPosition(i,:);                  
            end
        end
    end

    w = w*wdamp;
    BestCosts(iter) = GlobalBest_Cost;
    BestPosition(:,iter) = GlobalBest_Position;
    fprintf('The best solutions at iteration %4.0f is: %3.12f \n',iter, GlobalBest_Cost)
end
