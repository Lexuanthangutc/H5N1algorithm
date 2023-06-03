
%% Get Data of Algorithm Data

% Le Xuan Thang 
% Contact infor
% Email: lxt1021997lxt@gmail.com
% University of Transport and Communications
% 

clc
clear
close all
% Đường dẫn tới các folder
folderPaths = {'01_AOA', '02_CS','03_PSO','04_BBO','05_GA','06_DE','07_GSA','09_MFO','10_GWO','11_SSA','12_H5N1'};

resultMatrix = [];
result_BestCost = zeros(length(folderPaths),23);
result_Average = zeros(length(folderPaths),23);
result_STD = zeros(length(folderPaths),23);
result_Time = zeros(length(folderPaths),23);
% Lặp qua các folder
for i = 1:length(folderPaths)
    folderPath = folderPaths{i};
    
    % Tạo đường dẫn đến thư mục Data
    dataFolderPath = fullfile(folderPath, 'Code', 'Data');
    
    % Lấy danh sách các file .mat trong thư mục Data
    matFiles = dir(fullfile(dataFolderPath, '*.mat'));

    % Khởi tạo ma trận tạm thời cho folder hiện tại
%     folderResultMatrix = [];
    Store_BestCost = [];
    Store_Average = [];
    Store_STD = [];
    Store_Time = [];
    % Lặp qua từng file .mat
    for j = 1:length(matFiles)
        matFilePath = fullfile(dataFolderPath, matFiles(j).name);
        
        % Đọc file .mat
        matData = load(matFilePath);
        
        % Truy cập vào biến Results
        Results = matData.Results;
        
        % Lặp qua các struct trong Results
        for k = 1:length(Results)
%             % Truy cập vào trường History.A
%             historyA = [Results(k).History.A];
            BestCost = [Results(k).BestCost];
            Average = [Results(k).Mean];
            STD = [Results(k).STD];
            Time = [Results(k).Time];

%             % Lưu giá trị vào ma trận tạm thời
%             folderResultMatrix = [folderResultMatrix; historyA];
            Store_BestCost = [Store_BestCost;BestCost];
            Store_Average = [Store_Average;Average];
            Store_STD = [Store_STD;STD];
            Store_Time = [Store_Time;Time];
        end
    end
%     Nối ma trận tạm thời của folder hiện tại vào ma trận tổng
    result_BestCost(i,:) = Store_BestCost';
    result_Average(i,:) = Store_Average';
    result_STD(i,:) = Store_STD';
    result_Time(i,:)= Store_Time';
end


%% Lưu
% Tạo tên tệp tin
timestamp = datestr(now, 'ddmmyy');
results_filename = ['Results_Matrix_' timestamp '.mat'];

% Lưu biến Results vào tệp tin
save(fullfile(folderPath, results_filename), 'result_BestCost','result_Average','result_STD','result_Time', '-v7.3');


