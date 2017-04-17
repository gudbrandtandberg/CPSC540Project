%% SVM regression testing.

%% load data

today = 15;
lookback = 20;
horizon = 5;

[PRICE_HISTORY, FUTURE_PRICE, NAMES, SECTORS] = loadData(today, lookback, horizon);

n = 450;
t = 40;

X = PRICE_HISTORY(1:n,:);
y = FUTURE_PRICE(1:n);

Xtest = PRICE_HISTORY(n+1:n+t,:);
ytest = FUTURE_PRICE(n+1:n+t);

[~, d] = size(X);

%% load data 2
trainTestRatio = .8;

[XX, yy] = loadData2(30, 15);

n = floor(length(yy)*trainTestRatio);
t = length(yy) - n;

X = XX(1:n,:);
Xtest = XX(n+1:n+t,:);
y = yy(1:n);
ytest = yy(n+1:n+t);

%% Matlab SVM model

% model = fitrsvm(X,y,'KernelFunction','gaussian', 'OptimizeHyperparameters', 'all');
% model = fitrsvm(X,y,'KernelFunction','gaussian');
model = fitrsvm(X,y,'KernelFunction','linear');
%% Compute prediction RMS-error

yhat = predict(model, Xtest);
ytrain = predict(model, X);
yRW = Xtest(:,end);

trainMAError = mean(abs(y - ytrain));
fprintf('Training MAError: %.3f\n', trainMAError);

testMAError = mean(abs(yhat - ytest));
fprintf('Test MAError: %.3f\n', testMAError);

RWMAError = mean(abs(yRW - ytest));
fprintf('Random Walk MAError: %.3f\n', RWMAError);


%% Plot test predictions
figure();
hold on;
h = plot(1:t, yhat, 'r*', 1:t, ytest, 'b+', 'MarkerSize', 10);
set(h,'linewidth',2);
legend('Test - Predictions', 'Ground Truth');
for i=1:t 
    h = plot([i i], [yhat(i) ytest(i)], 'k--');
    set(h,'linewidth',2);
end
set(gca, 'FontSize', 16);
plot(ones(1,t));
xlabel('Stock #');
ylabel('Predicted price (rel. to today)');
title({'SVM-Regression Prediction Error', ''});
%%
yrand = sign(randn(t, 1));
s = sign(yhat-1).*sign(ytest-1);
sRW = sign(yrand - 1).*sign(ytest-1);
correctRW = sum(sRW == 1);
correct = sum(s == 1);
fprintf('Up/Down prediction accuracy: %.2f\n', correct / t);
fprintf('Random Walk Up/Down prediction accuracy: %.2f\n', correctRW / t);
%%
figure();
hold on
for i=1:n
    plot(X(i,:));
end

%% compute best lookback for each horizon
today = 1;
lookback = 15;
horizon = 5;
minError = Inf;
bestLookbacks = zeros(1,15);

for horizon = 1:15
    minError = Inf;
    for lookback = 5:5:25
        [PRICE_HISTORY, FUTURE_PRICE, NAMES, SECTORS] = loadData(today, lookback, horizon);
        n = 350;
        t = 100;
        X = PRICE_HISTORY(1:n,:);
        y = FUTURE_PRICE(1:n);
        Xtest = PRICE_HISTORY(n+1:n+t,:);
        ytest = FUTURE_PRICE(n+1:n+t);
        model = fitrsvm(X,y,'KernelFunction','gaussian', 'OptimizeHyperparameters', 'auto', 'Verbose', 0);
        yhat = predict(model, Xtest);
        testMAError = mean(abs(yhat - ytest));
        if testMAError < minError
            bestLookbacks(horizon) = lookback;
            minError = testMAError;
        end
    end
end
load handel;
player = audioplayer(y,Fs);
play(player);

%% compute errors for each prediction and predict into the future!
today = 30;
yfuture = zeros(t, 15);
errors = zeros(1,15);
RWerrors = zeros(1,15);
SVMmodels = cell(15, 1);
for horizon=1:15
    lookback = bestLookbacks(horizon);
    [PRICE_HISTORY, FUTURE_PRICE, NAMES, SECTORS] = loadData(today, lookback, horizon);
    n = 800;
    t = 100;
	X = PRICE_HISTORY(1:n,:);
	y = FUTURE_PRICE(1:n);
	Xtest = PRICE_HISTORY(n+1:n+t,:);
	ytest = FUTURE_PRICE(n+1:n+t);
%     model = fitrsvm(X,y,'KernelFunction','gaussian', 'OptimizeHyperparameters', 'auto', 'Verbose', 0);
    model = fitrsvm(X,y,'KernelFunction','gaussian');    
SVMmodels{horizon} = model;
    yhat = predict(model, Xtest);
    yfuture(:,horizon) = yhat;
	errors(horizon) = mean(abs(yhat - ytest));
    yRW = Xtest(:,end);
	RWerrors(horizon) = mean(abs(yhat - yRW));
end
% play(player);
%%
plot(errors);
hold on; 
plot(RWerrors);
title('SVM Prediction Test Error');
legend('Prediction Errors', 'Random Walk Errors');
xlabel('Prediction Horizon [days]');
ylabel('Mean Absolute Prediction Error [$]');

%% compute errors for each prediction and predict into the future! IIIII
% yfuture = zeros(t, 15);
% yfutureReal = zeros(t, 15);
errors = zeros(1,15);
RWerrors = zeros(1,15);
SVMmodels = cell(15, 1);
trainTestRatio = .8;
for horizon=1:15
    fprintf('Training %d-day prediction model\n', horizon);
    lookback = bestLookbacks(horizon);
    
    [PRICE_HISTORY, FUTURE_PRICE] = loadData2(lookback, horizon);
    
    n = ceil(length(FUTURE_PRICE)*trainTestRatio);
    t = length(FUTURE_PRICE) - n;
	
    X = PRICE_HISTORY(1:n,:);
	y = FUTURE_PRICE(1:n);
    
	Xtest = PRICE_HISTORY(n+1:n+t,:);
	ytest = FUTURE_PRICE(n+1:n+t);
   
%     model = fitrsvm(X,y,'KernelFunction','gaussian', 'OptimizeHyperparameters', 'auto', 'Verbose', 0);
    model = fitrsvm(X,y,'KernelFunction','Linear');    
    
    SVMmodels{horizon} = model;
    
    yhat = predict(model, Xtest);
%     yfuture(:,horizon) = yhat;
%     yfutureReal(:,horizon) = ytest;
	errors(horizon) = mean(abs(yhat - ytest));
    yRW = Xtest(:,end); %ones..
	RWerrors(horizon) = mean(abs(yhat - yRW));
end
play(player);
%%
plot(errors);
hold on; 
plot(RWerrors);
title('SVM Prediction Test Error');
legend('Prediction Errors', 'Random Walk Errors');
xlabel('Prediction Horizon [days]');
ylabel('Mean Absolute Prediction Error [$]');


%% Predict a single stock
i=8;
testStockPred = yfuture(i,:);
[x, ~, ~, ~] = loadData(45, 40, 1);

testStockReal = x(n+i,:);
testStockRealHist = testStockReal(1:25);
testStockRealFut = testStockReal(26:end);
figure;

hold on;
plot(1:25, testStockRealHist, 'k-','LineWidth',2);
plot(26:40, testStockRealFut, 'k--','LineWidth',2);
plot(26:40, testStockPred, 'r--','LineWidth',2);
% plot(1:40, testStockReal);
xlabel('Day #');
ylabel('Stock price');
title('Prediction of a single stock');

Ym = min([testStockRealHist';testStockPred';testStockRealFut']);
YM = max([testStockRealHist';testStockPred';testStockRealFut']);

today = 25;
fill([today today today+15 today+15],[Ym YM YM Ym],'b','FaceAlpha',0.1)

%% Cluster by sector

today = 20;
lookback = 20;
horizon = 5;

[PRICE_HISTORY, FUTURE_PRICE, NAMES, SECTORS] = loadData(today, lookback, horizon);

n = 450;
t = 40;

numSectors = length(unique(SECTORS));
datasets = cell(numSectors, 2);

X = PRICE_HISTORY(1:n,:);
y = FUTURE_PRICE(1:n);
trainSectors = SECTORS(1:n);

Xtest = PRICE_HISTORY(n+1:n+t,:);
ytest = FUTURE_PRICE(n+1:n+t);
testSectors = SECTORS(n+1:n+t);

[trainSectors, I1] = sort(trainSectors);
[testSectors, I2] = sort(testSectors);

X = X(I1,:);
y = y(I1);
Xtest = Xtest(I2,:);
ytest = ytest(I2,:);

% 
% for i=1:numSectors
%     datasets(i,1) = X(SECTORS == SECTORS(i));
% end




% model = fitrsvm(X,y,'KernelFunction','Linear');  
% 
% [~, d] = size(X);

%% Cluster by Cluster

today = 20;
lookback = 20;
horizon = 5;

[PRICE_HISTORY, FUTURE_PRICE, NAMES, SECTORS] = loadData(today, lookback, horizon);

n = 450;
t = 40;

k = 4;
datasets = cell(k, 2);
kmeansModels = cell(k, 1);

X = PRICE_HISTORY(1:n,:);
y = FUTURE_PRICE(1:n);

Xtest = PRICE_HISTORY(n+1:n+t,:);
ytest = FUTURE_PRICE(n+1:n+t);

[Idx, means] = kmeans(X, k);

for i=1:k
    datasets{i,1} = X(Idx == i, :);
    datasets{i,2} = y(Idx == i);
end

for i=1:k
    kmeansModels{i} = fitrsvm(datasets{i,1}, datasets{i,2});
end

% test time
knnModel = KNN(means, 1:4);
knnModel.NumNeighbors = 1;
predictedClusters = predict(knnModel, Xtest);

yhat = zeros(t, 1);
for i=1:t
   yhat(i) = predict(knnModels{predictedClusters(i)}, Xtest(i,:)); 
end



