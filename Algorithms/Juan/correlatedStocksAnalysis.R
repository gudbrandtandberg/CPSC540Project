#Script to analyze the correlated stocks

source('predictionFunctions.R')

#indices=read.csv('subset_filter_pca_PC=1_dt=20_t0=1_parallel.csv');indices=as.vector(indices)
#fullData=read.csv('fullDataClosingPrices.csv');fullData=fullData[,-1]
#
#
#corrStocks=fullData[sort(indices[,1]),]
#corrWindow=corrStocks[,6:25]




####Script to analyze the prediction capabilities of the GP per sector




end=dim(fullData)[2]
d=end-5
n=dim(corrWindow)[1]

today=20
lookback=20
maxHorizon=15

successTimes=0 #Measures the ammount of times GP process succesfully predicted up or down
e=Sys.time()
successHist=numeric(maxHorizon)
for (horizon in 1:maxHorizon){
	successTimes=0
	for (j in 1:n){
		stock=as.numeric(corrStocks[j,6:end])
		temp=createData(stock,today,lookback) #Contains Xtrain and ytrain as one vector
		Xtrain=temp[1:today]
		ytrain=temp[(today+1):(2*today)]
		model=GPmodel(Xtrain,ytrain,'exp')

		yhat=predictHorizon(model,today,horizon)

		successTimes=successTimes+testPrediction(stock,today,horizon,yhat)
	}
	successHist[horizon]=successTimes/n
}
f=Sys.time()
print(f-e)
