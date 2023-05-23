%_________________________________________________________________________________
%  MH5N1 algorithm source codes version 1.0
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
function [Store,M]=MH5N1(nPop,Max_iter,lb,ub,dim,CostFunction,nObj,Problem_Name)
% H5N1 - Metaheuristic optimization algorithm
% [GlobalBest_Cost,GlobalBest_Position,BestCosts]=MH5N1(nPop,Max_iter,lb,ub,nVar,CostFunction)

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
ro = (0:1:nPop-1);                             % rotating index array
R=rand(nPop,dim);                              % matrix of normalization random number for all
v=rand(nPop,1);                                % vector of normalization random number for mutate

%% Initialize the population randomly
popCost = zeros(nPop,nObj);                        % cost of pop of virus
% popPosition  = zeros(nPop,dim);                % position of pop of virus
popPosition = initialization(nPop,dim,ub,lb);


% Evaluate the objective function for each individual
for i = 1:nPop
    popCost(i,:) = CostFunction(popPosition(i, :),Problem_Name);
end
popBestCost = popCost;
popBestPosition = popPosition;

ArchiveMaxSize=100; % Số lượng tối đa lưu lại 
Archive_X =zeros(ArchiveMaxSize,dim); % Lưu lại vị trí tối ưu = Size store * dimensions 
Archive_F =ones(ArchiveMaxSize,nObj)*inf; % Lưu lại fitness của giải pháp đó = Size store * objective number

GlobalBest_Position =zeros(1,dim); % Lưu lại vị trí tối ưu = Size store * dimensions 
GlobalBest_Cost =ones(1,nObj)*inf; % Lưu lại fitness của giải pháp đó = Size store * objective number

Archive_member_no=0; % Số lượng giải pháp được lưu lại sau mỗi lần chạy. (tiến dần đến Size store)

%% value store for visualization

% Store
empty.popPosition = [];
empty.popCost = [];
empty.popPosition = [];
empty.popCost = [];
empty.popPosition = [];
empty.popCost = [];
empty.Archive_member_no = [];
empty.Archive_F = [];
empty.Archive_X = [];
% parameters
Store = repmat(empty,Max_iter,1);

%% Main loop
iter = 0;
while iter < Max_iter
    iter = iter+1;
    %=========================update the ranking=========================%

    for i=1:nPop %Calculate all the objective values first
        popCost(i,:)=CostFunction(popPosition(i,:),Problem_Name);
        if dominates(popCost(i,:),popBestCost(i,:))
            popBestCost(i,:)=popCost(i,:);
            popBestPosition(i,:)=popPosition(i,:);

        elseif dominates(popBestCost(i,:),popCost(i,:))
            % Do nothing
        else 
            if rand < 0.5
                popBestCost(i,:) = popCost(i,:);
            end

        end
    end
    %=========================end update the ranking======================%
    try
     [Archive_X, Archive_F, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, popPosition, popCost, Archive_member_no);
    catch
        Archive_X = popBestPosition;
        Archive_F = popBestCost;
    end
     %=========================Handle Full Archive======================%
     
     if Archive_member_no>ArchiveMaxSize
         Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, nObj);
         [Archive_X, Archive_F, Archive_mem_ranks, Archive_member_no]=HandleFullArchive(Archive_X, Archive_F, Archive_member_no, Archive_mem_ranks, ArchiveMaxSize);
     else
         Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, nObj);
     end
     %=========================end Handle Full Archive======================%

     % to improve coverage
    index=RouletteWheelSelection(1./Archive_mem_ranks);
    if index==-1
        index=1;
    end

    GlobalBest_Cost=Archive_F(index,:);
    GlobalBest_Position=Archive_X(index,:);

     %=========================parameter caculate=========================%
    c = exp(-4*iter/Max_iter)*rand();
    p = 1 ./ (1 + exp(-10*(iter/Max_iter-0.5))) + rand()*(1-p); % Eq.3.5
    wdamp = wmin + (wmax-wmin)*exp(-(iter/Max_iter));

    % Determine the probability of attaching to a bird
    P_attack =  rand(nPop, 1);
    % Determine the probability of survival after infection
    P_survival = rand(nPop, 1);
    
    sigma = randperm(3);               % index pointer array
    a1  = randperm(nPop);            % alpha 1
    rt1  = rem(ro+sigma(1),nPop);      % rt1
    a2  = a1(rt1+1);                 % alpha 2
    rt2  = rem(ro+sigma(2),nPop);      % rt2
    a3  = a2(rt2+1);                 % alpha 3

    pmp1 = popBestPosition(a1,:);    % permutate population 1
    pmp2 = popBestPosition(a2,:);    % permutate population 2
    pmp3 = popBestPosition(a3,:);    % permutate population 3

    v  = v(a3,:);                 % permutate coefficient
    sm = rand(nPop,dim);           % stochastic for mutate
    %=====================end parameter caculate=========================%

    % Update the population using the infected fitness
    for i = 1:nPop
        m_pop(i,:) = sm (i,:) < v(i,1);                    % all random numbers < vm are 1, 0 otherwise
        m_popBest(i,:) = m_pop (i,:) < v(i,1);              % inverse mutate pop to popBest

        % Move the individual according to the probability of survival
        % Check if the virus attaches to poultry or human
        if P_attack(i) < P1

            % Calculate the probability of survival of the poultry
            if P_survival(i) < P2 % % Good enviroment / the poultry survives

                % Get direction
                direction = GlobalBest_Position - popPosition(i,:);
                popPosition(i,:) = pmp3(i,:)+ R(i,:).*direction;

            else % if it can not survivor

                xold = GlobalBest_Position ;
                xnew = popPosition(i,:) + R(i,:).*(GlobalBest_Position-popBestPosition(i,:));
                popPosition(i,:) = 1/2*c*w*(xnew+xold)*rand();
                popCost(i,:) = CostFunction(popPosition(i,:),Problem_Name);

                ps = rand();
                if ps < p && dominates(popCost(i,:),GlobalBest_Cost)
                    GlobalBest_Position = popPosition(i,:);
                    GlobalBest_Cost = popCost(i,:);
                end
            end

            % attach to human
        else
            if P_survival(i) < P2 % Good enviroment /the human survives

                % Get direction
                direction = GlobalBest_Position - popPosition(i,:);
                popPosition(i,:) = popPosition(i,:)  + (R(i,:).*(pmp1(i,:)-pmp2(i,:)) + R(i,:).*direction)/2;

            else % Bad enviroment / if human can not survivor
                xold = GlobalBest_Position ;
                xnew = popPosition(i,:) + R(i,:).*(GlobalBest_Position-popBestPosition(i,:));
                popPosition(i,:) = 1/2*c*w*(xnew+xold)*rand();
                popCost(i,:) = CostFunction(popPosition(i,:),Problem_Name);

                ps = rand();
                if ps < p && dominates(popCost(i,:),GlobalBest_Cost)
                    GlobalBest_Position = popPosition(i,:);
                    GlobalBest_Cost = popCost(i,:);
                end

            end
        end
    end

    % Mutate
    popPosition = popPosition.*m_pop + popBestPosition.*m_popBest;

    %% CheckBoundary / Clip the position to the search space
    changeRows =  popPosition > ub;
    popPosition(changeRows) =  pmp1(changeRows);
    changeRows =  popPosition < lb;
    popPosition(changeRows) = pmp2(changeRows);

    w = w*wdamp;

%% Show Iteration Information

    fprintf('Number of Rep Members at Iteration %4.0f is: %3.0f \n',iter, Archive_member_no)
    % Store
    Store(iter).popPosition = popPosition;
    Store(iter).popCost = popCost;
    Store(iter).popBestPosition = popBestPosition;
    Store(iter).popBestCost = popBestCost;
    Store(iter).GlobalBest_Position = GlobalBest_Position;
    Store(iter).GlobalBest_Cost = GlobalBest_Cost;
    Store(iter).Archive_member_no = Archive_member_no;
    Store(iter).Archive_F = Archive_F;
    Store(iter).Archive_X = Archive_X;
end


%% Reference Point, Pareto Front, Set
M_empty.IGD = [];
M_empty.GD = [];
M_empty.HV = [];
M_empty.Spacing = [];
M_empty.Spread = [];
M_empty.DeltaP = [];
M = repmat(M_empty,1,1);


Archive_member_no = 100;
x=linspace(0,1,Archive_member_no);
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


