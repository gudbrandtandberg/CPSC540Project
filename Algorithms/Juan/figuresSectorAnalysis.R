#Script to do the plots from sector analysis

full=read.csv('GPallPrediction.csv');full=full[,-1]
sectors=read.csv('sectorAnalysis.csv');sectors=sectors[,-1]

#Merge all data into just one
temp=data.frame(rep('All',length(full)),full)
names(temp)=c('sector','prediction')
names(sectors)=names(temp)
sectorData=rbind(sectors,temp)


sectorType=as.character(unique(factor(sectorData$sector)))
nSectors=length(unique(factor(sectorData$sector)))

#Creating the plots
plot(1,type='n',xlab='Horizon',ylab='Up/Down Success Rate',xlim=c(1,15),ylim=c(0,1),
main='Success Rate Prediction for GPs')
for (s in 1:nSectors){
	aux=subset(sectorData,sector==sectorType[s])
	lines(1:15,aux$prediction,col=s)
}
legend('topright',sectorType,col=1:nSectors,lty=1,cex=0.7)
