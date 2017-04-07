#!/bin/bash

: ${HBASE_HOME:=/usr/local/hbase}

: ${HBASE_MODE:=standalone}

: ${HDFS_HOST:=localhost}

cp ${HBASE_HOME}/conf/hbase-site-${HBASE_MODE}.xml ${HBASE_HOME}/conf/hbase-site.xml

sed -i ${HBASE_HOME}/conf/hbase-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"

#start ssh service
service ssh start

/usr/local/hbase/bin/start-hbase.sh

tail -f /dev/null
#OR 
#sleep infinity
