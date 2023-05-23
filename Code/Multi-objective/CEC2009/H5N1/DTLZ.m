%
% DTLZ.M
%
% Scalable test suite.
%
% f = dtlz(x, M, k, testNo)
%
% Inputs: x      - candidate solutions
%         M      - no. of objectives
%         k      - no. of variables related to G(M)
%         testNo - test problem no.
%
% Output: f      - results (Mx1)
%
% Ref: Deb, K., Thiele, L., Laumanns, M., and Zitzler, E., 2001,
%      'Scalable Test Problems for Evolutionary Multi-Objective
%      Optimization', TIK-Technical Report No. 112, ETH Zurich,
%      Switzerland.
%
% Created by Robin Purshouse, 17-Oct-2001

%
function f = DTLZ(x, M,nVar,NoProb)
k = (nVar-M+1);
% Check for correct number of inputs.
if nargin ~= 4
   error('Four inputs are required.');
end

% Get total number of decision variables and no. of candidates.
[noSols, nVar] = size(x);

% Check for consistency.
if( nVar ~= (M + k -1) )
    error('Input data is inconsistent.');
end

% Could also check that input data is in range [0, 1].

% Set-up the output matrix.
f = NaN * ones(noSols, M);

% Select the correct test problem.
if NoProb == 1
    % Compute 'g' functional.
    if k > 0
        g = 100 * (k + sum( (x(:,M:nVar) - 0.5).^2 - cos(20*pi*(x(:,M:nVar)-0.5)), 2) );
    else
        g = 0;
    end
    % Compute the objectives.
    f(:,1) = 0.5 * prod( x(:,1:M-1), 2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = 0.5 * prod( x(:,1:M-fNo), 2) .* (1 - x(:,M-fNo+1)) .* (1 + g);
    end
    f(:,M) = 0.5 * (1 - x(:,1)) .* (1+g);
    
    
elseif NoProb == 2
    if k > 0
        g = sum( (x(:,M:nVar) - 0.5).^2 ,2);
    else
        g = 0;
    end
    f(:,1) = prod( cos(x(:,1:M-1)*pi/2) ,2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = prod( cos(x(:,1:M-fNo)*pi/2) ,2) .* sin( x(:,M-fNo+1)*pi/2 ) .* (1 + g);
    end
    f(:,M) = sin( x(:,1)*pi/2 ) .* (1 + g);
elseif NoProb == 3
    if k > 0
        g = 100 * (k + sum( (x(:,M:nVar) - 0.5).^2 - cos(20*pi*(x(:,M:nVar)-0.5)), 2) );
    else
        g = 0;
    end
    f(:,1) = prod( cos(x(:,1:M-1)*pi/2) ,2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = prod( cos(x(:,1:M-fNo)*pi/2) ,2) .* sin( x(:,M-fNo+1)*pi/2 ) .* (1 + g);
    end
    f(:,M) = sin( x(:,1)*pi/2 ) .* (1 + g);
elseif NoProb == 4
    if k > 0
        g = sum( (x(:,M:nVar) - 0.5).^2 ,2);
    else
        g = 0;
    end
    % Compute meta-variables.
    xm = x.^100;
    f(:,1) = prod( cos(xm(:,1:M-1)*pi/2) ,2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = prod( cos(xm(:,1:M-fNo)*pi/2) ,2) .* sin( xm(:,M-fNo+1)*pi/2 ) .* (1 + g);
    end
    f(:,M) = sin( xm(:,1)*pi/2 ) .* (1 + g);
elseif NoProb == 5
    if k > 0
        g = sum( (x(:,M:nVar) - 0.5).^2 ,2);
    else
        g = 0;
    end
    % Compute meta-variables.
    xm = [x(:,1)*pi/2, rep(pi ./ (4 * (1+g)), [1, M-2]) .* (1 + 2*rep(g, [1, M-2]).*x(:,2:M-1))];
    f(:,1) = prod( cos(xm(:,1:M-1)) ,2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = prod( cos(xm(:,1:M-fNo)) ,2) .* sin(xm(:,M-fNo+1)) .* (1 + g);
    end
    f(:,M) = sin( xm(:,1)) .* (1 + g);
    
elseif NoProb == 6
    if k > 0
        g = sum( x(:,M:nVar).^(0.1) ,2);
    else
        g = 0;
    end
    % Compute meta-variables.
    xm = [x(:,1)*pi/2, rep(pi ./ (4 * (1+g)), [1, M-2]) .* (1 + 2*rep(g, [1, M-2]).*x(:,2:M-1))];
    f(:,1) = prod( cos(xm(:,1:M-1)) ,2) .* (1 + g);
    for fNo = 2:M-1
        f(:,fNo) = prod( cos(xm(:,1:M-fNo)) ,2) .* sin(xm(:,M-fNo+1)) .* (1 + g);
    end
    f(:,M) = sin( xm(:,1)) .* (1 + g);
    
    
elseif NoProb == 7
    if k > 0
        g = 1 + (9 / k) * sum( x(:,M:nVar), 2);
    else
        g = 0;
    end
    f(:,1:M-1) = x(:,1:M-1);
    % Compute 'h' functional.
    S = 0;
    for i = 1:M-1
    S = S + (f(:,i)/(1 + g)) * (1 + sin(3*pi*f(:,i)));
    end

    h = M - S;
    f(:,M) = (1+g) .* h;
    
end
f = f';
end