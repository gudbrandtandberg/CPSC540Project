%Script to test kernels
clear all;
close all;


A=readtable('AXTA.csv');
Xtrain=linspace(0,1,505)';
%Xtest=10.3;
Xtest=linspace(0,1,500)';


ytrain=table2array(A(:,3));

k=kernelCreator();

%doing the cross validation
%p=crossValidation(@k.powExp,Xtrain,ytrain,101,2,0.1,1,1e-8);
%p=parameterOptimization(k,Xtrain,ytrain,Xtest,'SE')
%p=parameterJustL(k,Xtrain,ytrain,Xtest,'SE')
p=0.005%;1];
%Evaluating the gaussian kernel
 [yhat,conf9]=k.SE(Xtrain,ytrain,Xtest,p,19.5,0.01);
%yhat=k.powExp(Xtrain,ytrain,Xtest,0.2,2,1e-8);


plot(Xtrain,ytrain,'--');
hold on
plot(Xtest,yhat);
%plot(Xtest,conf95(:,1),'+')
%plot(Xtest,conf95(:,2),'+')
