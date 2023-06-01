%_______________________________________________________________________________________
%  The Arithmetic Optimization Algorithm (AOA) source codes demo version 1.0                  
%                                                                                       
%  Developed in MATLAB R2015a (7.13)                                                    
%                                                                                       
%  Authors: Laith Abualigah, Ali Diabat, Seyedali Mirjalili, Mohamed Abd Elaziz, & Amir H. Gandomi                      
%                                                                                       
%  E-Mail: Aligah.2020@gmail.com  (Laith Abualigah)                                               
%  Homepage:                                                                       
%  1- https://scholar.google.com/citations?user=39g8fyoAAAAJ&hl=en               
%  2- https://www.researchgate.net/profile/Laith_Abualigah                       
%                                                                                      
% Main paper:   The Arithmetic Optimization Algorithm
% Reference: Abualigah, L., Diabat, A., Mirjalili, S., Abd Elaziz, M., and Gandomi, A. H. (2021). The Arithmetic Optimization Algorithm. Computer Methods in Applied Mechanics and Engineering.
%
%_______________________________________________________________________________________
close all
clear 
clc


Solution_no=20; %Number of search solutions
F_name='F4';    %Name of the test function F1-f23
M_Iter=1000;    %Maximum number of iterations
 
[LB,UB,Dim,F_obj]=Get_F(F_name); %Give details of the underlying benchmark function

[Best_FF,Best_P,Store_Best_P,Conv_curve]=AOA(Solution_no,M_Iter,LB,UB,Dim,F_obj); % Call the AOA 
 

figure('Position',[454   445   1000   297]);
% figure 1
subplot(1,3,1);
[x,y,f] = func_plot(F_name);
[px,py] = gradient(f,0.2);

contour(x,y,f,'LevelList',-200:5:200)
title('Search History')
xlabel('x_1');
ylabel('x_2');
xlim([-10,10])
ylim([-10,10])
hold on
%% Using PCA to bring Dim to 2Dimension
% Subtract the mean to use PCA
[X_norm, mu, sigma] = featureNormalize(Store_Best_P);

% PCA and project the data to 2D
[U, S] = pca(X_norm);
Z = projectData(X_norm, U, 2);


scatter(Z(1:1000,1),Z(1:1000,2),"black",'filled')
scatter(Z(1000,1),Z(1000,2),"red","filled")
hold off

% figure 2
subplot(1,3,2);
func_plot(F_name);

box on
ax = gca;
ax.BoxStyle = 'full';

title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([F_name,'( x_1 , x_2 )'])

% figure 3
subplot(1,3,3);
semilogy(Conv_curve,'Color','r','LineWidth',2)
title('Convergence curve')
xlabel('Iterations');
ylabel('Best fitness function');
axis tight
legend('AOA')

% announcement
display(['The best-obtained solution by Math Optimizer is : ', num2str(Best_P)]);
display(['The best optimal value of the objective funciton found by Math Optimizer is : ', num2str(Best_FF)]);

        



