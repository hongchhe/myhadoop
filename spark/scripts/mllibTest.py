import json
import sys
import traceback


def getDataFrameFromSource(jsonData):
    """
    """

    columnList = "*"
    if "columns" in jsonData.keys():
        columnList = list(jsonData['columns'].keys())

    if ("sourceType" in jsonData.keys()) and (jsonData["sourceType"] == "hdfs"):
        if ("hdfsUrl" in jsonData.keys()) and jsonData["hdfsUrl"].startswith("hdfs:"):
            url = jsonData["hdfsUrl"]
        else:
            hdfsHost, port, rootFolder = "spark-master0", "9000", "users"
            userName = jsonData["database"]
            tableName = jsonData["tableName"]
            url = "hdfs://{0}:{1}/{2}/{3}/{4}".format(hdfsHost, port, rootFolder, userName, tableName)
        try:
            df1 = spark.read.parquet(url).select(columnList)
        except Exception:
            print("url:{}".format(url))
            traceback.print_exc()
            return False

    else:
        dbSourceDict = jsonData["dbsources"][jsonData["source"]]
        dbType = dbSourceDict["dbtype"]
        dbServer = dbSourceDict["dbserver"]
        dbPort = dbSourceDict["dbport"]
        user = dbSourceDict["user"]
        password = dbSourceDict["password"]

        dbName = jsonData["database"]
        tableName = jsonData["tableName"]

        connUrl = "jdbc:{{0}}://{{1}}:{{2}}".format(dbType, dbServer, dbPort)
        dbTable = "{{0}}.{{1}}".format(dbName, tableName)

        connDbTable = dbTable
        if dbType == "oracle":
            sid = dbSourceDict["sid"]
            connUrl = "jdbc:{{0}}:thin:@{{1}}:{{2}}:{{3}}".format(dbType, dbServer, dbPort, sid)
        elif dbType == "postgresql":
            connUrl = "jdbc:{{0}}://{{1}}".format(dbType, dbServer)
        elif dbType == "sqlserver":
            connUrl = "jdbc:{{0}}://{{1}}:{{2}};databaseName={{3}}".format(dbType, dbServer, dbPort, dbName)
            connDbTable = tableName

        try:
            df1 = spark.read \
                .format("jdbc") \
                .option("url", connUrl) \
                .option("dbtable", connDbTable) \
                .option("user", user) \
                .option("password", password) \
                .load().select(columnList)
        except Exception:
            traceback.print_exc()
            print(sys.exc_info())
            return False
    return df1


def getBasicStats(opTypeList, dataFrame):
    """
    jsonData["opTypes"] opTypeList might include the following value
    "count","sum","mean","median", "min","max","std","var",
    "skew","kurt","quarter1","quarter3"
    pandasDF1 is a pandas data frame
    it will output json data.
    """
    from  pyspark.sql.types import DecimalType, FloatType, NumericType

    availTypeList = [
        "count", "sum", "mean", "median",
        "min", "max", "std", "var",
        "skew", "kurt", "quarter1", "quarter3"
    ]

    columnList = []
    for sItem in dataFrame.schema:
        print(sItem.name, sItem.dataType)
        if isinstance(sItem.dataType, DecimalType):
            columnList.append(dataFrame[sItem.name].cast(FloatType()))
        elif isinstance(sItem.dataType, NumericType):
            columnList.append(dataFrame[sItem.name])

    pandasDF1 = dataFrame.select(columnList).toPandas()

    statsDict = {}
    for typeItem in opTypeList:
        typeItem = typeItem.strip()
        if typeItem not in availTypeList:
            continue

        if "count" == typeItem:
            statsDict["count"] = json.loads(pandasDF1.count().to_json())
        elif "sum" == typeItem:
            statsDict["sum"] = json.loads(pandasDF1.sum().to_json())
        elif "mean" == typeItem:
            statsDict["mean"] = json.loads(pandasDF1.mean().to_json())
        elif "median" == typeItem:
            statsDict["median"] = json.loads(pandasDF1.median().to_json())
        elif "min" == typeItem:
            statsDict["min"] = json.loads(pandasDF1.min().to_json())
        elif "max" == typeItem:
            statsDict["max"] = json.loads(pandasDF1.max().to_json())
        elif "std" == typeItem:
            statsDict["std"] = json.loads(pandasDF1.std().to_json())
        elif "var" == typeItem:
            statsDict["var"] = json.loads(pandasDF1.var().to_json())
        elif "skew" == typeItem:
            statsDict["skew"] = json.loads(pandasDF1.skew().to_json())
        elif "kurt" == typeItem:
            statsDict["kurt"] = json.loads(pandasDF1.kurt().to_json())
        elif "quarter1" == typeItem:
            statsDict["quarter1"] = json.loads(pandasDF1.quantile(0.25, interpolation='midpoint').to_json())
        elif "quarter3" == typeItem:
            statsDict["quarter3"] = json.loads(pandasDF1.quantile(0.75, interpolation='midpoint').to_json())
        else:
            pass
    # pandasDF1.cov()
    # pandasDF1.corr()

    return statsDict


jsonData = {
    "sourceType": "hdfs",
    "opTypes": [
        "count", "sum", "mean", "median",
        "min", "max", "std", "var",
        "skew", "kurt", "quarter1", "quarter3"
    ],
    "database": "myfolder",
    "tableName": "AREA_DICT"
}

df3 = getDataFrameFromSource(jsonData)
if df3:
    json1 = getBasicStats(jsonData["opTypes"], df3)
