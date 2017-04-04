function [model] = svRegression(X,y, epsilon)
% Compute sizes
[n,d] = size(X);

% Add bias variable
Z = [ones(n,1) X];

one = zeros((d+1) + n, 1);
one(d+2:d+1+n) = 1;

A = [Z -eye(n, n);
    -Z -eye(n, n);
    zeros(n,d+1) -eye(n,n)];

b = [y+epsilon; -y+epsilon; zeros(n,1)];

x = linprog(one, A, b);
w = x(1:d+1);

model.w = w;
model.predict = @predict;

end

function [yhat] = predict(model,Xhat)
[t,d] = size(Xhat);
Zhat = [ones(t,1) Xhat];
yhat = Zhat*model.w;
end