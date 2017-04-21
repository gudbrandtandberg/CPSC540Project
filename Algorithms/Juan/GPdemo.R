#Script to see what the GP is doing

source('predictionFunctions.R')

fullData=read.csv('fullDataClosingPrices.csv') #Loads the full data of all stocks
end=dim(fullData)[2]

nStock=15 #this is the number of the stock you want to plot
stock=as.numeric(fullData[nStock,5:end]) #Closing price for the selected stock




####Parameters for the prediction, play around with these in case you want to explore ####

today=75 #Final day where you have data
lookback=75 #How many days in the past you want to use to train your GP
horizon=36 #Number of days into the future you want to predict


#Plotting
plotter(stock,today,lookback,horizon)
