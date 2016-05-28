
pair.granger.test.glm <- function (y, p)
{
    m <- ncol(y)
    if (m < 2) {
        stop(paste("Error: granger.test needs at least 2 variables"))
    }
    results <- matrix(0, m * (m - 1), 2)
    namelist <- vector(mode = "character", m * (m - 1))
    varnames <- dimnames(y)[[2]]
    k <- 0
    for (i in 1:m) {
        for (j in 1:m) {
            if (i == j) {
                next
            }
            Y <- embed(cbind(y[, i], y[, j]), p + 1)
            X1 <- Y[, -(1:2)]
            X2 <- X1[, ((1:p) * 2) - (1%%2)]
            restricted <- glm.fit(X2, Y[, 1], family=poisson())
            unrestricted <- glm.fit(X1, Y[, 1], family=poisson())
            ssqR <- sum(restricted$residuals^2)
            ssqU <- sum(unrestricted$residuals^2)
            ftest <- ((ssqR - ssqU)/p)/(ssqU/(nrow(Y) - 2 * p -
            1))
            k <- k + 1
            endog.name <- varnames[i]
            exog.name <- varnames[j]
            name <- paste(exog.name, "->", endog.name)
            namelist[k] <- name
            results[k, ] <- c(ftest, 1 - pf(ftest, p, nrow(Y) -
            2 * p - 1))
        }
    }
    rownames(results) <- namelist
    colnames(results) <- c("F-statistic", "p-value")
    return(results)
}


pair.granger.test <- function (y, p)
{
    m <- ncol(y)
    if (m < 2) {
        stop(paste("Error: granger.test needs at least 2 variables"))
    }
    results <- matrix(0, m * (m - 1), 2)
    namelist <- vector(mode = "character", m * (m - 1))
    varnames <- dimnames(y)[[2]]
    k <- 0
    for (i in 1:m) {
        for (j in 1:m) {
            if (i == j) {
                next
            }
            Y <- embed(cbind(y[, i], y[, j]), p + 1)
            X1 <- Y[, -(1:2)]
            X2 <- X1[, ((1:p) * 2) - (1%%2)]
            restricted <- lm(Y[, 1] ~ X2)
            unrestricted <- lm(Y[, 1] ~ X1)
            ssqR <- sum(restricted$resid^2)
            ssqU <- sum(unrestricted$resid^2)
            ftest <- ((ssqR - ssqU)/p)/(ssqU/(nrow(Y) - 2 * p - 
                1))
            k <- k + 1
            endog.name <- varnames[i]
            exog.name <- varnames[j]
            name <- paste(exog.name, "->", endog.name)
            namelist[k] <- name
            results[k, ] <- c(ftest, 1 - pf(ftest, p, nrow(Y) - 
                2 * p - 1))
        }
    }
    rownames(results) <- namelist
    colnames(results) <- c("F-statistic", "p-value")
    return(results)
}



multi.granger.test <- function (y, n, p) 
{
    m <- ncol(y);
    if (m < 2) {
        stop(paste("Error: multi-granger.test needs at least 2 variables"));
    }
    results <- matrix(0, m, 2);
    namelist <- vector(mode = "character", m);
    varnames <- dimnames(y)[[2]];
    
    k <- 0;
    for (i in 1:m) {
        yswap <- cbind(y[,i],y[,-i]);
        Y <- embed(yswap, p + 1);
        X1 <- Y[, -(1:n)];
        X2 <- X1[, ((1:p) * n) - (n-1)];
        restricted <- lm(Y[, 1] ~ X2);
        unrestricted <- lm(Y[, 1] ~ X1);
        ssqR <- sum(restricted$resid^2);
        ssqU <- sum(unrestricted$resid^2);
        ftest <- ((ssqR - ssqU)/p/(n-1))/(ssqU/(nrow(Y) - n*p - 
                1));
            k <- k + 1;
            if(is.null(varnames[i]) || is.na(varnames[i])) {
              varnames[i] = paste("column",i,sep=" ");
            }
            endog.name <- varnames[i];
            exog.name <- "rest";
            name <- paste(exog.name, "->", endog.name);
            namelist[k] <- name;
            results[k, ] <- c(ftest, 1 - pf(ftest, p, nrow(Y) - 
                n * p - 1));
    }
    rownames(results) <- namelist;
    colnames(results) <- c("F-statistic", "p-value");
    return(results);
}

granger.test.plus <- function (y, n, p) 
{
    m <- ncol(y);
    if (m < 2) {
        stop(paste("Error: multi-granger.test needs at least 2 variables"));
    }
    results <- array(0, c(1,2));
    varnames <- dimnames(y)[[1]];
    
    yswap <- cbind(y[,1],y[,-1]);
    Y <- embed(yswap, p + 1);
    X1 <- Y[, -(1:n)];
    X2 <- X1[, ((1:p) * n) - (n-1)];
    restricted <- lm(Y[, 1] ~ X2);
    unrestricted <- lm(Y[, 1] ~ X1);
    ssqR <- sum(restricted$resid^2);
    ssqU <- sum(unrestricted$resid^2);
    ftest <- ((ssqR - ssqU)/p/(n-1))/(ssqU/(nrow(Y) - n*p - 
                1));
    if(is.null(varnames[1]) || is.na(varnames[1])) {
              varnames[1] = "column 1";
            }
    endog.name <- varnames[1];
    exog.name <- "rest";
    name <- paste(exog.name, "->", endog.name);
    results[1,] <- c(ftest, 1 - pf(ftest, p, nrow(Y) - 
                n * p - 1));
    rownames(results) <- c(name);
    colnames(results) <- c("F-statistic", "p-value");
    return(results);
}


