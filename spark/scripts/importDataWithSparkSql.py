'''
Usages:

spark-submit --master spark://spark-master0:7077 importDataWithSparkSql.py -- --dbtype oracle
    --dbserver dbhost --sid sid --username username
    --password password --dbtable tablename --filename filename
'''


def handle_argument():
    '''handle the argument. '''
    import argparse

    description = 'This script is used to import data from db into hdfs using spark sql.'
    epilog = """ """
    parser = argparse.ArgumentParser(prog="importDataWithSparkSql",
                                     description=description,
                                     epilog=epilog,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('--dbtype', nargs='?', default='mysql',
                        choices=['mysql', 'postgresql', 'oracle'],
                        help='The DB type you want to connect. The default is mysql')
    parser.add_argument('--dbserver', nargs='?', default='mysql1',
                        help='The DB server you want to connect. The default is mysql1')
    parser.add_argument('--sid', nargs='?', default='xe',
                        help='The DB server sid/service you want to connect \
                        which is only valid if dbtype is oracle. The default is xe')
    parser.add_argument('--dbtable', nargs='?', default='test',
                        help='The DB table you want to connect. The default is test')

    parser.add_argument('--username', nargs='?', default='root',
                        help='The user name you want to connect. The default is root')
    parser.add_argument('--password', nargs='?', default='password',
                        help='The password you want to connect. The default is password')

    parser.add_argument('--hdfshost', nargs='?', default='hdfs://spark-master0:9000',
                        help='The hdfs host you want to save. The default is hdfs://spark-master0:9000')
    parser.add_argument('--catagory', nargs='?', default='catagory1',
                        help='The catagory name you want to connect. The default is catagory1')
    parser.add_argument('--filename', nargs='?', default='test1',
                        help='The file name you want to save. The default is test1')

    return parser


parser = handle_argument()
args = parser.parse_args()


def importData(args):
    from pyspark.sql import SparkSession

    dbType, dbServer, sid = args.dbtype, args.dbserver, args.sid
    userName, password = args.username, args.password
    dbTable = args.dbtable

    hdfsHost = args.hdfshost
    catagoryName, fileName = args.catagory, args.filename

    connUrl = "jdbc:{0}://{1}:3306".format(dbType, dbServer)
    if dbType == "oracle":
        connUrl = "jdbc:{0}:thin:@{1}:1521:{2}".format(dbType, dbServer, sid)
    elif dbType == "postgresql":
        connUrl = "jdbc:{0}://{1}".format(dbType, dbServer)

    spark = SparkSession.builder \
        .appName("Python Spark SQL basic example") \
        .config("spark.some.config.option", "some-value") \
        .getOrCreate()

    jdbcDF = spark.read \
        .format("jdbc") \
        .option("url", connUrl) \
        .option("dbtable", dbTable) \
        .option("user", userName) \
        .option("password", password) \
        .load()

    # way 2
    # jdbcDf2 = spark.read.jdbc("jdbc:oracle:thin:system/oracle@//oracle11g:1521/xe","test1")
    # jdbcDF3 = spark.read \
    #     .jdbc("jdbc:postgresql:dbserver", "schema.tablename",
    #           properties={"user": "username", "password": "password"})
    # jdbcDf4 = spark.read.jdbc("jdbc:oracle:thin:system/oracle@//oracle11g:1521/xe","test1", \
    #                 properties={"user.timezone":"UTC","serverTimezone":"UTC","useLegacyDatetimeCode":"false","useJDBCCompliantTimezoneShift":"true"})

    # jdbcDF3 = spark.read.jdbc(
    #     "jdbc:postgresql:dbserver", "schema.tablename",
    #     properties={"user": "username", "password": "password"})

    tablePath = "{0}/stages/{1}/{2}".format(hdfsHost, catagoryName, fileName)
    # save into hdfs as a parquet file
    jdbcDF.write.parquet(tablePath)

    # save into the embed hive warehouse
    # jdbcDf.write.saveAsTable("test2","parquet","overwrite")

importData(args)
