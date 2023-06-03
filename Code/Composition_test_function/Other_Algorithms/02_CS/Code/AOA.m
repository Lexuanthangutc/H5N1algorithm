
function [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=AOA(nPop,MaxIt,VarMin,VarMax,nVar,CostFunction,F_ID)
% display('AOA Working');
%Two variables to keep the positions and the fitness value of the best-obtained solution

GlobalBest_Position=zeros(1,nVar);
GlobalBest_Cost=inf;
BestCosts=zeros(1,MaxIt);

%Initialize the positions of solution
% VarMax = VarMax';
% VarMin = VarMin';
X=initialization(nPop,nVar,VarMax,VarMin);
Xnew=X;
Ffun=zeros(1,size(X,1));% (fitness values)
Ffun_new=zeros(1,size(Xnew,1));% (fitness values)

MOP_Max=1;
MOP_Min=0.2;
iter=1;
Alpha=5;
Mu=0.499;


for i=1:size(X,1)
    Ffun(1,i)=CostFunction(X(i,:),F_ID);  %Calculate the fitness values of solutions
    if Ffun(1,i)<GlobalBest_Cost
        GlobalBest_Cost=Ffun(1,i);
        GlobalBest_Position=X(i,:);
    end
end
    
    

    MOP_Store = zeros(1,MaxIt);
    MOA_Store = zeros(1,MaxIt);
% Store
empty.popPosition = [];
empty.popCost = [];

empty.GlobalBest_Position = [];
empty.GlobalBest_Cost = [];

Store = repmat(empty,MaxIt,1);

while iter<MaxIt+1  %Main loop
    MOP =1-((iter)^(1/Alpha)/(MaxIt)^(1/Alpha));   % Probability Ratio 
    MOA=MOP_Min+iter*((MOP_Max-MOP_Min)/MaxIt); %Accelerated function
    MOP_Store(iter) = MOP;
    MOA_Store(iter) = MOA;
    %Update the Position of solutions
    for i=1:size(X,1)   % if each of the UB and LB has a just value 
        for j=1:size(X,2)
           r1=rand();
            if (size(VarMin,2)==1)
                if r1<MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=GlobalBest_Position(1,j)/(MOP+eps)*((VarMax-VarMin)*Mu+VarMin);
                    else
                        Xnew(i,j)=GlobalBest_Position(1,j)*MOP*((VarMax-VarMin)*Mu+VarMin);
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=GlobalBest_Position(1,j)-MOP*((VarMax-VarMin)*Mu+VarMin);
                    else
                        Xnew(i,j)=GlobalBest_Position(1,j)+MOP*((VarMax-VarMin)*Mu+VarMin);
                    end
                end               
            end
            
           
            if (size(VarMin,2)~=1)   % if each of the UB and LB has more than one value 
                r1=rand();
                if r1<MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=GlobalBest_Position(1,j)/(MOP+eps)*((VarMax(j)-VarMin(j))*Mu+VarMin(j));
                    else
                        Xnew(i,j)=GlobalBest_Position(1,j)*MOP*((VarMax(j)-VarMin(j))*Mu+VarMin(j));
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=GlobalBest_Position(1,j)-MOP*((VarMax(j)-VarMin(j))*Mu+VarMin(j));
                    else
                        Xnew(i,j)=GlobalBest_Position(1,j)+MOP*((VarMax(j)-VarMin(j))*Mu+VarMin(j));
                    end
                end               
            end
            
        end
        
        Flag_UB=Xnew(i,:)>VarMax; % check if they exceed (up) the boundaries
        Flag_LB=Xnew(i,:)<VarMin; % check if they exceed (down) the boundaries
        Xnew(i,:)=(Xnew(i,:).*(~(Flag_UB+Flag_LB)))+VarMax.*Flag_UB+VarMin.*Flag_LB;
 
        Ffun_new(1,i)=CostFunction(Xnew(i,:),F_ID);  % calculate Fitness function 
        if Ffun_new(1,i)<Ffun(1,i)
            X(i,:)=Xnew(i,:);
            Ffun(1,i)=Ffun_new(1,i);
        end
        if Ffun(1,i)<GlobalBest_Cost
        GlobalBest_Cost=Ffun(1,i);
        GlobalBest_Position=X(i,:);
        end
       
    end
    

    %Update the convergence curve
    BestCosts(iter)=GlobalBest_Cost;
    
    %Print the best solution details after every 50 iterations
    if mod(iter,10)==0
        display(['At iteration ', num2str(iter), ' the best solution fitness is ', num2str(GlobalBest_Cost)]);
    end
     
    iter=iter+1;  % incremental iteration
    % Store
    Store(iter).popPosition = X;
    Store(iter).popCost = Ffun;
    Store(iter).GlobalBest_Position = GlobalBest_Position;
    Store(iter).GlobalBest_Cost = GlobalBest_Cost;

end
