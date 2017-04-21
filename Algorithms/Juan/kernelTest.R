#Testing with R


library('DiceKriging')


#Data=read.csv('closePrice.csv')
#Data=as.matrix(Data)

#Important data
d=dim(Data)[1]
n=dim(Data)[2]
ndays=d

Xtrain=1:ndays
ytrain=Data[,1]
m=min(ytrain);M=max(ytrain)



###############First plot in the report############################


#jpeg('./figures/GPFitExample.jpg')
#Xtest=seq(1,ndays,by=0.5)
#plot(Xtrain,ytrain,pch=16,cex=0.5,xlab='date(how is measured?',ylab='Closing Price',main='Closing price for Stock XXX')
#model=km(design=data.frame(x=Xtrain),response=data.frame(y=ytrain),covtype='gauss',nugget.estim=T)
#p=predict(model,newdata=data.frame(x=Xtest),type='UK')
#lines(Xtest,p$mean,col='blue')
#legend('topleft',c('Stock Closing Price','GP Interpolation'),pch=c(16,NA),lty=c(NA,1),col=c('black','blue'))
#dev.off()


###########Second plot in the report #############################

#start=100;end=110
#Xtest=Xtrain[start:end]
#ytest=ytrain[start:end]
#Xtrain=Xtrain[-(start:end)]
#ytrain=ytrain[-(start:end)]
#
#model=km(design=data.frame(x=Xtrain),response=data.frame(y=ytrain),covtype='gauss',nugget.estim=T)
#p=predict(model,newdata=data.frame(x=Xtest),type='UK')
#
#plot(Xtrain,ytrain,pch=16,cex=0.5)
#lines(Xtest,ytest,lty=2,col='red')
#lines(Xtest,p$mean,col='blue')

#suc=read.csv('successRate.csv')
#jpeg('./figures/successPlot.jpg')
#plot(suc[,1],suc[,2],pch=16,xlab='Number of Days in the Future Predicted',ylab='Success Rate',
#main='Success Rate for GP Predictions')
#dev.off()

snapshots=5
jpeg('./figures/snapshots.jpg',width=1200,height=1000)
par(mfrow=c(2,3))
for(j in 1:snapshots){
	past=j*30
	Xtest=Xtrain[(d+1-past):d]
	ytest=ytrain[(d-past+1):d]
	Xtrain2=Xtrain[1:(d-past)]
	ytrain2=ytrain[1:(d-past)]
	model=km(design=data.frame(x=Xtrain2),response=data.frame(y=ytrain2),covtype='exp',nugget.estim=T)
	#
	#
	##Xtest=seq(min(Xtrain)-1,max(Xtrain)+1,by=1)
	##Xtest=max(Xtrain)+5;
	#Xtest=seq(1,ndays,length=2*n)
	#
	pp=predict(model,newdata=data.frame(x=Xtrain2),type='UK')
	p=predict(model,newdata=data.frame(x=Xtest),type='UK')
	#
	plot(Xtrain2,ytrain2,pch=16,cex=0.4,xlab='date',ylab='price',xlim=c(1,ndays),ylim=c(m,M))
	lines(Xtest,p$mean,pch=16,col='green')
	lines(Xtrain2,pp$mean,pch=16,col='green')
	lines(Xtest,ytest,col='red',lty=2)
	lines(1:ndays,rep(mean(ytrain2),length(1:ndays)),col='blue')
	#lines(Xtest,p$upper95,lty=3,col=1)
	#lines(Xtest,p$lower95,lty=3,col=1)

}
plot(0,0,xaxt='n',yaxt='n',ann=F,pch=NA)
colors=c('black','green','red','blue')	
legend('topleft',c('Closing Price','GP prediction','Actual Closing Price','Mean Closing Price'),
pch=c(16,NA,NA,NA),lty=c(NA,1,2,1),col=colors,cex=2.8)
dev.off()
