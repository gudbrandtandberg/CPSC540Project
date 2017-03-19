function model = SVMRegression(X, y, lambda)
% trains a SVM-regression model using dual stochastic coordinate ascent on
% the dual of the epsilon-insensitive loss function. 

[n, d] = size(X);

% Initialize dual variables
z = zeros(n,1);

% Some values used by the dual
YX = diag(y)*X;
G = YX*YX';

% Convert from dual to primal variables
dual2primal = @(z)(1/lambda)*(YX'*z);
w = dual2primal(z);

% Evaluate primal objective:
P = sum(max(1-y.*(X*w),0)) + (lambda/2)*(w'*w);
primal = @(w)[sum(max(1-y.*(X*w),0)) + (lambda/2)*(w'*w)];

% Evaluate dual objective:
D = sum(z) - (z'*G*z)/(2*lambda);
dual = @(z)[sum(z) - (z'*G*z)/(2*lambda)];

%optimization parameters
maxit = 100;
I = eye(n);
duality_gap = inf;
tolerance = 0.01;
it = 1;

%iterate
while (duality_gap > tolerance) && it < maxit
    % random dual variable to optimize for
    i = randi(n);
    
    % maximize dual wrt. dual variable z_i (using closed form solution to 
    % D'(z) = 0)
    
    s = 0;
    for j=1:n
        if (j ~= i)
            s = s + G(i, j)*z(j);
        end
    end
    
    z_i = (lambda - s)/G(i,i);
    
    if z_i > 1.0
        z_i = 1.0;
    elseif z_i < 0.0
        z_i = 0.0;
    end
    
    %update coordinates
    z(i) = z_i;
    w = dual2primal(z);
    
    duality_gap = abs(primal(w) - dual(z));
    it = it + 1;
end
if (it == maxit)
    fprintf('Iteration did not converge up to optimality tolerance\n');
end

model.w = w;
model.predict = @predict;
end

function [yhat] = predict(model, Xhat)
yhat = Xhat*model.w-1.0;
end
