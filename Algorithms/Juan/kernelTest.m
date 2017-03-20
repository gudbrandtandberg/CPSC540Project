%Script to test kernels

A=readtable('./stock_daily_charts/AXTA.csv');
Xtrain=linspace(0,10,505)';
%Xtest=10.3;
Xtest=linspace(0,10,500)';


ytrain=table2array(A(:,3));

k=kernelCreator();

%doing the cross validation
p=crossValidation(@k.powExp,Xtrain,ytrain,101,2,0.1,1,1e-8);



%Evaluating the gaussian kernel
% [yhat,conf9]=k.SE(Xtrain,ytrain,Xtest,0.1,10,1e-8);
yhat=k.powExp(Xtrain,ytrain,Xtest,0.2,2,1e-8);


plot(Xtrain,ytrain,'-');
hold on
plot(Xtest,yhat);
%plot(Xtest,conf95(:,1),'+')
%plot(Xtest,conf95(:,2),'+')
