#!/bin/bash

: ${ZK_HOME:=/opt/zookeeper}
: ${ZK_MODE:=standalone}
: ${ZK_SERVER_NAME:=zoo}
: ${ZK_SERVER_NUM:=3}
: ${ZK_SERVER_ID:=1}

cp ${ZK_HOME}/conf/zoo-${ZK_MODE}.cfg ${ZK_HOME}/conf/zoo.cfg

python createServerList.py ${ZK_SERVER_NAME} ${ZK_SERVER_NUM} ${ZK_MODE} >> ${ZK_HOME}/conf/zoo.cfg

echo ${ZK_SERVER_ID} > ${ZK_HOME}/var/data/myid

${ZK_HOME}/bin/zkServer.sh start

tail -f /dev/null
