
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
% Lặp qua các folder
for i = 1:length(folderPaths)
    folderPath = folderPaths{i};
    
    % Tạo đường dẫn đến thư mục Data
    dataFolderPath = fullfile(folderPath, 'Code', 'Data');
    
    % Lấy danh sách các file .mat trong thư mục Data
    matFiles = dir(fullfile(dataFolderPath, '*.mat'));

    % Khởi tạo ma trận tạm thời cho folder hiện tại
    folderResultMatrix = [];
    % Lặp qua từng file .mat
    for j = 1:length(matFiles)
        matFilePath = fullfile(dataFolderPath, matFiles(j).name);
        
        % Đọc file .mat
        matData = load(matFilePath);
        
        % Truy cập vào biến Results
        Results = matData.Results;
        
        % Lặp qua các struct trong Results
        for k = 1:length(Results)
            % Truy cập vào trường History.A
            historyA = [Results(k).History.A];
            
            % Lưu giá trị vào ma trận tạm thời
            folderResultMatrix = [folderResultMatrix; historyA];
        end
    end
    % Nối ma trận tạm thời của folder hiện tại vào ma trận tổng
    resultMatrix{i} = folderResultMatrix;
end





