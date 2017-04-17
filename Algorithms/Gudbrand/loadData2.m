function [X, y] = loadData2(lookback, horizon)

load('closing_price_history.mat'); %494 x 484 data matrix

[N, D] = size(prices);

m = floor((D - horizon - 1) / lookback);
n = N*m;
d = lookback;

X = zeros(n, d);
y = zeros(n, 1);

for i=1:m
    X((i-1)*N+1:i*N,:) = prices(:, (i-1)*lookback+1:i*lookback);
    y((i-1)*N+1:i*N,:) = prices(:, i*lookback+horizon);
end

y = y ./ X(:,end);
X = X ./ X(:,end);
end