#Testing with R


library('DiceKriging')


d=read.table('./stock_daily_charts/PRA.txt')

Xtrain=d$V1
ytrain=d$V2

past=55
n=length(Xtrain)
Xtest=Xtrain[(n+1-past):n]
ytest=ytrain[(n-past+1):n]
Xtrain=Xtrain[1:(n-past)]
ytrain=ytrain[1:(n-past)]
model=km(design=data.frame(x=Xtrain),response=data.frame(y=ytrain),covtype='matern5_2',nugget.estim=T)


#Xtest=seq(min(Xtrain)-1,max(Xtrain)+1,by=1)
#Xtest=max(Xtrain)+5;

p=predict(model,newdata=data.frame(x=Xtest),type='UK')

plot(Xtrain,ytrain,type='l',xlab='date',ylab='price')
lines(Xtest,p$mean,pch=16,col='green')
lines(Xtest,ytest,col='red')
colors=c('black','green','red')
legend('topleft',c('Training Data','GP prediction','Real Value'),lty=1,col=colors)
