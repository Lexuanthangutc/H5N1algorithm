clc
zzzz = 1;
vars = who;  % Get a list of all current variables
vars(strcmp(vars, 'Results')) = [];  % Remove the 'Results' variable from the list
clear(vars{:});  % Clear all variables in the list
close all
MaxIter = 500;

%% In tất cả 3 function dưới dạng 3D
for i_F = [16,18,19,20,21,25]
    func_name = ['F' num2str(i_F)];
    % Tạo ảnh
    fig = figure(i_F);
    [x,y,f] = func_plot(func_name);
    surfc(x,y,f);
    % Tạo colormap từ màu invert của HSV
    colormap(flipud(hsv))
%     view(45,45)
    box on
    ax = gca;
    ax.BoxStyle = 'full';
    grid off
    title(['F' num2str(i_F)],Interpreter="latex")
end

% Lưu tất cả các hình lại
Figname = 'F';
folderName = 'Figure';

% Create the folder if it doesn't exist
if ~exist(folderName, 'dir')
    mkdir(folderName);
end

for i = [16,18,19,20,21,25]
    figName = strcat(Figname, num2str(i));
    figPath = fullfile(folderName, [figName, '.fig']);
    hgsave(figure(i),figPath);
end

% % % % Load data
% if exist('Result','var')
% 
% else
% load('Results_H5N1_150523.mat')
% end

%% In Search hisory

% % In hình ảnh 2 chiều của hàm
% for i_F = 1:13
%     func_name = ['F' num2str(i_F)];
%     fig = figure(i_F);
%     [x,y,f] = func_plot(func_name);
%     [x_lim,y_lim]=func_boundary(func_name);
%     if i_F == 2 || i_F == 4
%         contour(x,y,f,'LevelList',[10,20,30,40,50,60,70,80,90,100)
%     else
%         contour(x,y,f)
%     end
%     
%     colormap(flipud(hsv))
%     xlabel('x1')
%     ylabel('x2')
% 
%     title('Search history')
%     hold on
% 
% 
%     for i_runtimes = 1:30
%         zzz=0;
%         BestPosition = Results(i_F).BestPosition;
%         BestPosition_History = Results(i_F).History(i_runtimes).C;
%         x =  Results(i_F).History(1).D(1).popPosition;
%         [x_row, x_col] = size(x);
%         x1 = zeros(x_row,1);
%         x2 = zeros(x_row,1);
%         A = norm(BestPosition - BestPosition_History);
%         if A == 0
%             for i_iter = 1: MaxIter
%                 x1(:,1) = Results(i_F).History(i_runtimes).D(i_iter).popPosition(:,1);
%                 x2(:,1) = Results(i_F).History(i_runtimes).D(i_iter).popPosition(:,2);
%                 if i_F == 16
%                     x2(:,1) = Results(i_F).History(i_runtimes).D(i_iter).popPosition(:,1);
%                     x1(:,1) = Results(i_F).History(i_runtimes).D(i_iter).popPosition(:,2);
%                 end
%                 % Lấy màu cho điểm tối ưu
%                 if i_iter == MaxIter
%                     x1(:,1) = Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Position(:,1);
%                     x2(:,1) = Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Position(:,2);
%                     if i_F == 16
%                         x2(:,1) = Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Position(:,1);
%                         x1(:,1) = Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Position(:,2);
%                     end
%                     scatter(x1,x2,'r','filled');
%                 else
%                     scatter(x1,x2,'k','filled');
%                 end
%             end
%             zzz = 1;
%             break
%         end
%         if zzz == 1
%             break
%         end
%     end
% 
%     grid on
%     xlim(x_lim)
%     ylim(y_lim)
%     hold off
% 
% end

% % Lưu tất cả các hình lại
% Figname = 'Search_history';
% folderName = 'Figure';
% 
% % Create the folder if it doesn't exist
% if ~exist(folderName, 'dir')
%     mkdir(folderName);
% end
% 
% for i = 1:23
%     figName = strcat(Figname, num2str(i));
%     figPath = fullfile(folderName, [figName, '.fig']);
%     hgsave(figure(i),figPath);
% end

%% In coefficient


% % Lấy c,p,w
% % In hình ảnh 2 chiều của hàm
% for i_F = 1:23
%     func_name = ['F' num2str(i_F)];
%     fig = figure(i_F);
% 
%     xlabel('iterations')
%     ylabel('Coefficient')
% 
%     title('$c, p ,w$', 'Interpreter', 'latex')
%     hold on
% 
% 
%     for i_runtimes = 1:30
%         zzz=0;
%         BestPosition = Results(i_F).BestPosition;
%         BestPosition_History = Results(i_F).History(i_runtimes).C;
% %         x =  Results(i_F).History(1).D(1).popPosition;
% %         [x_row, x_col] = size(x);
%         c = zeros(MaxIter,1);
%         p = zeros(MaxIter,1);
%         w = zeros(MaxIter,1);
%         A = norm(BestPosition - BestPosition_History);
%         if A == 0
%             for i_iter = 1: MaxIter
%                 c(i_iter) =  Results(i_F).History(i_runtimes).D(i_iter).c;
%                 p(i_iter) =  Results(i_F).History(i_runtimes).D(i_iter).p;
%                 w(i_iter) =  Results(i_F).History(i_runtimes).D(i_iter).w;
%             end
%             zzz = 1;
%             break
%         end
%         if zzz == 1
%             break
%         end
%     end
% 
%     grid on
%     scatter(1:MaxIter,c,'red','filled')
%     scatter(1:MaxIter,p,'blue','filled')
%     scatter(1:MaxIter,w,'green','filled')
%     ylim([0 1])
%     legend('$c$','$p$','$w$', 'Interpreter', 'latex')
%     hold off
% 
% end
% 
% 
% % Lưu tất cả các hình lại
% Figname = 'Coefficient';
% folderName = 'Figure';
% 
% % Create the folder if it doesn't exist
% if ~exist(folderName, 'dir')
%     mkdir(folderName);
% end
% 
% for i = 1:23
%     figName = strcat(Figname, num2str(i));
%     figPath = fullfile(folderName, [figName, '.fig']);
%     hgsave(figure(i),figPath);
% end


% %% In Trajectory
% 
% 
% % In 
% for i_F = 1:23
% 
%     func_name = ['F' num2str(i_F)];
% 
% 
%     for i_runtimes = 1:30
%         zzz=0;
%         BestPosition = Results(i_F).BestPosition;
%         BestPosition_History = Results(i_F).History(i_runtimes).C;
%         x =  Results(i_F).History(1).D(1).popPosition;
%         [x_row, x_col] = size(x);
%         x1 = zeros(MaxIter,1);
%         fit_mean = zeros(MaxIter,1);
%         fit_best = zeros(MaxIter,1);
%         A = norm(BestPosition - BestPosition_History);
%         if A == 0
%             for i_iter = 1: MaxIter
%                 x1(i_iter,1) = mean(Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Position(:));
%                 fit_mean(i_iter,1) = mean(Results(i_F).History(i_runtimes).D(i_iter).popBestCost(:,1));
%                 fit_best(i_iter,1) = Results(i_F).History(i_runtimes).D(i_iter).GlobalBest_Cost(1);
%             end
%             zzz = 1;
%             break
%         end
%         if zzz == 1
%             break
%         end
%     end
%     fig = figure(i_F);
%     plot(1:MaxIter,x1,'Color','red',LineWidth=2)
% %      semilogy(1:MaxIter,fit_mean,'Color',[0.5, 0, 0.3],LineWidth=2) % average fitness
% %     semilogy(fit_best,'Color',[1, 0.5, 0],LineWidth=2,LineStyle='-.') % best fitness
%    
%     xlabel('Iterations','Interpreter','latex',FontSize=13,FontWeight='bold')
%     ylabel('$x_1$','Interpreter','latex',FontSize=13,FontWeight='bold')
%     title('Trajectory $x1$','Interpreter','latex',FontSize=13,FontWeight='bold')
%     axis tight
%     grid off
% 
% end
% 
% % Lưu tất cả các hình lại
% Figname = 'Trajectory';
% folderName = 'Figure';
% 
% % Create the folder if it doesn't exist
% if ~exist(folderName, 'dir')
%     mkdir(folderName);
% end
% 
% for i = 1:23
%     figName = strcat(Figname, num2str(i));
%     figPath = fullfile(folderName, [figName, '.fig']);
%     hgsave(figure(i),figPath);
% end


