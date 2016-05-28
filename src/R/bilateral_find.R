
library(MSBVAR)

countries = c("CHN", "FRA", "RUS", "GBR", "USA", "JPN", "KOR", "DEU", "BRA", "PRK",
             "AFG", "IRN", "IRQ", "SAU", "SYR")

edges <- list()
eind <- 1

lag <- 3
pthres <- 0.05
yearstr <- "2001"

for(i in 1:(length(countries)-1))
{
	for(j in (i+1):length(countries))
	{
		filestr <- paste("tsdata\\",tolower(countries[i]),tolower(countries[j]), yearstr, ".csv",sep="")
		filestr2 <- paste("tsdata\\",tolower(countries[j]),tolower(countries[i]), yearstr, ".csv",sep="")

		if(file.exists(filestr) && file.exists(filestr2))
		{
			tmpdata <- read.csv(filestr, header=FALSE, sep=",", stringsAsFactors=FALSE)
			tmpdata2 <- read.csv(filestr2, header=FALSE, sep=",", stringsAsFactors=FALSE)
			gres <- granger.test(cbind(tmpdata$V2, tmpdata2$V2), 3)

			if(is.na(gres[1,2]) || is.na(gres[2,2]))
				next

			if(gres[1,2] < pthres || gres[2,2] < pthres)
			{
				if(gres[1,2] < gres[2,2])
					edges[[eind]] <- c(countries[i], countries[j])
				else
					edges[[eind]] <- c(countries[j], countries[i])
				eind <- eind+1
			}		
		}
	}
	print(i)
}

degrees <- list()
for(i in 1:length(countries))
{
	degrees[[countries[i]]] <- c(0,0)
}

for(i in 1:length(edges))
{
	for(j in 1:2)
	{
		degrees[[edges[[i]][j]]][j] <- degrees[[edges[[i]][j]]][j]+1
	}
}