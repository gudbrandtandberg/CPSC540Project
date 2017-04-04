function [X, y, names] = loadData(day1, lookback, horizon)
% uncomment top to read the actual files and extract the data.
% uncomment bottom to load the mat files from memoty (much faster)

%[prices, names] = readFiles();
% save('closing_price_history', 'prices');
% save('closing_price_history_names', 'names');

load('closing_price_history.mat');
load('closing_price_history_names');

[n, d] = size(prices);

X = prices(:, day1:day1+lookback-1) ./ prices(:, day1);
y = prices(:, day1 + lookback + horizon) ./ prices(:, day1);


%stats: global t1 = 736034, global td = 736034 + 484
% TODO: turn these into gregorian calendar dates!
end

function [price_history, names] = readFiles()
%%
files = dir('../../MLFINANCE_data/stock_daily_charts'); %set path here
% format: days, o, h, l, c, v

n = 6393; %enough space
d = 484;
price_history = zeros(n, d);
names = cell(n,1);

j=1;
for i=1:length(files);
f = files(i); 
if f.isdir
    continue;
end
if (strcmp(f.name(end-3:end), '.txt') == 1)
    
    stock_data = load(strcat(f.folder, '/', f.name));
    
    if (size(stock_data,1) < d) % we need consecutive days in our data
        continue
    end
    if (stock_data(1,1) ~= 736034) %start on the right day? FIX!
        continue;
    end
    
    price_history(j,:) = stock_data(1:d,5);
    names{j} = f.name(1:end-2);
    j = j + 1;
end
end
I = find(~any(price_history,2));
price_history(~any(price_history,2),:) = [];
names(I) = [];
price_history(4681,:) = []; %outli<er!
names(4681) = [];
end

