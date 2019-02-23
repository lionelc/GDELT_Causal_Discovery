import sys

ctrys = "United_States,Russia,United_Kingdom,China,Israel,Afghanistan,Iran,European_Union,Pakistan,France,Palestine,Turkey,Japan,Iraq,Germany,Canada,Australia,South_Korea,North_Korea"

cmarks = "usa,rus,gbr,chn,isr,afg,irn,eur,pak,fra,pse,tur,jpn,irq,deu,can,aus,kor,prk"

def main():
    f= open(sys.argv[1])
    cc = ctrys.split(",")
    cm = cmarks.split(",")
   
    d = dict()
    ar = []
    for i in xrange(len(cc)-1):
	for j in xrange(i+1, len(cc)):
	    line = f.readline().strip()
	    params = line[(len(cc[i])+len(cc[j])+1):]
	    #print cm[i]+","+cm[j]+","+params
	    if len(params) > 0:
	        nums = [float(elem) for elem in params.split(",")]
		key = cm[i]+"-"+cm[j]
		if cm[i] > cm[j]:
		    key = cm[j]+"-"+cm[i]
		d[key] = [nums[2]+nums[3], nums[-2], nums[-1]]
	        ar.append([cm[i]+"-"+cm[j], nums[2]+nums[3], nums[-2], nums[-1]])
    f.close()

    print len(d)
    ar = sorted(ar, key=lambda x:x[1])
    arsum1 = 0.0
    arsum2 = 0.0
    arsum3 = 0.0

    for elem in ar:
    	arsum1 += elem[1]
	arsum2 += elem[2]
	arsum3 += elem[3]

    tt = 0.0
    imps = set()
    f = open(sys.argv[2])
    line = f.readline()
    while line != None and len(line) > 1:
	sp = line.strip().split("-")
	key = sp[0]+"-"+sp[1]
	if sp[1] < sp[0]:
	    key = sp[1]+"-"+sp[0]
	imps.add(key)
	line = f.readline()
    f.close()

    print len(imps)
    avg1 = 0.0
    avg2 = 0.0
    avg3 = 0.0
    ind = 0
    for elem in imps:
	if elem in d:
	    avg1 += d[elem][0]
	    avg2 += d[elem][1]
	    avg3 += d[elem][2]
	    ind += 1
	else:
	    print elem+" not in dict"

    print arsum1/float(len(ar))
    print arsum2/float(len(ar))
    print arsum3/float(len(ar))
    print avg1/float(ind)
    print avg2/float(ind)
    print avg3/float(ind)

if __name__ == "__main__":
    main()
