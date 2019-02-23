import sys
import datetime

def str2date(s):
    y = int(s[0:4])
    m = int(s[4:6])
    d = int(s[6:8])
    return datetime.date(y, m, d)

def main():
    f = open(sys.argv[1], "r")
    line = f.readline()
    line = f.readline()
    count = 0
    dd = str2date(sys.argv[2])
    while line != None and len(line) > 1:
        tmpd = str2date(line.split()[0].strip())
        if tmpd == dd:
            count += 1
        elif tmpd > dd:
            break
        line = f.readline()
    f.close()
    print count

if __name__ == "__main__":
    main()
