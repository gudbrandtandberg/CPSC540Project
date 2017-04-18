dd=read.csv('closePrice.csv')
dd=as.matrix(dd)
d=dim(dd)[1]
n=dim(dd)[2]

newData=log(dd[2:d,])-log(dd[1:(d-1),])
#newData=(-dd[1:(d-1),]+dd[2:d,])/dd[1:(d-1),]
aux=which(newData>=2,arr.ind=T)
plotData=newData[,-aux[,2]]

matplot(plotData,type='l')
