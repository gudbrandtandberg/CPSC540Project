#Script to test the GP predicitons

source('predictionFunctions.R')


####Script to analyze the prediction capabilities of the GP per sector


fullData=read.csv('fullDataClosingPrices.csv')


end=dim(fullData)[2]
d=end-5
n=dim(fullData)[1]

today=25
lookback=25
horizon=1
maxHorizon=15

successTimes=0 #Measures the ammount of times GP process succesfully predicted up or down
e=Sys.time()
successHist=numeric(maxHorizon)
for (k in 1:maxHorizon){
	successTimes=0
	for (j in 1:n){
		stock=as.numeric(fullData[j,5:end])
		temp=createData(stock,today,lookback) #Contains Xtrain and ytrain as one vector
		Xtrain=temp[1:today]
		ytrain=temp[(today+1):(2*today)]
		model=GPmodel(Xtrain,ytrain,'exp')

		yhat=predictHorizon(model,today,k)

		successTimes=successTimes+testPrediction(stock,today,k,yhat)
	}
	successHist[k]=successTimes/n
}
f=Sys.time()
print(f-e)
