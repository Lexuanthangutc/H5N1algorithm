% GSA code v1.1.
% Generated by Esmat Rashedi, 2010.
% "	E. Rashedi, H. Nezamabadi-pour and S. Saryazdi,
% �GSA: A Gravitational Search Algorithm�, Information sciences, vol. 179,
% no. 13, pp. 2232-2248, 2009."
%
% Main function for using GSA algorithm.
clc
clear
close all
%  inputs:
% N:  Number of agents.
% max_it: Maximum number of iterations (T).
% ElitistCheck: If ElitistCheck=1, algorithm runs with eq.21 and if =0, runs with eq.9.
% Rpower: power of 'R' in eq.7.
% F_index: The index of the test function. See tables 1,2,3 of the mentioned article.
%          Insert your own objective function with a new F_index in 'test_functions.m'
%          and 'test_functions_range.m'.
%  outputs:
% Fbest: Best result.
% Lbest: Best solution. The location of Fbest in search space.
% BestChart: The best so far Chart over iterations.
% MeanChart: The average fitnesses Chart over iterations.
%Get pwd
Path_dir = pwd;
Algorithm_Name = 'GSA';
%% Parameters
Max_iter = 500; % Max Iterations
nPop = 30; % Number of population
Number_of_function = 23; % All function needed
ElitistCheck=1; Rpower=1;
min_flag=1; % 1: minimization, 0: maximization

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

for F_ID = 1 : Number_of_function
    tic;

    Function_Name = (['F', num2str(F_ID)]);
    % Load details of the selected benchmark function
    [VarMin,VarMax,nVar,CostFunction]=Get_F(Function_Name);

    A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
    B = zeros(Time2run,Max_iter); % B = X*max_iter; store the value of Best fitness for X times to run
    C = zeros(Time2run,nVar); % C = X*nVar; store the value of Best fitness for X times to run

    for i_times = 1 : Time2run

        [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=GSA(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction,ElitistCheck,min_flag,Rpower);
        
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

    %     fprintf(['\n Function F' num2str(F_ID) '\n' ...
    %         'GBest_Cost = ' num2str(GBest_Cost) '\n'...
    %         'GBest_Position =' num2str(GBest_Position) '\n'...
    %         'Average_Best = ' num2str(Aver_A) '\n'...
    %         'STD =  ' num2str(STD_A) '\n'...
    %         'SEM = ' num2str(SEM_A) '\n',]);

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

    %     %% Plot Results
    %     figure(F_ID);
    %     semilogy(Converage_curve_best(1:1:end),'-b','LineWidth',1);
    %     title(['Function F' num2str(F_ID)])
    %     xlabel('Iterations');
    %     ylabel('Best Cost')
    %     grid on;
    %     fprintf('Time for function F%d is: %4.3f s',F_ID,time);
    %     hgsave(figure(F_ID),[num2str(Algorithm_Name) '_F' num2str(F_ID) '.fig']);
    %     close all
end

%% Lưu
% Tạo tên tệp tin
timestamp = datestr(now, 'ddmmyy');
results_filename = ['Results_' Algorithm_Name '_' timestamp '.mat'];

% Xác định đường dẫn tuyệt đối đến thư mục "Data"
folderPath = fullfile(pwd, 'Data');

% Kiểm tra nếu thư mục không tồn tại, thì tạo mới
if ~isfolder(folderPath)
    mkdir(folderPath);
end

% Lưu biến Results vào tệp tin
save(fullfile(folderPath, results_filename), 'Results', '-v7.3');
