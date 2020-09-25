library(pcalg)
library(Rgraphviz)

ctry_str <- "usa,rus,gbr,chn,isr,afg,irn,eur,pak,fra,pse,tur,jpn,irq,deu,can,aus,kor,prk"


exploita_pc_raw <- function (monpc)
{
    suffStat <- list(C=cor(monpc),n=nrow(monpc))
    pc.fit <- pc(suffStat, indepTest=gaussCItest, p=ncol(monpc),alpha=0.005)
    #as(pc.fit, "amat")
    pc.fit
}


ind <- 1
cc <- "usa"

monpc <- read.csv(paste("exploitation_data/", cc, "_", as.character(ind), "_1998_2007.csv", sep=""), header=TRUE, sep=",")


tt <- exploita_pc_raw(monpc)

       for (k in 1:ncol(monpc))
       {
            monpc2 <- monpc
            for (l in 1:nrow(monpc2))
            {
                monpc2[l, k] <- 0
            }

            tt2 <- exploita_pc_raw(monpc2)
            diff <- compare_matrix(as(tt, "amat"), as(tt2, "amat"))
            print(paste(cc, ctry[[1]][k], toString(j), toString(diff), sep=' '))

	    if (ctry[[1]][k] == "rus")
	    {
		break
	    }
       }


