#!/bin/bash

: ${ZK_HOME:=/opt/zookeeper}
: ${ZK_MODE:=standalone}
: ${ZK_SERVER_NAME:=zoo}
: ${ZK_SERVER_NUM:=3}
: ${ZK_SERVER_ID:=1}


ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> /myvol/authorized_keys
mv ${ZK_HOME}/conf/ssh_config ~/.ssh/config

#start ssh service
service ssh start 

ln -sf /myvol/authorized_keys ~/.ssh/authorized_keys


cp ${ZK_HOME}/conf/zoo-${ZK_MODE}.cfg ${ZK_HOME}/conf/zoo.cfg

python createServerList.py ${ZK_SERVER_NAME} ${ZK_SERVER_NUM} ${ZK_MODE} >> ${ZK_HOME}/conf/zoo.cfg

echo ${ZK_SERVER_ID} > ${ZK_HOME}/var/data/myid

${ZK_HOME}/bin/zkServer.sh start

tail -f /dev/null
