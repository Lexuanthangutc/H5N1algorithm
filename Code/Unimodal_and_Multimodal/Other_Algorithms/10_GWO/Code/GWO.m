%___________________________________________________________________%
%  Grey Wolf Optimizer (GWO) source codes version 1.0               %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
%               Grey Wolf Optimizer, Advances in Engineering        %
%               Software , in press,                                %
%               DOI: 10.1016/j.advengsoft.2013.12.007               %
%                                                                   %
%___________________________________________________________________%

% Grey Wolf Optimizer
function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=...
    GWO(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction)

if size(VarMin,2) == 1
VarMin = repmat(VarMin,1,nVar);
VarMax = repmat(VarMax,1,nVar);
end

% initialize alpha, beta, and delta_pos
GlobalBest_Position=zeros(1,nVar);
GlobalBest_Cost=inf; %change this to -inf for maximization problems

Beta_pos=zeros(1,nVar);
Beta_score=inf; %change this to -inf for maximization problems

Delta_pos=zeros(1,nVar);
Delta_score=inf; %change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(nPop,nVar,VarMax,VarMin);

BestCosts=zeros(1,Max_iter);

iter=0;% Loop counter
% Store
empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];
Store = repmat(empty,Max_iter,1);
% Main loop
while iter<Max_iter
    for i=1:size(Positions,1)  
        
       % Return back the search agents that go beyond the boundaries of the search space
        Flag4ub=Positions(i,:)>VarMax;
        Flag4lb=Positions(i,:)<VarMin;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+VarMax.*Flag4ub+VarMin.*Flag4lb;               
        
        % Calculate objective function for each search agent
        fitness=CostFunction(Positions(i,:));
        
        % Update Alpha, Beta, and Delta
        if fitness<GlobalBest_Cost 
            GlobalBest_Cost=fitness; % Update alpha
            GlobalBest_Position=Positions(i,:);
        end
        
        if fitness>GlobalBest_Cost && fitness<Beta_score 
            Beta_score=fitness; % Update beta
            Beta_pos=Positions(i,:);
        end
        
        if fitness>GlobalBest_Cost && fitness>Beta_score && fitness<Delta_score 
            Delta_score=fitness; % Update delta
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-iter*((2)/Max_iter); % a decreases linearly fron 2 to 0
    
    % Update the Position of search agents including omegas
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
                       
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Equation (3.3)
            C1=2*r2; % Equation (3.4)
            
            D_alpha=abs(C1*GlobalBest_Position(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=GlobalBest_Position(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Equation (3.3)
            C2=2*r2; % Equation (3.4)
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % Equation (3.3)
            C3=2*r2; % Equation (3.4)
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
            
            Positions(i,j)=(X1+X2+X3)/3;% Equation (3.7)
            
        end
    end
        % Display the iteration and best optimum obtained so far
    if mod(iter,100)==0
        display(['At iteration ', num2str(iter), ' the best fitness is ', num2str(GlobalBest_Cost)]);
    end
    iter=iter+1;    
    BestCosts(iter)=GlobalBest_Cost;
        % Store
Store(iter).GlobalBest_Position = GlobalBest_Position;
Store(iter).GlobalBest_Cost = GlobalBest_Cost;
end

end


