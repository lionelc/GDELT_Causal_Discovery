import sys, os, os.path
from datetime import date, timedelta

#countries = ["CHN", "FRA", "RUS", "GBR", "USA", "JPN", "KOR", "DEU", "BRA", "PRK",
#             "AFG", "IRN", "IRQ", "SAU", "SYR"]

global countries
countries = ["AGO","EGY","BGD","QAT","NAM","BGR","BOL","GHA","PAK","PAN","JOR","LBR","LBY","VNM","SAF","PRK","TZA","PRT","KHM","SAS","PRY","HKG","SAU","LBN","BFA","CHE","MRT","CPV","HRV","CHL","CHN","KNA","JAM","DJI","GIN","FIN","URY","THA","SYC","NPL","MAR","YEM","PHL","ZAF","NIC","TGO","SYR","MAC","LIE","BRB","MLT","KAZ","COK","SUR","DMA","BEN","NGA","BEL","DEU","LKA","CRB","GBR","MWI","ITA","CMR","ROM","COM","UGA","TKM","WST","TTO","NLD","BMU","TCD","GEO","MNG","MHL","EAF","BLZ","PGS","AFG","BDI","BLR","GRD","GRC","LSO","AFR","MOZ","TJK","HTI","PSE","LCA","IND","LVA","BTN","VCT","MYS","NOR","CZE","TMP","ATG","FJI","HND","MUS","DOM","LUX","ISR","FSM","PER","MDG","IDN","VUT","MKD","CRI","COD","COG","ISL","ETH","NER","COL","BWA","NRU","MDA","STP","ASA","ECU","SHN","SEA","KIR","SEN","MDV","SRB","FRA","LTU","RWA","ZMB","GMB","VAT","GTM","DNK","ZWE","AUS","AUT","VEN","EUR","PLW","KEN","LAO","MEA","WSM","TUR","ALB","OMN","TUV","MMR","BRN","TUN","RUS","MEX","BRA","CIV","GNQ","USA","CAS","SWE","UKR","GNB","SWZ","TON","CAN","GUY","KOR","AIA","ERI","SVK","CYP","DZA","SGP","SOM","UZB","CAF","AZE","POL","KWT","WAF","GAB","CYM","EST","ESP","IRQ","SLV","MLI","IRL","IRN","ABW","SLE","BHS","SLB","NZL","MCO","JPN","NMR","KGZ","ARM","ARE","ARG","SDN","BHR","HUN","PNG","CUB"]

global cset 
cset = set(countries)

def parseDate(daystr):
    if daystr == "NA":
        return None
    year = int(daystr[:4])
    mon = int(daystr[4:6])
    day = int(daystr[6:8])
    return date(year, mon, day)

def date2str(dobj):
    return str(dobj.year)+"-"+str(dobj.month)+"-"+str(dobj.day)

def main():

    dateset = dict()
    dateset2 = dict()

    mindate = date(2025, 1,1)
    maxdate = date(1970, 1, 1)

    predir = "tsdata\\"

    fdir = "..\\data\\"+sys.argv[1]+"\\"

    for filename in os.listdir(fdir):
        f = open(fdir+filename, "r")
        line = f.readline()
        
        filedict = dict()

        tmpind = 0
        while line != None and len(line) > 1:
            sp = line.split('\t')
            sp[1] = parseDate(sp[1])
            if sp[1] != None:
                if sp[1] < mindate:
                        mindate = sp[1]
                if sp[1] > maxdate:
                        maxdate = sp[1]
            else:
                line = f.readline()
                continue
            if sp[7] in cset and sp[17] in cset:
                key1 = sp[7].lower()+"-"+sp[17].lower()+"-"+sys.argv[1]   
                if not key1 in filedict.keys():
                    filedict[key1] = dict()      
                if not sp[1] in filedict[key1].keys():
                    filedict[key1][sp[1]] = 1
                else:
                    filedict[key1][sp[1]] += 1
            tmpind += 1
            if tmpind % 100000 == 0:
                print "filename="+filename+" line="+str(tmpind)
            line = f.readline()
        f.close()
    
    timespan = maxdate-mindate

    for filekey in filedict.keys():
        nzcount = 0
        for i in range(timespan.days+1):
            tmpdate = mindate+timedelta(i)
            if tmpdate in filedict[filekey].keys():      	
                nzcount += filedict[filekey][tmpdate]
        if nzcount < 15:
            continue
        
        fw = open("tsdata\\"+sys.argv[1]+"\\"+filekey+".csv", "w")
       
    	for i in range(timespan.days+1):
            tmpdate = mindate+timedelta(i)
            if tmpdate in filedict[filekey].keys():
            	fw.write(date2str(tmpdate)+","+str(filedict[filekey][tmpdate])+"\n")
                nzcount += 1
            else:
                fw.write(date2str(tmpdate)+","+"0"+"\n")
        
        fw.close()
    
            
if __name__ == '__main__':
    main()
