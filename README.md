# Causal Discovery on GDELT data set

This repository provides the source code and papers, which can generate reproducible causal discovery results over GDELT data (gdeltproject.org) as in the papers (accepted by IUCC-2020). All the source codes are made under the terms of [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html). 


## Steps:

### 1. Data preprocessing:

We use python for data preprocessing job with some speed gain, while R is used in causal discovery.

a. Downloading the GDELT data sets as needed (modify the date range when you need a longer period of data. After 2014, the data size increases in a much quicker pace.)

```
python src/preprocess/gdelt_download.py
```

b. Generate time series of dyadic event counts

```
python gen_ts_all.py
```

### 2. Causal Discovery

#### Note: please check and pre-install the R packages needed

#### An exploitative run of PC algorithm

a. generate monthly data for PC algorithm

```
python gen_exploitation_data.py
```

b. exploit all co-initiator and co-reactor networks (run pc_exploitation.R)

#### Misc analysis (including counterfactual, stable links, and Granger causality) 

Under src/R

### 3. Validation using Wikipedia data 

a. make sure there are nltk, bs4 in your local python

b. under src/wikipedia_validation, there are scraper.py that obtains the text data, and other py prorams for calculating sentiment scores (some relying on corpuses from prior research, which are made available via [effectwordnet](https://mpqa.cs.pitt.edu/), [opiion-lexicon-English](https://github.com/jeffreybreen/twitter-sentiment-analysis-tutorial-201107/tree/master/data/opinion-lexicon-English) .
