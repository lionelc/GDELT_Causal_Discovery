

source("multi_granger_test.R")

testts <- read.csv("../tsdata/2003/kor-prk-2003.csv", sep=",", header=FALSE, stringsAsFactors=FALSE)
testts2 <- read.csv("../tsdata/2003/chn-prk-2003.csv", sep=",", header=FALSE, stringsAsFactors=FALSE)
testts3 <- read.csv("../tsdata/2003/usa-prk-2003.csv", sep=",", header=FALSE, stringsAsFactors=FALSE)

y <- cbind(testts$V2, testts3$V2) #, testts3$V2)

lag <- 2
n <- 2

m <- ncol(y)

varnames <- dimnames(y)[[1]]
    
yswap <- cbind(y[,1],y[,-1])
Y <- embed(yswap, lag + 1)
X1 <- Y[, -(1:n)]
X2 <- X1[, ((1:lag) * n) - (n-1)]
restricted <- glm.fit(X2, Y[, 1], family=poisson())
unrestricted <- glm.fit(X1, Y[, 1], family=poisson())

msreR <- sqrt(sum(restricted$residuals^2)/length(Y[,1]))
msreU <- sqrt(sum(unrestricted$residuals^2)/length(Y[,1]))


count <- 0.0
maeR  <- 0.0
maeU <- 0.0

for(i in 1:length(Y[,1]))
{
    #if(Y[,1][i] != 0)
    #{
        maeR <- maeR+abs(restricted$residuals[i])
        maeU <- maeU+abs(unrestricted$residuals[i])
        count <- count+1.0
        #}
    
}

maeR <- maeR/count
maeU <- maeU/count

