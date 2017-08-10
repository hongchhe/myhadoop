
# coding: utf-8

# In[1]:

sc.master


# In[2]:

# method 1
#jdbc_df = spark.read.format("jdbc")     .option("url", "jdbc:oracle:thin:@oracle11g:1521:xe")     .option("dbtable", "system.test1")     .option("user", "system")     .option("password", "oracle")     .load()
jdbc_df = spark.read \
    .format("jdbc") \
    .option("url", "jdbc:oracle:thin:@oracle11g:1521:xe") \
    .option("dbtable", "system.test1") \
    .option("user", "system") \
    .option("password", "oracle") \
    .load()

# method 2
#from pyspark import SparkContext, SparkConf
#from pyspark.sql import SQLContext
#ORACLE_DRIVER_PATH = "/opt/spark/jars/ojdbc7.jar"
#conf = SparkConf()
# conf.setMaster("local")
# conf.setAppName("Oracle_imp_exp")
#sqlContext = SQLContext(sc)

#ORACLE_CONNECTION_URL ="jdbc:oracle:thin:system/oracle@oracle11g:1521:xe"
# ora_df=spark.read.format('jdbc').options(
#     url=ORACLE_CONNECTION_URL,
#     dbtable="test1",
#     driver="oracle.jdbc.OracleDriver"
#     ).load()


# In[3]:

print jdbc_df.printSchema()
print jdbc_df.show()


# In[4]:

jdbc_df
# convert table or view in the following many ways
jdbc_df.createOrReplaceTempView("viewtest1")
jdbc_df.registerTempTable("tabletest1")
jdbc_df.createGlobalTempView("glviewtest1")
sqlContext.registerDataFrameAsTable(jdbc_df, "registertest1")
spark.sql("SELECT * FROM viewtest1").show()

# In[5]:

# save into hdfs as a parquet file
jdbc_df.write.parquet("hdfs://spark-master0:9000/test/my/test1")

# save into the embed hive warehouse
jdbc_df.write.saveAsTable("test2", "parquet", "overwrite")

# In[7]:

# read a parquet file from hdfs
hdfs_df = spark.read.parquet("hdfs://spark-master0:9000/test/my/test1")

# hdfs_df.registerTempTable("ParquetTable")
# val result = sqlContext.sql("SELECT * from ParquetTable")
# In[8]:

hdfs_df


# In[9]:

print hdfs_df.printSchema()
print hdfs_df.show()


# In[10]:

from os.path import expanduser, join

from pyspark.sql import SparkSession
from pyspark.sql import Row

# warehouse_location points to the default location for managed databases and tables
warehouse_location = 'hdfs://spark-master0:9000/user/hive/spark-warehouse'

spark = SparkSession.builde.appName("Python Spark SQL Hive integration example").config(
    "spark.sql.warehouse.dir", warehouse_location).enableHiveSupport()     .getOrCreate()

# spark is an existing SparkSession
spark.sql("CREATE TABLE IF NOT EXISTS src (key INT, value STRING)")
spark.sql("LOAD DATA LOCAL INPATH 'examples/src/main/resources/kv1.txt' INTO TABLE src")

# Queries are expressed in HiveQL
spark.sql("SELECT * FROM src").show()
