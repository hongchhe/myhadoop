#!/bin/bash

: ${HDFS_HOST:=localhost}

# split each slave using "\n". For example: lh1 \nlh2 
: ${SLAVE_LIST:=localhost}


sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/mapred-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/yarn-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"

echo -e ${SLAVE_LIST} > ${HADOOP_CONF_DIR}/slaves

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> /myvol/authorized_keys
mv $HADOOP_CONF_DIR/ssh_config ~/.ssh/config 

#start ssh service
service ssh start 

#waitting for the id_rsa.pub of all nodes has been added into the /myvol/authorized_keys file
sleep 3

cp /myvol/authorized_keys ~/.ssh/authorized_keys

# format namenode
hdfs namenode -format

#start hdfs
start-dfs.sh

#start yarn
start-yarn.sh

tail -f /dev/null
