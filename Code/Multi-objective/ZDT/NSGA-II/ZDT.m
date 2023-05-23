%==========================================================================
%  ZDT test problems
%  x : denotes input
%  M : denotes number of output/objectives (nObj)
%  nVar : denotes number of input - variables or dimension
%  NoProb : denotes No. of problem
%  Developed in MATLAB R2022a
%
%  Developer : Le Xuan Thang
%
%  email: lxt1021997lxt@gmail.com
%
%==========================================================================
function [f,ps] = ZDT(x,Problem_Name)

switch Problem_Name
    case 'ZDT1' % ZDT1
        [f,ps] = ZDT1(x);

    case 'ZDT2' % ZDT2
        [f,ps] = ZDT2(x);
    case 'ZDT3'
        [f,ps]= ZDT3(x);
    case 'ZDT4'
        [f,ps]= ZDT4(x);
    case 'ZDT5'
        [f,ps] = ZDT5(x);
    otherwise
        error('No problem in here')

end


%% ZDT1
    function [f,ps] = ZDT1(x)
        nVar = numel(x);
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-sqrt(F1/g));

        f = [F1
            F2];
        ps = x;
    end



    function [f,ps] = ZDT2(x)
        nVar = numel(x);
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-power(F1/g,2));
        f = [F1
            F2];
        ps = x;
    end
    function [f,ps] = ZDT3(x)
        nVar = numel(x);
        % ZDT3
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-sqrt(F1/g)-F1/g*sin(10*pi()*F1));
        f = [F1
            F2];
        ps = x;
    end

    function [f,ps] = ZDT4(x)
        nVar = numel(x);
        % ZDT1 wit linear PF
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-(F1/g));

        f = [F1
            F2];
        ps = x;

    end
    function [f,ps] = ZDT5(x)
        nVar = numel(x);
        % ZDT 2 with 3 object
        % G(x)
        g = 1 + 9*sum(x(3:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = x(2);
        % F3
        F3 = g*(1-power(F1/g,2))*(1-power(F2/g,2));

        % Z
        f = [F1
            F2
            F3];
        ps = x;
    end
end