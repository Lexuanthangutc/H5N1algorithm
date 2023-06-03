%_________________________________________________________________________________
%  Salp Swarm Algorithm (SSA) source codes version 1.0
%
%  Developed in MATLAB R2016a
%
%  Author and programmer: Seyedali Mirjalili
%
%         e-Mail: ali.mirjalili@gmail.com
%                 seyedali.mirjalili@griffithuni.edu.au
%
%       Homepage: http://www.alimirjalili.com
%
%   Main paper:
%   S. Mirjalili, A.H. Gandomi, S.Z. Mirjalili, S. Saremi, H. Faris, S.M. Mirjalili,
%   Salp Swarm Algorithm: A bio-inspired optimizer for engineering design problems
%   Advances in Engineering Software
%   DOI: http://dx.doi.org/10.1016/j.advengsoft.2017.07.002
%____________________________________________________________________________________

function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=SSA(N,Max_iter,VarMin,VarMax,nVar,CostFunction)

if size(VarMin,2) == 1
    VarMin = repmat(VarMin,1,nVar);
    VarMax = repmat(VarMax,1,nVar);
end

BestCosts=zeros(Max_iter,1);

% %Initialize the positions of salps
% SalpPositions=initialization(N,dim,ub,lb);
SalpPositions = zeros (N,nVar);
for i=1:size(SalpPositions,1)
    for j  = 1:nVar
        SalpPositions(i,j) = unifrnd(VarMin(j),VarMax(j));
    end
end
GlobalBest_Position=zeros(1,nVar);
GlobalBest_Cost=inf;


%calculate the fitness of initial salps

for i=1:size(SalpPositions,1)
    SalpFitness(1,i)=CostFunction(SalpPositions(i,:));
end

[sorted_salps_fitness,sorted_indexes]=sort(SalpFitness);

for newindex=1:N
    Sorted_salps(newindex,:)=SalpPositions(sorted_indexes(newindex),:);
end

GlobalBest_Position=Sorted_salps(1,:);
GlobalBest_Cost=sorted_salps_fitness(1);

% Store
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);
%Main loop
iter=1; % start from the second iteration since the first iteration was dedicated to calculating the fitness of salps
while iter<Max_iter+1

    c1 = 2*exp(-(4*iter/Max_iter)^2); % Eq. (3.2) in the paper

    for i=1:size(SalpPositions,1)

        SalpPositions= SalpPositions';

        if i<=N/2
            for j=1:1:nVar
                c2=rand();
                c3=rand();
                %%%%%%%%%%%%% % Eq. (3.1) in the paper %%%%%%%%%%%%%%
                if c3<0.5
                    SalpPositions(j,i)=GlobalBest_Position(j)+c1*((VarMax(j)-VarMin(j))*c2+VarMin(j));
                else
                    SalpPositions(j,i)=GlobalBest_Position(j)-c1*((VarMax(j)-VarMin(j))*c2+VarMin(j));
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end

        elseif i>N/2 && i<N+1
            point1=SalpPositions(:,i-1);
            point2=SalpPositions(:,i);

            SalpPositions(:,i)=(point2+point1)/2; % % Eq. (3.4) in the paper
        end

        SalpPositions= SalpPositions';
    end

    for i=1:size(SalpPositions,1)

        Tp=SalpPositions(i,:)>VarMax;
        Tm=SalpPositions(i,:)<VarMin;
        SalpPositions(i,:)=(SalpPositions(i,:).*(~(Tp+Tm)))+VarMax.*Tp+VarMin.*Tm;

        SalpFitness(1,i)=CostFunction(SalpPositions(i,:));

        if SalpFitness(1,i)<GlobalBest_Cost
            GlobalBest_Position=SalpPositions(i,:);
            GlobalBest_Cost=SalpFitness(1,i);

        end
    end

    if mod(iter,100)==0
        display(['At iteration ', num2str(iter), ' the best solution fitness is ', num2str(GlobalBest_Cost)]);
    end
    BestCosts(iter)=GlobalBest_Cost;
    iter = iter + 1;
    % Store
    Store(iter).GlobalBest_Position = GlobalBest_Position;
    Store(iter).GlobalBest_Cost = GlobalBest_Cost;
end



