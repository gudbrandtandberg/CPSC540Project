#Script to do the plots 


#Loading the data
allSVM=read.csv('market_ud_svm.csv');allSVM=allSVM[,-1]
allRand=read.csv('market_ud_rnd.csv');allRand=allRand[,-1]
allGP=read.csv('market_ud_gp.csv');allGP=allGP[,-1]
