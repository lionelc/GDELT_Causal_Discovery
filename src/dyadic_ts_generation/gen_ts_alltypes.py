import sys, os, os.path

def main():
    if not os.path.exists("tsdatatypes"):
        os.system("mkdir tsdatatypes")

    for yy in range(1998,2014):
        ystr = str(yy)
        os.system("mkdir tsdatatypes\\"+ystr)
        os.system("python loc_ts_gen_alltypes.py "+ystr)           

if __name__ == '__main__':
    main()
