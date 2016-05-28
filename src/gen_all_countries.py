import sys, re

def main():
    #probe to find all countries
    cset = dict()

    f = open(sys.argv[1], "r")

    line = f.readline()
 
    while line != None and len(line) > 1:
        sp = line.split("\t")

        tmp = sp[7].strip()
        if re.match("^[A-Z]*$", tmp):
            if not tmp in cset:
                cset[tmp] = 0
            cset[tmp] += 1
        tmp = sp[17].strip()
        if re.match("^[A-Z]*$", tmp):
            if not tmp in cset:
                cset[tmp] = 0
            cset[tmp] += 1
        line = f.readline()

    fw = open(sys.argv[2], "w")

    fw.write("[")
    print "countries size="+str(len(cset))
    for key in cset:
        if cset[key] >= 80:
            fw.write("\""+key+"\",")
    fw.write(",\"\"]\n")

if __name__ == "__main__":
    main()
