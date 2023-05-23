%_________________________________________________________________________________
%  MH5N1 algorithm source codes version 1.0
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

function Positions = initialization(nPop, dim, ub, lb)

Boundary_no = size(ub, 1); % number of boundaries

% If the boundaries of all variables are equal and the user enters a single number for both ub and lb
if Boundary_no == 1
    Positions = rand(nPop, dim) .* (ub - lb) + lb;
end

% If each variable has a different lb and ub
if Boundary_no > 1
    Positions = zeros(nPop, dim);
    for i = 1:dim
        ub_i = ub(i);
        lb_i = lb(i);
        Positions(:, i) = rand(nPop, 1) .* (ub_i - lb_i) + lb_i;
    end
end
