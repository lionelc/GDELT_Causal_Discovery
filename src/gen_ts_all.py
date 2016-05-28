import sys, os, os.path

def main():
    if not os.path.exists("tsdata"):
        os.system("mkdir tsdata")

    for yy in range(1998,2014):
        ystr = str(yy)
        os.system("mkdir tsdata\\"+ystr)
        os.system("python loc_ts_gen_all.py "+ystr)           

if __name__ == '__main__':
    main()
