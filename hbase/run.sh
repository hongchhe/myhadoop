#!/bin/bash

: ${CONF_HBASE:=/usr/local/hbase/conf/hbase-site.xml}

: ${HDFS_HOST:=localhost}

sed -i ${CONF_HBASE} -e "s/{{hdfsHost}}/${HDFS_HOST}/"

#start ssh service
service ssh start

/usr/local/hbase/bin/start-hbase.sh

tail -f /dev/null
#OR 
#sleep infinity
