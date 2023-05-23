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
function z = ZDT(x,Problem_Name)

switch Problem_Name
    case 'ZDT1' % ZDT1
        [z] = ZDT1(x);

    case 'ZDT2' % ZDT2
        [z] = ZDT2(x);
    case 'ZDT3'
        [z] = ZDT3(x);
    case 'ZDT4'
        [z] = ZDT4(x);
    case 'ZDT5'
        [z] = ZDT5(x);
    otherwise
        error('No problem in here')

end


%% ZDT1
    function z = ZDT1(x)
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-sqrt(F1/g));

        z = [F1
            F2];
    end



    function z = ZDT2(x)
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-power(F1/g,2));
        z = [F1
            F2];
    end
    function z = ZDT3(x)
        % ZDT3
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-sqrt(F1/g)-F1/g*sin(10*pi()*F1));
        z = [F1
            F2];
    end

    function z = ZDT4(x)
        % ZDT1 wit linear PF
        g = 1+9*sum(x(2:end))/(nVar-1);
        % F1
        F1 = x(1);
        % F2
        F2 = g*(1-(F1/g));

        z = [F1
            F2];

    end
    function z = ZDT5(x)
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
        z = [F1
            F2
            F3];
    end
end