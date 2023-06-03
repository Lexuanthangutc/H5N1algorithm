%_________________________________________________________________________________
%  H5N1 algorithm source codes version 1.0
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

function [LB,UB,Dim,F_obj] = Get_CEC05_F(ifun)


parts = strsplit(ifun,'F');
ifun = str2double(parts{2});

switch ifun
    case{1}
        
        Dim    = 30;
        F_obj    = 'sphere';
        UB    = 100;
        LB    =  -100;     % 1
    case{2}
        
        Dim   = 30;
        F_obj    = 'shiftSchwefel12';
        UB    = 100;
        LB     =  -100;   % 2
    case{3}
        
        Dim   = 30;
        F_obj    = 'shiftelliptic';
        UB    = 100;
        LB    = -100;  % 3
    case{4}
        
        Dim   = 30;
        F_obj    = 'shiftSchwefel12noise';
        UB   = 100;
        LB     =  -100;   % 4
    case{5}
        
        Dim   = 30;
        F_obj    = 'Schwefel206';
        UB    = 100;
        LB    =  -100;  % 5
    case{6}
        
        Dim   = 30;
        F_obj    = 'shiftRosenbrock';
        UB    = 100;
        LB     =  -100;  % 6
    case{7}
        
        Dim   = 30;
        F_obj    = 'rotateshiftGrievank';
        UB    =600;
        LB    = -600; 
    case{8}
        
        Dim   = 30;
        F_obj    = 'rotateshiftAckly';
        UB    = 32;
        LB     =  -32;    % 8
    case{9}
        
        Dim   = 30;
        F_obj    = 'shiftRastrigrin';
        UB    = 5;
        LB    =  -5;    % 9
    case{10}
        
        Dim   = 30;
        F_obj    = 'rotateshiftRastrigrin';
        UB    = 5;
        LB    = - 5;    % 10
    case{11}
        
        Dim   = 30;
        F_obj    = 'ShiftedRotatedWeierstrass';
        UB    = 0.5;
        LB    = - 0.5;   % 10
    case{12}
        
        Dim   = 30;
        F_obj    = 'Schwefel213';
        UB    = pi;
        LB   = -pi;     % 10
    case{13}
        
        Dim   = 30;
        F_obj    = 'EF8F2';
        UB    = 1;
        LB    = -3;  % 10
    case{14}
        
        Dim   = 30;
        F_obj    = 'ScafferF6fun';
        UB    = 100;
        LB    = - 100;     % 10
    case{15}
        
        Dim   = 30;
        F_obj    = 'hybrid_func1';
        UB    =5;
        LB    =-5;    % 10
    case{16}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func1';
        UB   =5;
        LB    =-5;    % 10
    case{17}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func1_noise';
        UB    =5;
        LB    =-5;       % 10
    case{18}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func2';
        UB   =5;
        LB    =-5; % 10
    case{19}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func2_narrow';
        UB   =5;
        LB    =-5; % 10
    case{20}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func2_onbound';
        UB   =5;
        LB    =-5; % 10
    case{21}
        
        Dim   = 30; 
        F_obj    = 'hybrid_rot_func3'; 
        UB   =5;   
        LB    =-5; % 10
    case{22}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func3_highcond';   
        UB   =5;   
        LB    =-5; % 10
    case{23}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func3_noncont';  
        UB   =5;    
        LB    =-5; % 10
    case{24}
        
        Dim   = 30;
        F_obj    = 'hybrid_rot_func4';  
        UB   =5;     
        LB    =-5; % 10
    case{25}
        
        Dim   = 30;  
        F_obj    = 'hybrid_rot_func4';  
        UB   =5;     
        LB    =-2;
end
F_obj = str2func(F_obj);