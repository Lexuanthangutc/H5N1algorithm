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

Algorithm_Name = 'MH5N1';
%% Parameters
Max_iter = 1000; % Max Iterations
nPop = 200; % Number of population
Number_of_function = 1; % All function needed

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
Time2run = 100; % times to run the function

History = repmat(empty_store,Time2run,1);

for F_ID = 1 : Number_of_function

    tic;
    Test_Suite = 'DiscBrake ';
    Problem_Name = deblank(Test_Suite);
    Boundary = [55 80
        75 110
        1000 3000
        2 20];
    ub = Boundary(:,2)';
    lb = Boundary(:,1)';
    nObj = 2;
    nVar = length(ub);
    CostFunction = @Disc_Brake_Design_Problem;

    A = zeros(Time2run,1); % A = X*1; store the value of Best fitness for X times to run
    i_times = 0;
    while i_times < Time2run
        i_times = i_times+1;
        % Call MH5N1 function

        [Store,M]=MH5N1(nPop,Max_iter,lb,ub,nVar,CostFunction,nObj);

        History(i_times).A = M;
        History(i_times).B = Store;

    end

    % Time caculate
    time = toc;
    for ii_times = 1 : i_times
        A(ii_times) = History(ii_times).A.Archive_min;
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
    Archive_member_no = 100;
    x = zeros(numel(lb),Archive_member_no);
    for i_F = 1:numel(lb)
        x(i_F, :)=linspace(lb(i_F),ub(i_F),Archive_member_no);
    end

    y = x;
    L=size(x,2);

    if nObj == 2
        True_ParetoFront = zeros(L,nObj);
        for i=1:L
            if i == 100
                k=1;
            end
            [~,True_ParetoFront(i,:)]=CostFunction([x(1,i) x(2,i) x(3,i) x(4,i)]);
        end
    end

    figure(F_ID)


    % True pareto front
    %         plot(True_ParetoFront(:,1),True_ParetoFront(:,2),'b-',LineWidth=1.5)
    %         hold on
    % Obtained front
    scatter(Best_PF(:,1),Best_PF(:,2),SizeData=150,MarkerEdgeColor="black",MarkerFaceColor="yellow",LineWidth=2);

    title(Problem_Name,Interpreter='latex')
    xlabel('$F1$',Interpreter='latex');
    ylabel('$F2$',Interpreter='latex');
    grid off;
    legend("True PF", "Solution PF", 'Location', 'northeast',Interpreter='latex')
    hold off



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

for i = 1:Number_of_function
    figName = strcat(Figname,'_',num2str(i));
    figPath = fullfile(folderName, [figName, '.fig']);
    hgsave(figure(i),figPath);
end
