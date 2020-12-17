import sys, os


def nextFile(ss):
   y = int(ss[0:4])
   m = int(ss[4:6])
   m += 1
   if m > 12:
       m = 1
       y += 1
   res = str(y)
   if m < 10:
       res += "0"
   res += str(m)
   return res

def main():
    start = "200703"
    end = "201304"

    p = start
    while p != end:
        os.system("wget http://data.gdeltproject.org/events/"+p+".zip")
        os.system("unzip " + p + ".zip")
        p = nextFile(p)
        print p

if __name__ == "__main__":
    main()
