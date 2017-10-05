import subprocess
import json
import logging

hdfshost = 'hdfs://192.168.1.22:9000'
master = 'spark://spark-master0:7077'
dbtype, dbserver, sid = 'oracle', '192.168.1.250', 'dbserver'
username, password = 'yzy_inqu', 'yzy'


def setupLogging():

    logpath = '/opt/spark/logs/batchImportData.log'
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    if not logger.handlers:
        loghandler = logging.FileHandler(logpath)
        loghandler.setFormatter(logging.Formatter('%(asctime)s %(levelname)s %(funcName)s %(message)s'))
        logger.addHandler(loghandler)
    return logger


logger = setupLogging()
# tables = ["WAIT_BED_PATS",
#           "RELATIONSHIP_DICT",
#           "QU_MANAGE_QLTY_DEPT",
#           "PAT_VISIT",
#           "PAT_MASTER_INDEX",
#           "PATS_IN_TRANSFERRING",
#           "OUTP_RCPT_FEE_DICT",
#           "OUTP_BILL_ITEMS",
#           "ORDERS_COSTS",
#           "ORDERS",
#           "OPERATION_MASTER",
#           "OPERATION",
#           "MR_FEE_CLASS_DICT",
#           "EQUIP_DOCUMENT",
#           "DEPT_DICT",
#           "DRUG_PRICE_LIST",
#           "CLINIC_TYPE_DICT",
#           "CLINIC_MASTER",
#           "CLINIC_APPOINTS",
#           "CHARGE_TYPE_DICT",
#           "BILL_ITEM_CLASS_DICT",
#           "BED_REC",
#           "AREA_DICT",
#           "INP_BILL_DETAIL"]
#
# for tableName in tables:
#     cmd = 'spark-submit --master {0} /opt/spark/scripts/importDataWithSparkSql.py -- --dbtype {1} --dbserver {2}\
#          --sid {3} --username {4} --password {5} --dbtable {6} --hdfshost {7} --filename {8}'.format(
#         master,
#         dbtype,
#         dbserver,
#         sid,
#         username,
#         password,
#         tableName,
#         hdfshost,
#         tableName)

cmd = 'spark-submit --master {0} /opt/spark/scripts/getSpecTablesWithSparkSql.py -- --dbtype {1} --dbserver {2} --sid {3} \
    --username {4} --password {5} --dbtable {6}'.format(master, dbtype, dbserver, sid, username, password, "ALL_TABLES")

logger.info("{0}\nStarting Command: {1}".format("=" * 30, cmd))
proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
(output, errors) = proc.communicate()
if len(errors) > 0:
    logger.info("Error: {0}".format(errors))
else:
    logger.info("Output Type:{0},Output:{1}".format(type(output), output))
logger.info("End Command: {0}/n{1}".format(cmd, "=" * 30))

outdict = json.loads(output)
seq = 1
for row in outdict["outputs"]:
    dbtable = u'{0}.{1}'.format(row["OWNER"], row["TABLE_NAME"])
    logger.info("dbtable: {0}, TABLESPACE_NAME: {1}, Rows: {2}".format(
        dbtable, row["TABLESPACE_NAME"], row["NUM_ROWS"]))
    cmd = 'spark-submit --master {0} /opt/spark/scripts/importDataWithSparkSql.py -- --dbtype {1} --dbserver {2} --sid {3} \
        --username {4} --password {5} --dbtable {6} --hdfshost {7} --catagory {8} --filename {9}'.format(
        master, dbtype, dbserver, sid, username, password, dbtable, hdfshost,
        row["TABLESPACE_NAME"], row["TABLE_NAME"])
    logger.info("{0}\nStarting Command: {1}".format("=" * 30, cmd))
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, errors) = proc.communicate()
    if len(errors) > 0:
        logger.info("Error: {0}".format(errors))
    else:
        logger.info("Output:{0}".format(output))
    logger.info("End Command: {0}/n{1}table Seq: {2} {1}".format(cmd, "=" * 20, seq))
    seq += 1
