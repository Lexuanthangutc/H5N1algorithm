%==========================================================================
%  CEC2009 test problems
%  x : input
%  M : number of output/objectives (nObj)
%  f : get pareto front
%  ps: get parero set
%  Developed in MATLAB R2022a
%
%  Developer : Le Xuan Thang
%
%  email: lxt1021997lxt@gmail.com
%
%==========================================================================
function [f,ps] = CEC2009(x,Problem_Name)


switch Problem_Name
    case 'UF1'
        [f,ps] = UF1(x);

    case 'UF2'
        [f,ps] = UF2(x);

    case 'UF3'
        [f,ps] = UF3(x);

    case 'UF4'
        [f,ps] = UF4(x);

    case 'UF5'
        [f,ps] = UF5(x);

    case 'UF6'
        [f,ps] = UF6(x);

    case'UF7'
        [f,ps] = UF7(x);

    case 'UF8'
        [f,ps] = UF8(x);

    case 'UF9'
        [f,ps] = UF9(x);

    case 'UF10'
        [f,ps] = UF10(x);
end

%% UF1
function [f,ps] = UF1(x)
n = length(x);
x1 = x(1);
for j = 2:n
    x(j) = sin(6*pi*x1 + (j*pi/n));
end
%
[dim, num]  = size(x);
if dim < num
    x = x';
    [dim, num]  = size(x);
end

tmp         = zeros(dim,num);

tmp(2:dim,:) = (x(2:dim,:) - sin(6.0*pi*repmat(x(1,:),[dim-1,1]) + pi*repmat((2:dim)',[1,num])/dim)).^2;

tmp1        = sum(tmp(3:2:dim,:));  % odd index
tmp2        = sum(tmp(2:2:dim,:));  % even index

f(1,:)      = x(1,:)             + 2.0*tmp1/size(3:2:dim,2);
f(2,:)      = 1.0 - sqrt(x(1,:)) + 2.0*tmp2/size(2:2:dim,2);

ps = x;

end


%% UF2
function [f,ps] = UF2(x)
n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n

    % odd / số lẻ
    if mod(j,2) == 1
        x(j) = (0.3*x1^2*cos(24*pi*x1+(4*j*pi/n)) + 0.6*x1) * cos(6*pi*x1 + j*pi/n);

        yj_odd = yj_odd + x(j) - (0.3*x1^2*cos(24*pi*x1+(4*j*pi/n)) + 0.6*x1) * cos(6*pi*x1 + j*pi/n);

        f1 = x1 + (2/abs(j)) * yj_odd;
        % even / số chẵn
    else
        x(j) = (0.3*x1^2*cos(24*pi*x1+(4*j*pi/n)) + 0.6*x1) * sin(6*pi*x1 + j*pi/n);

        yj_even = yj_even + x(j) - (0.3*x1^2*cos(24*pi*x1+(4*j*pi/n)) + 0.6*x1) * sin(6*pi*x1 + j*pi/n);

        f2 = 1 - sqrt(x1) + (2/abs(j)) * yj_even;
    end
end
f=[f1;f2];
ps = x;

end

%% UF3
function [f,ps] = UF3(x)

n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n
    x(j) = x1^(0.5*(1+(3*(j-2)/(n-2))));
    % odd / số lẻ
    if mod(j,2) == 1


        yj_odd = yj_odd + x(j) -x1^(0.5*(1+(3*(j-2)/(n-2))));

        f1 = x1 + ((2/abs(j)) * (4*yj_odd^2 - 2*prod(cos((20*yj_odd*pi)/sqrt(j))) + 2));
        % even / số chẵn
    else

        yj_even = yj_even + x(j) -x1^(0.5*(1+(3*(j-2)/(n-2))));

        f2 = 1 - sqrt(x1) + ((2/abs(j)) * (4*yj_odd^2 - 2*prod(cos((20*yj_odd*pi)/sqrt(j)))+2));
    end
end

f=[f1
    f2];
ps = x;

end

%% UF4
function [f,ps] = UF4(x)

n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n
    x(j) = sin((6*pi*x1) + (j*pi)/n);
    % odd / số lẻ
    if mod(j,2) == 1


        yj_odd = yj_odd + x(j) - sin((6*pi*x1) + (j*pi)/n);
        hj_odd = yj_odd/(1 + exp(2+yj_odd));

        f1 = x1 + ((2/abs(j)) * hj_odd);
        % even / số chẵn
    else

        yj_even = yj_even + x(j) - sin((6*pi*x1) + (j*pi)/n);
        hj_even = yj_even/(1 + exp(2+yj_even));

        f2 = 1 - x1^2 + ((2/abs(j)) * hj_even);
    end
end

f=[f1
    f2];
ps = x;
end

%% UF5
function [f,ps] = UF5(x)
N = 10;
epsilon = 0.1;
n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n
    x(j) = sin((6*pi*x1) + (j*pi)/n);
    % odd / số lẻ
    if mod(j,2) == 1


        yj_odd = yj_odd + x(j) - sin((6*pi*x1) + (j*pi)/n);

        hj_odd = 2*yj_odd^2 - cos(4*pi*yj_odd) + 1;

        f1 = x1 + (1/2*N + epsilon) * abs(sin(2*N*pi*x1)) + ((2/abs(j)) * hj_odd);
        % even / số chẵn
    else

        yj_even = yj_even + x(j) - sin((6*pi*x1) + (j*pi)/n);

        hj_even = 2*yj_even^2 - cos(4*pi*yj_even) + 1;

        f2 = 1 - x1 + (1/2*N + epsilon) * abs(sin(2*N*pi*x1)) + ((2/abs(j)) * hj_even);
    end
end



f=[f1
    f2];
ps = x;
end

%% UF6
function [f,ps] = UF6(x)
N = 2;
epsilon = 0.1;
n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n

    x(j) = sin((6*pi*x1) + (j*pi)/n);

        
    % odd / số lẻ
    if mod(j,2) == 1


        yj_odd = yj_odd + x(j) - sin((6*pi*x1) + (j*pi)/n);

        f1 = x1 + max(0,2*(1/2*N + epsilon) * sin(2*N*pi*x1)) + ((2/abs(j)) * (4*yj_odd^2 - 2*prod(cos(20*yj_odd*pi/sqrt(j))) + 2));
        % even / số chẵn
    else

        yj_even = yj_even + x(j) - sin((6*pi*x1) + (j*pi)/n);

        f2 = 1 - x1 + max(0, 2*(1/2*N + epsilon) * sin(2*N*pi*x1)) + ((2/abs(j)) * (4*yj_even^2 - 2*prod(cos(20*yj_even*pi/sqrt(j))) + 2));
    end
end


f=[f1
    f2];
ps = x;
end

%% UF7
function [f,ps] = UF7(x)

n = length(x);
x1 = x(1);
yj_odd = 0;
yj_even = 0;
f1 = 0;
f2 = 0;
for j = 2:n
    x(j) = sin((6*pi*x1) + (j*pi)/n);
    % odd / số lẻ
    if mod(j,2) == 1


        yj_odd = yj_odd + x(j) - sin((6*pi*x1) + (j*pi)/n);

        f1 = x1^(1/5) + ((2/abs(j)) * yj_odd^2);
        % even / số chẵn
    else

        yj_even = yj_even + x(j) - sin((6*pi*x1) + (j*pi)/n);

        f2 = 1 - x1^(1/5) + ((2/abs(j)) * yj_even^2);
    end
end


f=[f1
    f2];
ps = x;
end



%% UF8
function [f,ps] = UF8(x)

n = length(x);
x1 = x(1);
x2 = x(2);
yj1 = 0;
yj2 = 0;
yj3 = 0;
f1 = 0;
f2 = 0;
for j = 3:n
    x(j) = 2*x2*sin((2*pi*x1) + (j*pi)/n);
    if  mod(j - 1, 3) == 0 && j >= 3


        yj1 = yj1 + x(j) - 2*x2*sin((2*pi*x1) + (j*pi)/n);

        f1 = cos(0.5*x1*pi) * cos(0.5*x2*pi) + ((2/abs(j)) * yj1^2);
    end
    if mod(j - 2, 3) == 0 && j >= 3

        yj2 = yj2 + x(j) - 2*x2*sin((2*pi*x1) + (j*pi)/n);

        f2 = cos(0.5*x1*pi) * sin(0.5*x2*pi) + ((2/abs(j)) * yj2^2);
    end
    if mod(j, 3) == 0 && j >= 3
        yj3 = yj3 + x(j) - 2*x2*sin((2*pi*x1) + (j*pi)/n);

        f3 = sin(0.5*x1*pi) + ((2/abs(j)) * yj3^2);
    end
end


f=[f1;f2;f3];
ps = x;
end

%% UF9
function [f,ps] = UF9(x)
epsilon = 0.1;
n = length(x);
x1 = x(1);
x2 = x(2);
yj1 = 0;
yj2 = 0;
yj3 = 0;
f1 = 0;
f2 = 0;
f3 = 0;

for j = 3:n
    x(j) = 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);

    if mod(j - 1, 3) == 0 && j >= 3
        yj1 = yj1 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        f1 = 0.5 * (max(0, (1 + epsilon) * (1 - 4 * (2 * x1 - 1)^2)) + 2 * x1) * x2 + ((2 / abs(j)) * yj1^2);
    end

    if mod(j - 2, 3) == 0 && j >= 3
        yj2 = yj2 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        f2 = 0.5 * (max(0, (1 + epsilon) * (1 - 4 * (2 * x1 - 1)^2)) - 2 * x1 + 2) * x2 + ((2 / abs(j)) * yj2^2);
    end

    if mod(j, 3) == 0 && j >= 3
        yj3 = yj3 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        f3 = 1 - x2 + ((2 / abs(j)) * yj3^2);
    end
end

f = [f1; f2; f3];
ps = x;

end

%% UF10
function [f,ps] = UF10(x)
n = length(x);
x1 = x(1);
x2 = x(2);
yj1 = 0;
yj2 = 0;
yj3 = 0;
f1 = 0;
f2 = 0;
f3 = 0;

for j = 3:n
    x(j) = 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);

    if mod(j - 1, 3) == 0 && j >= 3
        yj1 = yj1 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        
        f1 = cos(0.5*x1*pi) * cos(0.5*x2*pi) ...
            + ((2 / abs(j)) * (4*yj1^2 - cos(8*pi*yj1) + 1));
    end

    if mod(j - 2, 3) == 0 && j >= 3
        yj2 = yj2 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        f2 = cos(0.5*x1*pi)*sin(0.5*x2*pi) ...
            + ((2 / abs(j)) * (4*yj2^2 - cos(8*pi*yj2) + 1));
    end

    if mod(j, 3) == 0 && j >= 3
        yj3 = yj3 + x(j) - 2 * x2 * sin((2 * pi * x1) + (j * pi) / n);
        f3 = sin(0.5*x1*pi)...
            + ((2 / abs(j)) * (4*yj3^2 - cos(8*pi*yj3) + 1));
    end
end

f = [f1; f2; f3];
ps = x;

end


end % end function