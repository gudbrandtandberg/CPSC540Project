%% notes

% How lookback/horizon changes accuracy
% exploratory data analysis
% How does sector affect price movements
% Try a mixture of SVM models? 

%%

SNPIndices = zeros(6356, 1);
otherIndices = [];

for i=1:505
    boolIdx = strcmp(Symbol(i), names);
    if (any(boolIdx))
        SNPIndices = (SNPIndices | boolIdx);
        otherIndices = [otherIndices i];
    end
end

%%
% have names and Sector, Names

newSectors = cell(494, 1);

for i=1:494

    linInd = find(strcmp(Symbol(i), NAMES));
    newSectors{linInd} = Sector{i};
    
end

%% data loading and plotting tests

today = 30;
lookback = 10;
horizon = 2;
[X, y, ~, ~] = loadData(today, lookback, horizon);

plot(today-lookback+1:today, X(1,:));
hold on; 
plot(today+horizon, y(1), 'r*', 'MarkerSize', 12);

%%
%% try some clustering
k = 4;
[idx, means] = kmeans(PRICE_HISTORY, k);

%%
figure();
for i=1:k
    subplot(2, 3, i);
    hold on;
    plot(PRICE_HISTORY(idx == i, :)');
end

%%
figure();
for i=1:k
    subplot(2, 3, i);
    hold on;
    plot(means(i,:));
end

%% 

[X, y] = loadData2(30, 10);
