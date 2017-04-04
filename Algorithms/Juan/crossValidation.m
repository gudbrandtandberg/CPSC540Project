%Script to perform cross validation on a chosen kernel


function param=crossValidation(kernel,X,y,K,numPar,varargin)
	%kernel is an instance from the class kernelCreator
	%K is the number of partitions in the set Xtrain
	%numParam tells over how many parameters we want to optimize

	%Param is the set of parameters to be optimized maximum 2
	
	n=length(X);



	%Choosing the grid where to do the CV
	%Change at convenience
		
	
	%Finding the number of elements per set
	if mod(n,K)==0
		numEl=n/K;
	else
		numEl=floor(n/K); %Number of elements per set
		K=K+1;
	end



	if numPar==2
		counter=0;
		spacingPar1=0.1:0.1:1;
		spacingPar2=0.8:0.1:2;
		aux=length(spacingPar2)*length(spacingPar1);
		E=zeros(aux,numPar+1);%Storing the errors and the values 
		for par1=spacingPar1
			for par2=spacingPar2
				varargin{1,1}=par1;
				varargin{1,2}=par2;
				counter=counter+1;
				e=0;
				for j=1:K
					

					aux=((j-1)*numEl+1):(j*numEl);
					Xtest=X(aux);
					ytest=y(aux);
					Xtrain=X;Xtrain(aux)=[]; %New training set
					ytrain=y;ytrain(aux)=[]; %New training set
					yhat=kernel(Xtrain,ytrain,Xtest,varargin{:});
					%plot(X,y);
					%title(['parameter1= ',num2str(par1),'par2= ',num2str(par2)])
					%hold on
					%plot(Xtest,ytest,'*');
					%plot(Xtest,yhat,'+');
					%hold off
					%drawnow
					e=e+sum(yhat~=ytest)/length(yhat);
				end
				E(counter,:)=[par1,par2,e];
				E(counter,:)
			end
		
		end
	param=E;

end
			
			
				
				
				


	
	

	
