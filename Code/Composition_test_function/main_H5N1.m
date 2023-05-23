% H5N1 
% by Le Xuan Thang
clc
clear
close all

global initial_flag
%Get pwd
Path_dir = pwd;
Algorithm_Name = 'H5N1';
%% Parameters
Max_iter = 1000; % Max Iterations
nPop = 30; % Number of population
Number_of_function = 25; % All function needed

empty.Name          = [];
empty.BestCost      = [];
empty.BestPosition  = [];
empty.CostHistory   = [];
empty.Mean          = [];
empty.STD           = [];
empty.SEM           = [];
empty.History       = [];
Results = repmat(empty,Number_of_function,1);                       
Time_store = zeros(Number_of_function,1);

empty_store.A  = [];
empty_store.B  = [];
empty_store.C  = [];
empty_store.D  = [];
%% For standard and best value in 30 times run the function
Time2run = 30; % times to run the function

History = repmat(empty_store,Time2run,1);
for F_ID = 16 : Number_of_function

    tic;
    
    Function_Name = (['F', num2str(F_ID)]);
    % Load details of the selected benchmark function
    [VarMin,VarMax,nVar,~]=Get_CEC05_F(Function_Name);
    CostFunction = str2func('benchmark_func');
    A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
    B = zeros(Time2run,Max_iter); % B = X*max_iter; store the value of Best fitness for X times to run
    C = zeros(Time2run,nVar); % C = X*nVar; store the value of Best fitness for X times to run
    initial_flag = 0;
    
    for i_times = 1 : Time2run
        % Call H5N1 function
        [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=H5N1(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction,F_ID);
        
        History(i_times).A = GlobalBest_Cost;
        History(i_times).B = BestCosts;
        History(i_times).C = GlobalBest_Position;
        History(i_times).D = Store;
    end

    % Time caculate
    time = toc;
    for i_times = 1 : Time2run 
        A(i_times) = History(i_times).A;
        B(i_times,:)  = History(i_times).B;
        C(i_times,:) = History(i_times).C;
    end

    % Get best value of fitness
    [GBest_Cost,No_A] = min(A);
    % Best time
    Converage_curve_best = B(No_A,:);
    % Best Position
    GBest_Position = C(No_A,:);
    % Average of Best value
    Aver_A = mean(A);       
    % Standard deviation
    STD_A = std(A);
    % Standard errors of mean - SEM
    SEM_A = STD_A / sqrt(length(A));
    
    % Store the results
    Results(F_ID).Name = Function_Name;
    Results(F_ID).BestCost = GBest_Cost;
    Results(F_ID).BestPosition = GBest_Position;
    Results(F_ID).CostHistory = Converage_curve_best;
    Results(F_ID).Mean= Aver_A;
    Results(F_ID).STD= STD_A;
    Results(F_ID).SEM = SEM_A;
    Results(F_ID).Time = time;
    Results(F_ID).History = History;

end

% save
save(['History_' num2str(Algorithm_Name) '_160523.mat'],'History','-v7.3')
save(['Results_' num2str(Algorithm_Name) '_160523.mat'],'Results','-v7.3')



        



