import sys
import nltk, requests

from bs4 import BeautifulSoup

def main():
    r = requests.get(sys.argv[1])
    soup = BeautifulSoup(r.text, "html.parser")

    # kill all script and style elements
    for script in soup(["script", "style"]):
        script.extract()    # rip it out

    text = soup.get_text()

    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)

    print text.encode('utf-8').strip().replace("\t", " ")

if __name__ == "__main__":
    main()
