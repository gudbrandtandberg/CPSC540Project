function model = SVMRegression(X, y, epsilon, C, sigma)
% trains a SVM-regression model using dual stochastic coordinate ascent on
% the dual of the epsilon-insensitive loss function. 

[n, d] = size(X);

% Initialize dual variables
L = sparse([eye(n) -eye(n)]);

K = computeKernel(X, sigma);

H = L'*K*L; %not a single nz entry in the Hessian!

f = [(epsilon - y); epsilon + y];

Aeq = ones(1,n)*L;
beq = 0;

lb = zeros(2*n, 1);
ub = C*ones(2*n, 1);

options = optimoptions('quadprog',...
    'Algorithm','interior-point-convex','Display','off');

[z, ~, EXITFLAG] = quadprog(H, f, [], [], Aeq, beq, lb, ub, [], options);

%clamp 'negligible' dual variables to 0.0
zero = 1.0e-6;
z(z<zero) = 0;
w = sum(diag(L*z)*X)';

% compute bias term
tiny = 0.001;
nz = find(z(1:n) < (C-tiny) | z(n+1:end) > 0);
if ~any(nz)
    disp('Error; nz = []');
    b = -epsilon + y(1) - X(1,:)*w; %randomly select 1, FIX
else
   b = max(-epsilon + y(nz) - X(nz,:)*w); 
end

alphas = L*z;
% disp(nnz(alphas));
I = ~any(alphas,2);
alphas(I,:) = [];
% disp(size(alphas));
X(I,:) = [];

model.alphas = alphas;
model.supportVectors = X;
model.sigma = sigma;
model.w = w;
model.b = b;
model.predict = @predict;
end

function [yhat] = predict(model, Xhat)
% yhat = Xhat*model.w + model.b;

numSupVectors = size(model.alphas,1);
n = size(Xhat,1);

yhat = zeros(n,1);
for i=1:n
   for sv = 1:numSupVectors
    yhat(i) = yhat(i) + model.alphas(sv)*kernel(Xhat(i,:),model.supportVectors(sv,:), model.sigma);
   end
end

% yhat = yhat + model.b;
end

function [K] = computeKernel(X, sigma)

% K = X*X';

[n, ~] = size(X);
K = zeros(n, n);

for i=1:n
    for j=1:n
        K(i, j) = exp(-norm(X(i,:) - X(j,:))^2 / sigma);
    end
end

end

function k = kernel(x, y, sigma)    
    k = exp(-norm(x - y)^2 / sigma);
end
