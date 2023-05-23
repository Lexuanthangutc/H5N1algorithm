% The Matlab source codes to generate the boudnaries of the test instances
%   for CEC 2009 Multiobjective Optimization Competition. 
% Please refer to the report for correct one if the source codes are not
%   consist with the report.
% History:
%   v1 Sept.05 2008

function range = xboundary(name,dim)

    range = ones(dim,2);
    
    switch name
        case {'ZDT1','ZDT2','ZDT3','ZDT4','ZDT5'}
            range(:,1)      =  0;
            range(:,2)      =  1;
    end
end