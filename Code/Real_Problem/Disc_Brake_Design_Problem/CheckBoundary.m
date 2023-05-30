% [pop_New] = CheckBoundary(pop_Old,VarMin,VarMax)
% This function checks and adjusts the boundaries of a population matrix
% based on the lower and upper bounds. If an element of the population
% matrix exceeds the upper bound or falls below the lower bound, the
% function adjusts it to the closest bound.
%
% Inputs:
%   pop_Old: the old population matrix
%   VarMin: the lower bound vector (1xn)
%   VarMax: the upper bound vector (1xn)
%
% Outputs:
%   pop_New: the adjusted population matrix
%
% Example usage:
% pop_Old = [1,2,3; 4,5,6; 7,8,9];
% VarMin = [-1,-1,-1];
% VarMax = [2,2,2];
% pop_New = CheckBoundary(pop_Old, VarMin, VarMax);
%
% In this example, the population matrix pop_Old has three dimensions, and
% the lower and upper bounds for each dimension are specified by the
% vectors VarMin and VarMax, respectively. The function returns the
% adjusted population matrix pop_New, where the elements that exceed the
% upper bound or fall below the lower bound have been pulled back to the
% closest bound.
%-------------------------------------------------------------------------
%  Developed in MATLAB R2022
%
%  Author and programmer: Le Xuan Thang / Viktor
%
%         e-Mail: lxt1021997lxt@gmail.com
%                 thang4201097sdh@lms.utc.edu.vn

function pop_New = CheckBoundary(pop_Old,VarMin,VarMax)


% Check the number of inputs
if nargin > 3
    error('Check your number of inputs');
end

        Flag_ub = pop_Old > VarMax;
        Flag_lb = pop_Old < VarMin;
        
        pop_New =(pop_Old.*(~(Flag_ub+Flag_lb)))...
            + VarMax.*Flag_ub + VarMin.*Flag_lb;
        % end check
        
end % end check



        