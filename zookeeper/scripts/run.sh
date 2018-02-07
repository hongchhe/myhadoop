#!/bin/bash

: ${ZK_HOME:=/opt/zookeeper}
: ${ZK_MODE:=standalone}
: ${ZK_SERVER_NAME:=zoo}
: ${ZK_SERVER_NUM:=3}
: ${ZK_SERVER_ID:=1}

cp ${ZK_HOME}/conf/zoo-${ZK_MODE}.cfg ${ZK_HOME}/conf/zoo.cfg

python createServerList.py ${ZK_SERVER_NAME} ${ZK_SERVER_NUM} --zkMode ${ZK_MODE} \
    --serviceName ${ZK_SERVICE_NAME} >> ${ZK_HOME}/conf/zoo.cfg

serverId=`hostname | egrep -o '[0-9]*$'`
if [[ ${serverId} != "" && ${ZK_SERVER_ID} = "1" ]] ;then
  ZK_SERVER_ID=${serverId}
fi

if [ ${ZK_MODE} = "replicated" ]; then
  sed -i ${ZK_HOME}/conf/zoo.cfg -e "s/{{SERVER_ID}}/${ZK_SERVER_ID}/g"
  mkdir -p ${ZK_HOME}/var/data-${ZK_SERVER_ID}
  echo ${ZK_SERVER_ID} > ${ZK_HOME}/var/data-${ZK_SERVER_ID}/myid
else
  echo ${ZK_SERVER_ID} > ${ZK_HOME}/var/data/myid
fi

${ZK_HOME}/bin/zkServer.sh start

tail -f /dev/null
