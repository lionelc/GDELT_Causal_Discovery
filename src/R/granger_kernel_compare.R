rm(list=ls())

source("multi_granger_test.R")

countries = c("CHN", "FRA", "RUS", "GBR", "USA", "JPN", "KOR", "DEU", "BRA", "PRK",
             "AFG", "IRN", "IRQ", "SAU", "SYR", "ISR", "PSE", "EUR")


all_countries = c("AGO","EGY","BGD","QAT","NAM","BGR","BOL","GHA","PAK","PAN","JOR","LBR","LBY","VNM","SAF","PRK","TZA","PRT","KHM","SAS","PRY","HKG","SAU","LBN","BFA","CHE","MRT","CPV","HRV","CHL","CHN","KNA","JAM","DJI","GIN","FIN","URY","THA","SYC","NPL","MAR","YEM","PHL","ZAF","NIC","TGO","SYR","MAC","LIE","BRB","MLT","KAZ","COK","SUR","DMA","BEN","NGA","BEL","DEU","LKA","CRB","GBR","MWI","ITA","CMR","ROM","COM","UGA","TKM","WST","TTO","NLD","BMU","TCD","GEO","MNG","MHL","EAF","BLZ","PGS","AFG","BDI","BLR","GRD","GRC","LSO","AFR","MOZ","TJK","HTI","PSE","LCA","IND","LVA","BTN","VCT","MYS","NOR","CZE","TMP","ATG","FJI","HND","MUS","DOM","LUX","ISR","FSM","PER","MDG","IDN","VUT","MKD","CRI","COD","COG","ISL","ETH","NER","COL","BWA","NRU","MDA","STP","ASA","ECU","SHN","SEA","KIR","SEN","MDV","SRB","FRA","LTU","RWA","ZMB","GMB","VAT","GTM","DNK","ZWE","AUS","AUT","VEN","EUR","PLW","KEN","LAO","MEA","WSM","TUR","ALB","OMN","TUV","MMR","BRN","TUN","RUS","MEX","BRA","CIV","GNQ","USA","CAS","SWE","UKR","GNB","SWZ","TON","CAN","GUY","KOR","ERI","SVK","CYP","DZA","SGP","SOM","UZB","CAF","AZE","POL","KWT","WAF","GAB","CYM","EST","ESP","IRQ","SLV","MLI","IRL","IRN","ABW","SLE","BHS","SLB","NZL","MCO","JPN","NMR","KGZ","ARM","ARE","ARG","SDN","BHR","HUN","PNG","CUB")


datasets <- list()
#yearrange <- c("2001") #, "2002", "2003", "2004", "2005")

yearstr <- "2001"

lag <- 2
pthres <- 0.05

bilinks <- list()

stats_names <- c()
stats_counts <- c()
stats_links <- list()

sparse_mean_thres <- 0.8

for(j in 1:(length(countries)-1))
{
    for(k in (j+1):length(countries))
    {
        if(all_countries[j] == countries[k])
            next
        stats_names <- cbind(stats_names, paste(countries[j],"-", countries[k], sep=""))
        stats_names <- cbind(stats_names, paste(countries[k],"-", countries[j], sep=""))
        stats_counts <- cbind(stats_counts, 0)
        stats_counts <- cbind(stats_counts, 0)
        stats_links[[paste(countries[j],"-", countries[k], sep="")]] <- c()
        stats_links[[paste(countries[k],"-", countries[j], sep="")]] <- c()
    }
}

names(stats_counts) <- stats_names

na_count <- 0
sparse_count <- 0
valid_count <- 0
confl_count <- 0
rev_count <- 0
miss_count <- 0

for(i in 1:length(all_countries))
{
	tmpdata <- list()
	tmpdata2 <- list()
	tmpc <- list()
	tmpc2 <- list()
	ind1 <- 1
	ind2 <- 1
    #print(all_countries[i])
	
  	for(j in 1:length(countries))
	{ 
		if(i == j)
			next
        
      
        filestr <- paste("../tsdataall/tsdata/",yearstr, "/", tolower(countries[j]),"-", tolower(all_countries[i]), "-", yearstr, ".csv",sep="")
        if(file.exists(filestr))
        {
            tmpdata[[ind1]] <- read.csv(filestr, header=FALSE, sep=",", stringsAsFactors=FALSE)
            tmpc[[ind1]] <- c(all_countries[i], countries[j])
            ind1 <- ind1+1
        }
	}
    
    if(length(tmpdata) == 0)
    {
        na_count <- na_count+1
        next
    }
    
	tmpbilinks <- list()
	tmpbiind <- 1
	for(j in 1:(length(tmpdata)-1))
	{
        if(j <= 0)
            next
		for(k in (j+1):length(tmpdata))
		{
            if(k > length(tmpdata) || k <= 0)
                next
    
            if( mean(tmpdata[[j]]$V2) <= sparse_mean_thres || mean(tmpdata[[k]]$V2) <= sparse_mean_thres)
            {
                sparse_count <- sparse_count+1
                next
            }
            if(all_countries[i] == tmpc[[j]][2] || all_countries[i] == tmpc[[k]][2])
                next
			gres <- pair.granger.test.glm(cbind(tmpdata[[j]]$V2, tmpdata[[k]]$V2), lag)
            gres2 <- pair.granger.test(cbind(tmpdata[[j]]$V2, tmpdata[[k]]$V2), lag)
            
			if(is.na(gres[1,2]) || is.na(gres[2,2]))
				next
            
            if(as.numeric(gres[1,2]) < as.numeric(pthres) && as.numeric(gres[1,2]) < as.numeric(gres[2,1]))
			{
				tmpbilinks[[tmpbiind]] <- cbind(tmpc[[j]],tmpc[[k]])
				tmpbiind <- tmpbiind+1
                linkname <- paste(tmpc[[j]][2], "-", tmpc[[k]][2], sep="")
                #browser()
                stats_counts[[linkname]] <- stats_counts[[linkname]]+1
                stats_links[[linkname]] <- c(stats_links[[linkname]], all_countries[i])
                if(as.numeric(gres2[1,2]) >= as.numeric(pthres) && as.numeric(gres2[2,1]) >= as.numeric(pthres))
                {
                    confl_count <- confl_count+1
                }
                else if(as.numeric(gres2[1,2]) > as.numeric(gres2[2,1]))
                {
                    rev_count <- rev_count+1
                }
			}
			else if(as.numeric(gres[2,1]) < as.numeric(pthres))
			{
				tmpbilinks[[tmpbiind]] <- cbind(tmpc[[k]],tmpc[[j]])
				tmpbiind <- tmpbiind+1
                linkname <- paste(tmpc[[k]][2], "-", tmpc[[j]][2], sep="")
                stats_counts[[linkname]] <- stats_counts[[linkname]]+1
                stats_links[[linkname]] <- c(stats_links[[linkname]], all_countries[i])
                
                if(as.numeric(gres2[1,2]) >= as.numeric(pthres) && as.numeric(gres2[2,1]) >= as.numeric(pthres))
                {
                    confl_count <- confl_count+1
                }
                else if(as.numeric(gres2[1,2]) < as.numeric(gres2[2,1]))
                {
                    rev_count <- rev_count+1
                }

			}
            else if(as.numeric(gres2[1,2]) < as.numeric(pthres))
            {
                miss_count <- miss_count+1
                #tmpbilinks[[tmpbiind]] <- cbind(tmpc[[j]],tmpc[[k]])
                #tmpbiind <- tmpbiind+1
                linkname <- paste(tmpc[[j]][2], "-", tmpc[[k]][2], sep="")
                print(paste("miss link:", linkname, "|", tmpc[[j]][1], sep=""))
            }
            else if(as.numeric(gres[2,1]) < as.numeric(pthres))
            {
                miss_count <- miss_count+1
                #tmpbilinks[[tmpbiind]] <- cbind(tmpc[[k]],tmpc[[j]])
                #tmpbiind <- tmpbiind+1
                linkname <- paste(tmpc[[k]][2], "-", tmpc[[j]][2], sep="")
                print(paste("miss link:", linkname, "|", tmpc[[j]][1], sep=""))
            }
		}
        valid_count <- valid_count+1
        #print(paste("round 1:", as.character(j), sep=""))
	}	
	bilinks[[all_countries[i]]] <- tmpbilinks
}


#count number of links
count <- 0
for(i in 1:length(all_countries))
{
	count <- count+ length(bilinks[[all_countries[i]]])
	print(paste(all_countries[i], length(bilinks[[all_countries[i]]]), sep=","))
	
}
print(count)
print(na_count)
print(sparse_count)
print(valid_count)
print(confl_count)
print(rev_count)
print(miss_count)

