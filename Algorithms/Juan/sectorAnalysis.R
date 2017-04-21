#Script to do the sector analysis


source('predictionFunctions.R')

#fullData=read.csv('fullDataClosingPrices.csv')

sectors=as.character(unique(factor(fullData$sector)))
sectors=sort(sectors)
nSectors=length(sectors)

end=dim(fullData)[2]
d=end-5
n=dim(fullData)[1]


today=25
lookback=25
maxHorizon=15

counter=1


for (s in 1:nSectors){
	temp=subset(fullData,sector==sectors[s])
	m=dim(temp)[1]
	for (horizon in 1:maxHorizon){
		successTimes=0
		for (st in 1:m){
			stock=as.numeric(temp[st,5:end])
			tempData=createData(stock,today,lookback)
			Xtrain=tempData[1:today]
			ytrain=tempData[(today+1):(2*today)]
			model=GPmodel(Xtrain,ytrain,'exp')

			yhat=predictHorizon(model,today,horizon)

			successTimes=successTimes+testPrediction(stock,today,horizon,yhat)
		}
		sectorAnalysis[counter,1]=sectors[s]
		sectorAnalysis[counter,2]=successTimes/m
		
		counter=counter+1
	}
}
