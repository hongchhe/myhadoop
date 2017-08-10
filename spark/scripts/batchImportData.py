import subprocess

tables = ["WAIT_BED_PATS",
          "RELATIONSHIP_DICT",
          "QU_MANAGE_QLTY_DEPT",
          "PAT_VISIT",
          "PAT_MASTER_INDEX",
          "PATS_IN_TRANSFERRING",
          "OUTP_RCPT_FEE_DICT",
          "OUTP_BILL_ITEMS",
          "ORDERS_COSTS",
          "ORDERS",
          "OPERATION_MASTER",
          "OPERATION",
          "MR_FEE_CLASS_DICT",
          "EQUIP_DOCUMENT",
          "DEPT_DICT",
          "DRUG_PRICE_LIST",
          "CLINIC_TYPE_DICT",
          "CLINIC_MASTER",
          "CLINIC_APPOINTS",
          "CHARGE_TYPE_DICT",
          "BILL_ITEM_CLASS_DICT",
          "BED_REC",
          "AREA_DICT",
          "INP_BILL_DETAIL"]

hdfshost = 'hdfs://192.168.1.22:9000'
master = 'spark://spark-master0:7077'
dbtype, dbserver, sid = 'oracle', '192.168.1.250', 'yzynewdb'
username, password = 'yzy_inqu', 'yzy'

for tableName in tables:
    cmd = 'spark-submit --master {0} /opt/spark/scripts/importDataWithSparkSql.py -- --dbtype {1} --dbserver {2} --sid {3} \
        --username {4} --password {5} --dbtable {6} --hdfshost {7} --filename {8}'.format(
        master,
        dbtype,
        dbserver,
        sid,
        username,
        password,
        tableName,
        hdfshost,
        tableName)

    print "{0}\nStarting Command: {1}".format("=" * 30, cmd)
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    (output, errors) = proc.communicate()
    if len(errors) > 0:
        print "Error: {0}".format(errors)
    else:
        print "Output:{0}".format(output)
    print "End Command: {0}/n{1}".format(cmd, "=" * 30)
