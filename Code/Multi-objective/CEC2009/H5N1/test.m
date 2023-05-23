clc
clear
close all
%% Get True pareto front
PROBLEMS= ['UF1 '; 'UF2 '; 'UF3 '; 'UF4 '; 'UF5 '; 'UF6 '; 'UF7 '; 'UF8 '; 'UF9 '; 'UF10';];
DIMX    = [30 30 30 30 30 30 30 30 30 30];
NOP     = [100 400 100 100 100 100 100 100 100 100]; 
PROPERTY= ['b-'; 'b-'; 'b-'; 'b-'; 'b.'; 'b.';'b-';'b.';'b.';'b.';];
for p = 1:10
    Name = deblank(PROBLEMS(p,:));
    Archive_no = NOP(p);  % Số lượng phần tử mong muốn
    [x,y]      = xyboundary(Name, Archive_no );
%%
    L = size(x,2);
    CostFunction = str2func(Name);

    switch Name
        case {'UF8','UF9','UF10'}
            nObj = 3;
        otherwise
            nObj = 2;
    end

    k = zeros(1,30);
    no = L*L;
    o = 0;
    for i=1:L
        k(1) = x(i);

        if nObj == 2
            [True_Pareto(i,:), ParetoSet(i,:)] =CostFunction(k);
        else
            for j = 1:L
                o = o + 1 ;
                k(2) = y(j);
                [Z1, Z2] =CostFunction(k);
                True_Pareto(o,:) = Z1;
                ParetoSet(o,:) = Z2;
            end
        end
    end

    figure(p)
    subplot(1,2,1)
    if size(True_Pareto(i,:),2) == 2
        plot(True_Pareto(:,1),True_Pareto(:,2),deblank(PROPERTY(p,:)),LineWidth=1.5)
    else
        plot3(True_Pareto(:,1),True_Pareto(:,2), True_Pareto(:,3),deblank(PROPERTY(p,:)),LineWidth=1.5)
        box on
        ax = gca;
        ax.BoxStyle = 'full';
        ax.LineWidth = 1.5;
        title(Name,Interpreter='latex')
        xlabel('$F1$',Interpreter='latex');
        ylabel('$F2$',Interpreter='latex');
        zlabel('$F3$',Interpreter='latex');
    end
    subplot(1,2,2)
    plot3(ParetoSet(:,1),ParetoSet(:,2),ParetoSet(:,3),deblank(PROPERTY(p,:)),LineWidth=1.5)

    title(Name,Interpreter='latex')
    xlabel('$x1$',Interpreter='latex');
    ylabel('$x2$',Interpreter='latex');
    zlabel('$x3$',Interpreter='latex');

    box on
    ax = gca;
    ax.BoxStyle = 'full';
    ax.LineWidth = 1.5;
    grid off;
%     legend("True PF", "Solution PF", 'Location', 'southwest',Interpreter='latex')
    clear True_Pareto ParetoSet
end

%%
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


%%
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

%%
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

%%
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

%%
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

%%
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

%%
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



%%
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

%%
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

%%
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
