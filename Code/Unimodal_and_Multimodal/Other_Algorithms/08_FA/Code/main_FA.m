% Main PSO
% Code by: Le Xuan Thang
clc
clear
close all

%% Parameters
Max_iter = 1000; % Max Iterations
nPop = 100; % Number of population
Number_of_function = 23; % All function needed
Results_Best_of_Function = zeros(Number_of_function,1); % Fitness
Results_Converage_curve_best = zeros(Number_of_function,Max_iter); % Fitness
Results_Average_of_Function = zeros(Number_of_function,1); % Fitness
Results_STD_of_Function = zeros(Number_of_function,1); % Standard deviation
Results_SEM_of_Function = zeros(Number_of_function,1); % Standard errors of means(SEM)

% For standard and best value in 30 times run the function
% input--
Time2run = 30; % times to run the function
A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
B = zeros(Time2run,Max_iter); % A = X*max_iter; store the value of Best fitness for X times to run
% end input--
    
%Get pwd
Path_dir = pwd;

Time_store = zeros(Number_of_function,1);
for function_i = 1 : Number_of_function
    tic;
    for i_times = 1 : Time2run
        Function_Name = (['F', num2str(function_i)]);
        %Create Store for save all result of functions
        [VarMin,VarMax,nVar,CostFunction] = Get_F(Function_Name);
        % Call function
        [GlobalBest_Cost,GlobalBest_Position,BestCosts]=...
            FA(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction);
        A(i_times,1) = GlobalBest_Cost;
        B(i_times,:) = BestCosts;
    end
    % Time caculate
    time = toc;
    disp(['Time for function F' num2str(function_i) ' is: ' num2str(time) ' s']);
    Time_store(function_i) = time;
    
    % Get best value of fitness5
    [Best_A,No_A] = min(A);
    % Best time
    Converage_curve_best = B(No_A,:);
    % Average of Best value
    Aver_A = mean(A);
    % Standard deviation
    STD_A = std(A);
    % Standard errors of mean - SEM
    SEM_A = STD_A / sqrt(length(A));
        
    fprintf(['\n Function F' num2str(function_i) '\n' ...
        'G_Best = ' num2str(Best_A) '\n'...
        'Average_Best = ' num2str(Aver_A) '\n'...
        'STD =  ' num2str(STD_A) '\n'...
        'SEM = ' num2str(SEM_A) '\n']);
    
    % Store the results
    Results_Best_of_Function(function_i,1) = Best_A;
    Results_Converage_curve_best(function_i,:) = Converage_curve_best;
    Results_Average_of_Function(function_i,1) = Aver_A;
    Results_STD_of_Function(function_i,1) = STD_A;
    Results_SEM_of_Function(function_i,1) = SEM_A;
    
    %% Results
    figure(function_i);
    semilogy(Converage_curve_best(1:1:end),'-b','LineWidth',1);
    title(['Function F-' num2str(function_i)])
    xlabel('Iterations');
    ylabel('Best Cost')
    grid on;

end
% save
save('Benchmark_data_FA.mat')

% command = pwd;
cd(Path_dir)
eval(['cd ' '.\Figure']);
% save figure
for i = 1:Number_of_function
    saveas(figure(i),['FA_F' num2str(i) '.fig']);
end
close all
%