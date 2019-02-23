import sys
import nltk, requests

from bs4 import BeautifulSoup
from nltk.stem.wordnet import WordNetLemmatizer


def load_set():
    pos_set = set()
    neg_set = set()
    effect_pos = set()
    effect_neg = set()
    f = open("opinion-lexicon-English/negative-words.txt")
    line = f.readline()
    while line != None:
	line = line.strip()
	if len(line) == 0:
	    break
	if line[0] != ";":
	    neg_set.add(line)
	line = f.readline()
    f.close()
    f = open("opinion-lexicon-English/positive-words.txt")
    line = f.readline()
    while line != None:
        line = line.strip()
	if len(line) == 0:
            break
	if len(line) > 1 and line[0] != ";":
            pos_set.add(line)
        line = f.readline()
    f.close()

    f = open("effectwordnet/EffectWordNet.tff")
    line = f.readline()
    while line != None and len(line) > 1:
	sp = line.strip().split("\t")
	subsp = sp[2].split(",")
	for word in subsp:
	    if "_" in word:
		continue
	    if sp[1][0] == "+":
		effect_pos.add(word)
	    elif sp[1][0] == "-":
		effect_neg.add(word)
	line = f.readline()
    f.close()
    #print len(effect_pos)
    #print len(effect_neg)
    return [pos_set,neg_set, effect_pos, effect_neg]

def scrape_text(url_address):
    r = requests.get(url_address)
    soup = BeautifulSoup(r.text, "html.parser")

    # kill all script and style elements
    for script in soup(["script", "style"]):
        script.extract()    # rip it out

    text = soup.get_text()

    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)

    return text.encode('utf-8').strip().replace("\t", " ")

def key_word_score(text, pos_set, neg_set, effect_pos, effect_neg):
    sp = text.split()
    s = 0.0
    pos = 0.0
    neg = 0.0
    epos = 0.0
    eneg = 0.0
    cc = 0.0
    for word in sp:
	try:
	    word = word.encode('utf-8')
	except:
	    continue
	wordl = WordNetLemmatizer().lemmatize(word, 'v')
	if word in pos_set or wordl in pos_set:
	    pos += 0.5
	if word in neg_set or wordl in neg_set:
            neg += 0.25
	if word in effect_pos or wordl in effect_pos:
	    epos += 1.0
	if word in effect_neg or wordl in effect_neg:
	    eneg += 1.0
	cc += 1.0

    #print pos
    #print neg
    print epos
    print eneg
    print (epos+eneg)/cc
    return epos/(epos+eneg)

def main():
    res = load_set()
    pos_set = res[0]
    neg_set = res[1]
    effect_pos = res[2]
    effect_neg = res[3]
    print key_word_score(scrape_text(sys.argv[1]), pos_set, neg_set, effect_pos, effect_neg)

if __name__ == "__main__":
    main()

