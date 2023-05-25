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
clc
clear
close all

Algorithm_Name = 'MOPSO';
%% Parameters
Max_iter = 100; % Max Iterations
nPop = 60; % Number of population
Number_of_function = 5; % All function needed

empty.Name          = [];

empty.Best          = [];
empty.Median        = [];
empty.Worst         = [];
empty.Mean          = [];

empty.BestPF        = [];
empty.Best_PS        = [];
empty.STD           = [];
empty.SEM           = [];
empty.History       = [];

Results = repmat(empty,Number_of_function,1);
Time_store = zeros(Number_of_function,1);

empty_store.A  = [];
empty_store.B  = [];

%% For standard and best value in 30 times run the function
Time2run = 10; % times to run the function

History = repmat(empty_store,Time2run,1);

PROBLEMS= ['ZDT1 '; 'ZDT2 '; 'ZDT3 '; 'ZDT4 '; 'ZDT5 '];
DIMX    = [30 30 30 30 30];
NOP     = [100 100 100 100 100]; 
PROPERTY= ['b-'; 'b-'; 'b-'; 'b-'; 'b.'];
Archive_no = [100 100 100 100 100 ];
for F_ID = 1 : 5

    tic;
    Test_Suite = 'ZDT';
    Problem_Name = deblank(PROBLEMS(F_ID,:));
    %Create Store for save all result of functions
    [VarMin,VarMax,nVar,nObj,CostFunction] = Get_problem(Problem_Name,DIMX(F_ID));

    A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
    i_times = 0;
    while i_times < Time2run
        i_times = i_times+1;

        % Call function
        [Store,M]=MOPSO(nPop,Max_iter,VarMin,VarMax,nVar,CostFunction,nObj,Problem_Name);

        History(i_times).A = M;
        History(i_times).B = Store;

    end

    % Time caculate
    time = toc;
    for ii_times = 1 : i_times
        A(ii_times) = History(ii_times).A.IGD;
    end

    % Get best value of fitness
    [Best_A,No_A] = sort(A);
    Best = Best_A(1);

    % Median
    Median = Best_A(round(length(A)/2));
    % Worst
    Worst = Best_A(end);
    % Average
    Average = mean(A);

    % Best pareto front
    Best_PF = History(No_A(1)).B(end).Archive_F;
    % Best pareto Set
    Best_PS = History(No_A(1)).B(end).Archive_X;

    % Standard deviation
    STD_A = std(A);
    % Standard errors of mean - SEM
    SEM_A = STD_A / sqrt(length(A));

    fprintf(['\n Function F' num2str(F_ID) '\n' ...
        'Best = ' num2str(Best) '\n'...
        'Median = ' num2str(Median) '\n'...
        'Worst = ' num2str(Worst) '\n'...
        'Average = ' num2str(Average) '\n'...
        'STD =  ' num2str(STD_A) '\n'...
        'SEM = ' num2str(SEM_A) '\n',]);

    % Store the results
    Results(F_ID).Name = Problem_Name;

    Results(F_ID).Best = Best;
    Results(F_ID).Median = Median;
    Results(F_ID).Worst = Worst;
    Results(F_ID).Mean= Average;

    Results(F_ID).BestPF = Best_PF;
    Results(F_ID).Best_PS = Best_PS;
    Results(F_ID).STD= STD_A;
    Results(F_ID).SEM = SEM_A;
    Results(F_ID).Time = time;
    Results(F_ID).History = History;


    %% Get True pareto front
    [x,y]      = xyboundary(Problem_Name, Archive_no(F_ID));
    L = size(x,2);
    k = zeros(1,nVar);
    o = 0;
    % Caculate for true pareto front
    for i=1:L
        k(1) = x(i);

        if nObj == 2
            [True_ParetoFront(i,:), True_ParetoSet(i,:)] =CostFunction(k,Problem_Name);
        else
            for j = 1:L
                o = o + 1 ;
                k(2) = y(j);
                [Z1, Z2] =CostFunction(k,Problem_Name);
                True_ParetoFront(o,:) = Z1';
                True_ParetoSet(o,:) = Z2;
            end
        end
    end
    % Caculate for Obtained pareto front
    x     =  Best_PS(:,1)';
    y     =  Best_PS(:,2)';
    L = size(x,2);
    k = zeros(1,nVar);
    o = 0;
    for i=1:L
        k(1) = x(i);

        if nObj == 2
            [~, Best_Obtained_PS(i,:)] =CostFunction(k,Problem_Name);
        else
            for j = 1:L
                o = o + 1 ;
                k(2) = y(j);
                [~, Z2] =CostFunction(k,Problem_Name);
                
                Best_Obtained_PS(o,:) = Z2;
            end
        end
    end
    %=====================================================================%

    figure(F_ID)
%     subplot(1,2,1)
    if size(True_ParetoFront(i,:),2) == 2
        % True pareto front
        plot(True_ParetoFront(:,1),True_ParetoFront(:,2),deblank(PROPERTY(F_ID,:)),LineWidth=1.5)
        hold on
        % Obtained front
        scatter(Best_PF(:,1),Best_PF(:,2),SizeData=150,MarkerEdgeColor="black",MarkerFaceColor="yellow",LineWidth=2);
        
        title(Problem_Name,Interpreter='latex')
        xlabel('$F1$',Interpreter='latex');
        ylabel('$F2$',Interpreter='latex');
        grid off;
        legend("True PF", "Solution PF", 'Location', 'southwest',Interpreter='latex')
        hold off
    else
        plot3(True_ParetoFront(:,1),True_ParetoFront(:,2), True_ParetoFront(:,3),deblank(PROPERTY(F_ID,:)),LineWidth=1.5)
        box on
        hold on
        scatter3(Best_PF(:,1),Best_PF(:,2),Best_PF(:,3),SizeData=150,MarkerEdgeColor="black",MarkerFaceColor="yellow",LineWidth=2);
        title(Problem_Name,Interpreter='latex')
        ax = gca;
        ax.BoxStyle = 'full';
        ax.LineWidth = 1.5;
        title(Problem_Name,Interpreter='latex')
        xlabel('$F1$',Interpreter='latex');
        ylabel('$F2$',Interpreter='latex');
        zlabel('$F3$',Interpreter='latex');
        hold off
    end

%     subplot(1,2,2)
%     plot3(True_ParetoSet(:,1),True_ParetoSet(:,2),True_ParetoSet(:,3),deblank(PROPERTY(F_ID,:)),LineWidth=1.5)
%     hold on
%     scatter3(Best_Obtained_PS(:,1),Best_Obtained_PS(:,2),Best_Obtained_PS(:,3),SizeData=150,MarkerEdgeColor="black",MarkerFaceColor="yellow",LineWidth=2);
%         
%     title(Problem_Name,Interpreter='latex')
%     xlabel('$x1$',Interpreter='latex');
%     ylabel('$x2$',Interpreter='latex');
%     zlabel('$x3$',Interpreter='latex');
% 
%     box on
%     ax = gca;
%     ax.BoxStyle = 'full';
%     ax.LineWidth = 1.5;
%     grid off;
%     hold off
%     legend("True PF", "Solution PF", 'Location', 'southwest',Interpreter='latex')
clear True_ParetoFront True_ParetoSet
end


%% Lưu
% Tạo tên tệp tin
timestamp = datestr(now, 'ddmmyy');
history_filename = ['History_' Algorithm_Name '_' timestamp '.mat'];
results_filename = ['Results_' Algorithm_Name '_' timestamp '.mat'];

% Xác định đường dẫn tuyệt đối đến thư mục "Data"
folderPath = fullfile(pwd, 'Data');

% Kiểm tra nếu thư mục không tồn tại, thì tạo mới
if ~isfolder(folderPath)
    mkdir(folderPath);
end

% Lưu biến History vào tệp tin
save(fullfile(folderPath, history_filename), 'History', '-v7.3');

% Lưu biến Results vào tệp tin
save(fullfile(folderPath, results_filename), 'Results', '-v7.3');


% Lưu tất cả các hình lại
Figname = Problem_Name;
folderName = 'Figure';

% Create the folder if it doesn't exist
if ~exist(folderName, 'dir')
    mkdir(folderName);
end

for i = 5:Number_of_function
    figName = strcat(Figname,'_',num2str(i));
    figPath = fullfile(folderName, [figName, '.fig']);
    hgsave(figure(i),figPath);
end
