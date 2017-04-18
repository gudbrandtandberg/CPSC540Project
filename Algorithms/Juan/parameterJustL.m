%Function to do the parameter optimization

function l=parameterOptimization(kernel,Xtrain,ytrain,Xtest,kernelType)
	%K is a class from kernel creator
	%kernelType is the Kernel to optimze

	%Line of code if the kernel is the square Exponential
	if (kernelType=='SE')
		l0=0.00001;
		[~,~,K,dd]=kernel.SE(Xtrain,ytrain,Xtest,l0,1,1);
		maxiter=100;
		niter=0;
		while 1

			U=chol(K);
			Uinv=inv(U);
			Kinv=Uinv*Uinv';	
			alpha=U\(U'\ytrain);
			temp=alpha*alpha'-Kinv;

			aux=(1/l0^3*dd).*K;

			gradf=0.5*trace(temp*aux);
			h=0.01;	
			lnew=l0+h*gradf;
			gradf	
			lnew
			pause()		
			niter
			if (norm(gradf)<1e-3||niter==maxiter)
				break
			end
				
			niter=niter+1;	
			l0=lnew;
			[~,~,K,~]=kernel.SE(Xtrain,ytrain,Xtest,l0,1,0.1);
		end
	
		l=l0;
	end
end


function D=distance(Xtrain,Xtest)	
	%Xtrain, Xtest
	%D(i,j) is the euclidean distance between training point i
	%and test point j
	
	[n,d]=size(Xtrain);
	[t,d]=size(Xtest);

	D=Xtrain.^2*ones(d,t)+ones(n,d)*(Xtest').^2-2*Xtrain*Xtest';
end
		
