#Script that contains all the functions to based all the predictions on
library(DiceKriging)


#Function to create the  training data
createData=function(stock,today,lookback){ 

	#Inputs
	#stock: a vector that contains the full data (504 days) from the stock
	#today: an integer between 0 and 504 that tells in what day you want to cut the data
	#lookback: number of days in the past to lookback based on today
	#horizon: an integer that represent the time to predict; dayToPredict=today+horizon

	#Output
	#Return a 2*lookback vector that contains the x,y-training data
	
	Xtrain=(today-lookback+1):today
	ytrain=stock[(today-lookback+1):today]
	

	return(c(Xtrain,ytrain))
}	







#Function to create the GP model
GPmodel=function(Xtrain,ytrain,kernel){
	#Returns an object of the class KM that trains a gp with KERNEL kernel

	##Inputs
	#Xtrain is a one dimensional vector with the input of the  training data
	#ytrain is a one dimensional vector with the output from the training data
	#kernel is a string with the kernel to use.
	model=km(design=data.frame(x=Xtrain),response=ytrain,covtype=kernel,nugget.estim=T)
	
	return(model)
}


#Function to do the prediction
predictHorizon=function(model,today,horizon){
	
	#Inputs
	#model is an object of the km family with the GP model
	#today is the day number we had our last known value of the stock
	#horizon is how many days into the future we are going to predict

	#Output
	#Returns the GP prediction at time today+horizon

	Xtest=today+horizon	
	p=predict(model,newdata=data.frame(x=Xtest),type='UK')
	
	return(p$mean)
}



#Function that tests if the prediction is good or not
testPrediction=function(stock,today,horizon,yhat){

	#Inputs
	#ytrain is the training data
	#today is the last day where we measure the stock price
	#horizon is how many days into the future we are guessing yhat
	#yhat is the GP prediction
	
	trueState=sign(stock[today+horizon]-stock[today]) 
	predictedState=sign(yhat-stock[today])

	return(as.numeric(trueState==predictedState))
}


#Function that plots what's going on with the GP fit

plotter=function(stock,today,lookback,horizon){

	#Inputs
	#stock is the stock price data you want to plot
	#the other three inputs are explained in the previous functions
	

	#Output
	#A plot of the GP 

	xxx=(today-lookback+1)
	aux=xxx:(today+horizon)
	temp=createData(stock,today,lookback)
	Xtrain=temp[1:lookback]
	ytrain=temp[(lookback+1):(2*lookback)]
	model=GPmodel(Xtrain,ytrain,'exp')
	plot(Xtrain,ytrain,type='l',lty=2,col='black',lwd=2,xlab='Days',ylab='Closing Price',
main='GP prediction',xlim=c(min(Xtrain),max(Xtrain)+horizon))

	Xtest=today:(today+horizon)
	ytest=stock[today:(today+horizon)]
	lines(Xtest,ytest,lty=2,col='blue')
	#Creting the data for the prediction of the GP
	p=predict(model,newdata=data.frame(x=aux),type='UK')
	nn=length(xxx:today)
	lines(xxx:today,p$mean[1:nn],col='green')
	lines(today:(today+horizon),p$mean[nn:(nn+horizon)],col='red')
	
	abline(h=mean(ytrain),col='gray')
	legend('topleft',c('Closing Price','Future Closing Price','GP fit','GP prediction','Mean Closing Price')
,lty=c(2,2,1,1,1),col=c('black','blue','green','red','gray'))
}
