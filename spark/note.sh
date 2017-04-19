#apt-get install python-pip
#wget https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
#pip install numpy scipy
#apt-get install -y ipython ipython-notebook

#start pyshark using ipython
PYSPARK_DRIVER_PYTHON='ipython' ./bin/pyspark

### Prepare Test Data
sudo docker cp data sp1:/opt/spark/

### Python Examples:

# Pyspark context sc is up and running
sc

# sc master -running locally
sc.master

# read input file
f_in = sc.textFile("/opt/spark/data/clickstream/clickstream.csv")
# count lines
f_in.count()

f_in.first()
f_in.map(lambda s: len(s)).reduce(add)

# Get words from the input file.
words = f_in.flatMap(lambda line: re.split('\W', line.lower().strip()))
# words of more than 3 characters
words = words.filter(lambda x: len(x) > 3)
# set count 1 per word
words = words.map(lambda w: (w,1))
# reduce phase - sum count all the words
words = words.reduceByKey(add)
# create tuple (count,word) and sort in descending
words = words.map(lambda x:(x[1],x[0])).sortByKey(False)
# reduce phase - sum count all the words
words = words.reduceByKey(add)
# take top 3 words by frequency
words.take(3)

