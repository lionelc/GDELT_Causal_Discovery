library(pcalg)

ctry_str <- "usa,rus,gbr,chn,isr,afg,irn,eur,pak,fra,pse,tur,jpn,irq,deu,can,aus,kor,prk"

exploita_pc <- function (monpc)
{
    suffStat <- list(C=cor(monpc),n=nrow(monpc))
    pc.fit <- pc(suffStat, indepTest=gaussCItest, p=ncol(monpc),alpha=0.005)
    as(pc.fit, "amat")
}

compare_matrix <- function(tt1, tt2)
{
  diff <- 0
  total <- 0
  for (i in 1:nrow(tt1))
  {
	for(j in 1:ncol(tt1))
	{
	   if (tt1[i, j] != tt2[i, j])
	   {
		diff <- diff+1
	   }
	
	   if(tt1[i, j] == 1)
	   {
		total <- total+1
	   }	   
	}
  }

  as.numeric(diff)/as.numeric(total)

}

ctry <- strsplit(ctry_str, ",")


for(i in 1:length(ctry[[1]]))
{
   for(j in 1:2)
   {
      ind <- j-1
      monpc <- read.csv(paste("exploitation_data/", ctry[[1]][i], "_", as.character(ind), "_1998_2007.csv", sep=""), header=TRUE, sep=",")
      tt <- exploita_pc(monpc)  
      #write(tt, file=paste("exploitation_pc/",ctry[[1]][i], "_", as.character(ind) ,sep=""), ncolumns = 18) 
    
       for (k in 1:ncol(monpc))
       {
	    monpc2 <- monpc
            for (l in 1:nrow(monpc2))
	    {
		monpc2[l, k] <- 0
	    }

	    tt2 <- exploita_pc(monpc2)
	    diff <- compare_matrix(tt, tt2)
	    print(paste(ctry[[1]][i], ctry[[1]][k], toString(j), toString(diff), sep=' '))
       }
   }
}



