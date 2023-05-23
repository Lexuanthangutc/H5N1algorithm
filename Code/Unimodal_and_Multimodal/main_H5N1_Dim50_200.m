% H5N1
% by Le Xuan Thang
clc
clear
close all

%Get pwd
Path_dir = pwd;
Algorithm_Name = 'H5N1';
%% Parameters
Max_iter = 500; % Max Iterations
nPop = 30; % Number of population
Number_of_function = 13; % All function needed

Time_store = zeros(Number_of_function,1);

empty_store.A  = [];
empty_store.B  = [];
empty_store.C  = [];
empty_store.D  = [];
%% For standard and best value in 30 times run the function
Time2run = 30; % times to run the function

History = repmat(empty_store,Time2run,1);

listnVar = (50:10:200) ;
Store_Aver_A = zeros(length(listnVar),1);
for F_ID = 5 : 5
    for  i_nVar = 1:length(listnVar)
        nVar = listnVar(i_nVar);
        tic;

        Function_Name = (['F', num2str(F_ID)]);
        % Load details of the selected benchmark function
        [VarMin,VarMax,~,CostFunction]=Get_F(Function_Name);

        A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
        B = zeros(Time2run,Max_iter); % B = X*max_iter; store the value of Best fitness for X times to run
        C = zeros(Time2run,nVar); % C = X*nVar; store the value of Best fitness for X times to run

        for i_times = 1 : Time2run
            % Call H5N1 function
            [GlobalBest_Cost,GlobalBest_Position,BestCosts,Store]=H5N1(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction);

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
        
        Store_Aver_A(i_nVar) = Aver_A;
    end
    figure(F_ID)
    plot(listnVar,Store_Aver_A,'LineWidth',3,'Color','#FFA500')
    hold on
    scatter(listnVar, Store_Aver_A, 'filled', 'MarkerFaceColor', '#FFA500', 'MarkerEdgeColor', 'blue', 'LineWidth', 1.5,'SizeData',200)
    title('F5',Interpreter='latex')
    xlabel('Dimensions','Interpreter','latex')
    ylabel('Average value','Interpreter','latex')
    box on
    hold off
end


% % save
% save(['History_' num2str(Algorithm_Name) '_150523.mat'],'History','-v7.3')
% save(['Results_' num2str(Algorithm_Name) '_150523.mat'],'Results','-v7.3')
% % save multi dimension
% save(['History_' Algorithm_Name '_Dim' num2str(nVar) '_150523.mat'],'History','-v7.3')
% save(['Results_' Algorithm_Name '_Dim' num2str(nVar) '_150523.mat'],'Results','-v7.3')
save(['History_' Algorithm_Name '_F5_Dim50to200'  '_150523.mat'],'History','-v7.3')
save(['Results_' Algorithm_Name '_F5_Dim50to200'  '_150523.mat'],'Results','-v7.3')

% Lưu tất cả các hình lại
Figname = 'H5N1_F5_Dim50to200';
folderName = 'Figure';

% Create the folder if it doesn't exist
if ~exist(folderName, 'dir')
    mkdir(folderName);
end

for i = 5:5
    figName = strcat(Figname, num2str(i));
    figPath = fullfile(folderName, [figName, '.fig']);
    hgsave(figure(i),figPath);
end


