%% SVM regression testing.

[X, y, Xtest, ytest] = loadData();
[n, d] = size(X);
[t, d] = size(Xtest);

lambda = 1;

model = SVMRegression(X, y, lambda);

ytrain = model.predict(model, X);
yhat = model.predict(model, Xtest);

trainError = norm(ytrain - y) / n;
fprintf('Training error: %.3f\n', trainError);

testError = norm(yhat - ytest) / n;
fprintf('Test error: %.3f\n', testError);

plot(1:n, yhat, 1:n, ytest);
legend('Predictions', 'Ground Truth');
