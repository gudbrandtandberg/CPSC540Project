#Mini script to test if the theorem holds true in general
library(DiceKriging)

Xtrain=seq(0,0.9*pi,by=0.01*pi)
ytrain=sin(Xtrain)

Xtest=seq(0,3*pi,by=0.01*pi)

model=km(design=data.frame(x=Xtrain),response=data.frame(y=ytrain),covtype='exp',nugget.estim=T)
p=predict(model,newdata=data.frame(x=Xtest),type='UK')

plot(Xtrain,ytrain,pch=16,cex=0.4,xlim=c(0,3*pi))
abline(h=mean(ytrain),col='blue')
lines(Xtest,p$mean,col='red')

