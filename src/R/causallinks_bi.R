
rm(list=ls())

source("multi_granger_test.R")

countries = c("CHN", "FRA", "RUS", "GBR", "USA", "JPN", "KOR", "DEU", "BRA", "PRK",
             "AFG", "IRN", "IRQ", "SAU", "SYR", "ISR")

datasets <- list()
yearstr <- "2013"

lag <- 3
pthres <- 0.025

bilinks <- list()

for(i in 1:length(countries))
{
	tmpdata <- list()
	tmpdata2 <- list()
	tmpc <- list()
	tmpc2 <- list()
	ind1 <- 1
	ind2 <- 1
    #print(countries[i])
	
	for(j in 1:length(countries))
	{ 
		if(i == j)
			next
		filestr <- paste("../tsdataall/tsdata/",yearstr, "/", tolower(countries[i]), "-", tolower(countries[j]), "-", yearstr, ".csv",sep="")
		
		if(file.exists(filestr))
		{
			tmpdata[[ind1]] <- read.csv(filestr, header=FALSE, sep=",", stringsAsFactors=FALSE)
			tmpc[[ind1]] <- c(countries[i], countries[j])
			ind1 <- ind1+1
		}
		filestr <- paste("../tsdataall/tsdata/",yearstr, "/", tolower(countries[j]),"-", tolower(countries[i]), "-", yearstr, ".csv",sep="")
		if(file.exists(filestr))
		{
			tmpdata2[[ind2]] <- read.csv(filestr, header=FALSE, sep=",", stringsAsFactors=FALSE)
			tmpc2[[ind2]] <- c(countries[j], countries[i])
			ind2 <- ind2+1
		}
	}
	

	tmpbilinks <- list()
	tmpbiind <- 1
	for(j in 1:(length(tmpdata)-1))
	{
		for(k in (j+1):length(tmpdata))
		{
			gres <- pair.granger.test.glm(cbind(tmpdata[[j]]$V2, tmpdata[[k]]$V2), lag)
			if(is.na(gres[1,2]) || is.na(gres[2,2]))
				next
			if(as.numeric(gres[1,2]) < as.numeric(pthres))
			{
				tmpbilinks[[tmpbiind]] <- cbind(tmpc[[j]],tmpc[[k]])
				tmpbiind <- tmpbiind+1
			}
			if(as.numeric(gres[2,1]) < as.numeric(pthres))
			{
				tmpbilinks[[tmpbiind]] <- cbind(tmpc[[k]],tmpc[[j]])
				tmpbiind <- tmpbiind+1
			}
		}
        #print(paste("round 1:", as.character(j), sep=""))
	}	
	bilinks[[countries[i]]] <- tmpbilinks
      tmpbilinks2 <- list()
	tmpbiind2 <- 1
	for(j in 1:(length(tmpdata2)-1))
	{
		for(k in (j+1):length(tmpdata2))
		{
			gres <- pair.granger.test.glm(cbind(tmpdata2[[j]]$V2, tmpdata2[[k]]$V2), lag)
			if(is.na(gres[1,2]) || is.na(gres[2,2]))
				next
				
			#browser()
			if(as.numeric(gres[1,2]) < as.numeric(pthres))
			{
				tmpbilinks2[[tmpbiind2]] <- cbind(tmpc2[[j]],tmpc2[[k]])
				tmpbiind2 <- tmpbiind2+1
			}
			if(as.numeric(gres[2,1]) < as.numeric(pthres))
			{
				tmpbilinks2[[tmpbiind2]] <- cbind(tmpc2[[k]],tmpc2[[j]])
				tmpbiind2 <- tmpbiind2+1
			}
		}
        #print(paste("round 2:", as.character(j), sep=""))
	}	
	bilinks[[paste(countries[i],"2",sep="")]] <- tmpbilinks2
}


#count number of links
count <- 0
for(i in 1:length(countries))
{
	count <- count+ length(bilinks[[countries[i]]])
	count <- count+ length(bilinks[[paste(countries[i], "2", sep="")]])
	print(paste(countries[i], length(bilinks[[countries[i]]]), length(bilinks[[paste(countries[i], "2", sep="")]]), sep=","))
	
	#for(j in 1:length(bilinks[[countries[i]]]))
	#{
	#	print(bilinks[[countries[i]]])
	#}
}
print(count)



