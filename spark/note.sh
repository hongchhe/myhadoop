#apt-get install python-pip
#wget https://bootstrap.pypa.io/get-pip.py
#python get-pip.py
#pip install numpy scipy
#apt-get install -y ipython ipython-notebook

#start pyshark using ipython
#PYSPARK_DRIVER_PYTHON='ipython' ./bin/pyspark
#source ~/.bash_profile
pyspark

### Prepare Test Data
docker cp data spark0:/opt/spark/
docker cp ~/Downloads/testdata/ml-latest-small spark0:/opt/spark

### Python Examples:

# Pyspark context sc is up and running
sc

# sc master -running locally
sc.master

## Quick Start Example

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


# The follows show two ways getting tables from oracle. As for the dataFrame API, Please refer to 
# http://spark.apache.org/docs/latest/api/python/pyspark.sql.html?highlight=jdbc#pyspark.sql.DataFrame
# 1.
jdbc_df = spark.read \
    .format("jdbc") \
    .option("url", "jdbc:oracle:thin:@oracle11g:1521:xe") \
    .option("dbtable", "system.test1") \
    .option("user", "system") \
    .option("password", "oracle") \
    .load()


# 2. 
from pyspark import SparkContext, SparkConf
from pyspark.sql import SQLContext
ORACLE_DRIVER_PATH = "/opt/spark/jars/ojdbc7.jar"                                             
conf = SparkConf()
conf.setMaster("local")
conf.setAppName("Oracle_imp_exp")
sqlContext = SQLContext(sc)

ORACLE_CONNECTION_URL ="jdbc:oracle:thin:system/oracle@oracle11g:1521:xe"   
ora_df=spark.read.format('jdbc').options(
     url=ORACLE_CONNECTION_URL,
     dbtable="test1",
     driver="oracle.jdbc.OracleDriver"
     ).load() 



jdbc_df.createOrReplaceTempView("viewtest1")
jdbc_df.registerTempTable("tabletest1")
jdbc_df.createGlobalTempView("glviewtest1")
sqlContext.registerDataFrameAsTable(jdbc_df,"registertest1")
spark.sql("SELECT * FROM viewtest1").show()

# save into hdfs as a parquet file
jdbc_df.write.parquet("hdfs://spark-master0:9000/test/my/test1")

# save into the embed hive warehouse
jdbc_df.write.saveAsTable("test2","parquet","overwrite")


linksDf1 = spark.read.option("header", "true").option("mode", "DROPMALFORMED").csv("hdfs://spark-master0:9000/test/data/ml-latest-small/links.csv")
linksDf1 = spark.read.csv("hdfs://spark-master0:9000/test/data/ml-latest-small/links.csv", header=True, mode="DROPMALFORMED")