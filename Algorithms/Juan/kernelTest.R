#Testing with R


library('DiceKriging')


Data=read.csv('closePrice.csv')
Data=as.matrix(Data)

#Important data
d=dim(Data)[1]
n=dim(Data)[2]
ndays=d

Xtrain=1:ndays
ytrain=Data[,1]
m=min(ytrain);M=max(ytrain)

#plot(Xtrain,ytrain,type='l')



past=5
Xtest=Xtrain[(d+1-past):d]
ytest=ytrain[(d-past+1):d]
Xtrain=Xtrain[1:(d-past)]
ytrain=ytrain[1:(d-past)]
model=km(design=data.frame(x=Xtrain),response=data.frame(y=ytrain),covtype='gauss',nugget.estim=T)
#
#
##Xtest=seq(min(Xtrain)-1,max(Xtrain)+1,by=1)
##Xtest=max(Xtrain)+5;
#Xtest=seq(1,ndays,length=2*n)
#
pp=predict(model,newdata=data.frame(x=Xtrain),type='UK')
p=predict(model,newdata=data.frame(x=Xtest),type='UK')
#
plot(Xtrain,ytrain,type='l',lty=2,xlab='date',ylab='price',xlim=c(1,ndays),ylim=c(m,M))
lines(Xtest,p$mean,pch=16,col='green')
lines(Xtrain,pp$mean,pch=16,col='green')
lines(Xtest,ytest,col='red',lty=2)
lines(1:ndays,rep(mean(ytrain),length(1:ndays)),col='blue')
lines(Xtest,p$upper95,lty=3,col=1)
lines(Xtest,p$lower95,lty=3,col=1)

#colors=c('black','green','red')
#legend('topleft',c('Training Data','GP prediction','Real Value'),lty=1,col=colors)
