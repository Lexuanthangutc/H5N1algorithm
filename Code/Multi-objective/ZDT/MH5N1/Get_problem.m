%==========================================================================
%% Get problems
%  INPUT of function
%  ProblemName : Name of Group problem
%  NoProb : Number of problem in the group of problems
%  OUTPUT of function
%  VarMin : lower boundary
%  VarMax : upper boundary
%  nVar : number of variables or dimension
%  nObj : denotes number of output/object
%  CostFunction: Call function of group problem
%% Summary what we have
% ZDT have 4 problem 1,2,3,7
% DTLZ have 7 problem
% CEC2009 have 12 problem
%% Contact Infor
%  Developed in MATLAB R2022a
%
%  Developer : Le Xuan Thang
%
%  eMail: lxt1021997lxt@gmail.com
%
%==========================================================================

%% Function
function [VarMin,VarMax,nVar,nObj,CostFunction] = Get_problem(name,dim)

% Get Group Name of Problem only
xrange = xboundary(name,dim);
VarMin = xrange(:,1)';
VarMax = xrange(:,2)';
nVar = dim;
CostFunction = str2func('ZDT');
% Extract group of Problem Name
switch name
    case {'ZDT5'}
        nObj = 3;

    otherwise
        nObj = 2;
end
end