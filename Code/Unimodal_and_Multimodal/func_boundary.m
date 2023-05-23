function [x_lim, y_lim] = func_boundary(func_name)

switch func_name 
    case 'F1' 
        x_lim=[-100,100]; y_lim=x_lim; %[-100,100]
        
    case 'F2' 
        x_lim=[-10,10]; y_lim=x_lim; %[-10,10]
        
    case 'F3' 
        x_lim=[-100,100]; y_lim=x_lim; %[-100,100]
        
    case 'F4' 
        x_lim=[-100,100]; y_lim=x_lim; %[-100,100]
    case 'F5' 
        x_lim=[-30,30]; y_lim=x_lim; %[-5,5]
    case 'F6' 
        x_lim=[-100,100]; y_lim=x_lim; %[-100,100]
    case 'F7' 
        x_lim=[-1,1];  y_lim=x_lim;  %[-1,1]
    case 'F8' 
        x_lim=[-500,500];y_lim=x_lim; %[-500,500]
    case 'F9' 
        x_lim=[-5,5];   y_lim=x_lim; %[-5,5]    
    case 'F10' 
        x_lim=[-20,20]; y_lim=x_lim;%[-500,500]
    case 'F11' 
        x_lim=[-500,500]; y_lim=x_lim;%[-0.5,0.5]
    case 'F12' 
        x_lim=[-10,10]; y_lim=x_lim;%[-pi,pi]
    case 'F13' 
        x_lim=[-5,5]; y_lim=x_lim;%[-3,1]
    case 'F14' 
        x_lim=[-40,40]; y_lim=x_lim;%[-100,100]
    case 'F15' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]
    case 'F16' 
        x_lim=[-1,1]; y_lim=x_lim;%[-5,5]
    case 'F17' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]
    case 'F18' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]
    case 'F19' 
        x_lim=[-0.5,0.5]; y_lim=[-1,1];%[-5,5]
    case 'F20' 
        x_lim=[0,1]; y_lim=x_lim;%[-5,5]        
    case 'F21' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]
    case 'F22' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]     
    case 'F23' 
        x_lim=[-5,5]; y_lim=x_lim;%[-5,5]  
end   