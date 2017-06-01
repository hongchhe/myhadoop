#!/bin/bash

: ${HDFS_HOST:=localhost}

# split each slave using "\n". For example: lh1 \nlh2 
: ${SLAVE_LIST:=localhost}

# HDFS types: namenode, checkpoint, backup, datanode
: ${HDFS_TYPE:=all}

# YARN types: resourcemanager, nodemanager, webappproxy
: ${YARN_TYPE:=all}


sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
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

#start the related-type hdfs
if [ $HDFS_TYPE = "namenode" ]; then
	# format namenode
    hdfs namenode -format
	#hdfs namenode;
	hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
elif [ $HDFS_TYPE = "backup" ]; then
    hdfs namenode -backup;
elif [ $HDFS_TYPE = "checkpoint" ]; then
    hdfs namenode -checkpoint;
elif [ $HDFS_TYPE = "datanode" ]; then
    hdfs datanode;
elif [ $HDFS_TYPE = "all" ]; then
    #start hdfs integrated with namenode, secondary namenode, datanode
    start-dfs.sh
else
    echo "Do nothing for hdfs service."
fi

#start the related-type yarn service.
if [ $YARN_TYPE = "resourcemanager" ]; then
	yarn-daemon.sh --config $YARN_CONF_DIR  start resourcemanager
elif [ $YARN_TYPE = "nodemanager" ]; then
	yarn-daemons.sh --config $YARN_CONF_DIR  start nodemanager
elif [ $YARN_TYPE = "nodemanager" ]; then
	yarn-daemon.sh --config $YARN_CONF_DIR  start proxyserver
elif [ $YARN_TYPE = "all" ]; then
	start-yarn.sh
else
	echo "Do nothing for yarn service."
fi

tail -f /dev/null
