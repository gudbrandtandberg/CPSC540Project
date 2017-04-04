%Function that creates different kernels


function func=kernelCreator()
	%Xtrain is the training set
	%Xtest is the test set

	


	func.SE=@SE;
	func.powExp=@powExp;
	

end

function [yhat,conf95]=SE(Xtrain,ytrain,Xtest,l,A,nugget)
	%Squared Exponential kernel:
	%K(x,x')=exp(-0.5*||x-x'||^2/l^2)
	%l is the length parameter
	
	%yhat gives the mean of the prediction
	%conf95 is a matrix with two columns with the 
	%lower 95 and upper 95 confidence interval
	
	dd=distance(Xtrain,Xtrain);	
	k=dd;
	ks=distance(Xtrain,Xtest);
	kss=distance(Xtest,Xtest);
	%Creating the covariance matrices
	scl=2*l^2;
	K=A*exp(-k/scl)+nugget*eye(size(dd));
	Ks=A*exp(-ks/scl);
	Kss=A*exp(-kss/scl);
	U=chol(K);
	aux=U'\ytrain;
	v=U\aux;

	yhat=Ks'*v;
	yhat;
	%Calculating the confidence intervales
	covariance=Kss-Ks'*inv(K)*Ks;
	diag(covariance);
	temp=sqrt(diag(covariance));
	temp;
	%pause()
	conf95(:,1)=yhat-temp; %lower 95
	conf95(:,2)=yhat+temp;
	
	

end


function yhat=powExp(Xtrain,ytrain,Xtest,l,p,nugget)
	%PowerExponentialKernel: exp(-\|x-x'\|^{p}/l^{2})
	%K(x,x')=min(x,x');

	dd=distance(Xtrain,Xtrain);	
	k=dd;
	ks=distance(Xtrain,Xtest);
	kss=distance(Xtest,Xtest);
	%Creating the covariance matrices
	scl=l^2;
	K=exp(-(k).^(p/2)/scl)+nugget*eye(size(dd));
	Ks=exp(-(ks).^(p/2)/scl);
	Kss=exp(-(kss).^(p/2)/scl);
	U=chol(K);
	aux=U'\ytrain;
	v=U\aux;

	yhat=Ks'*v;
end	

function D=distance(Xtrain,Xtest)	
	%Xtrain, Xtest
	%D(i,j) is the euclidean distance between training point i
	%and test point j
	
	[n,d]=size(Xtrain);
	[t,d]=size(Xtest);

	D=Xtrain.^2*ones(d,t)+ones(n,d)*(Xtest').^2-2*Xtrain*Xtest';
end

	
