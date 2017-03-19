function [X, y, Xtest, ytest] = loadData()

% Loads data
%%
n = 100;
t = 100;
files = dir('MLFINANCE_data/stock_daily_charts');

X = zeros(n, 60);
y = zeros(n, 1);
Xnames = cell(n,1);

Xtest = zeros(n, 60);
ytest = zeros(n, 1);
Xtestnames = cell(n,1);

lookback = 60; %lookback 2 months
horizon = 14; %predict in 2 weeks

j=1;
for i=1:length(files)
f = files(i); 
if f.isdir
    continue;
end
if (strcmp(f.name(end-3:end), '.txt') == 1) && j <= n+t
    stock_data = load(strcat(f.folder, '/', f.name));
    if (size(stock_data,1) > lookback+horizon) % is there enough data?
        price_history = stock_data(1:lookback,2) ./ stock_data(1,2);
        future_price = stock_data(lookback+horizon,2) ./ stock_data(1,2);
        if (j <= n)
            X(j,:) = price_history;
            y(j) = future_price;
            Xnames{j} = f.name;
            j = j + 1;
        else
            Xtest(j-n,:) = price_history;
            ytest(j-n) = future_price;
            Xtestnames{j-n} = f.name;
            j = j + 1;
        end
    end
end
end

% hold on;
% for i=1:100
%     plot(1:lookback, Xtest(i,:));
% end


end


