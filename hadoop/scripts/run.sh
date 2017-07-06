#!/bin/bash

: ${HDFS_HOST:=localhost}

# split each slave using "\n". For example: lh1 \nlh2 
: ${SLAVE_LIST:=localhost}

# HDFS types: namenode, checkpoint, backup, datanode
: ${HDFS_TYPE:=all}

# YARN types: resourcemanager, nodemanager, webappproxy
: ${YARN_TYPE:=all}

: ${HDFS_REPLICA:=1}
# set if Namenode is HA state.
: ${NN_HA=false}

sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/mapred-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/yarn-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{dfsReplication}}/${HDFS_REPLICA}/"

echo -e ${SLAVE_LIST} > ${HADOOP_CONF_DIR}/slaves

ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> /myvol/authorized_keys
mv $HADOOP_CONF_DIR/ssh_config ~/.ssh/config 

#start ssh service
service ssh start 


ln -sf /myvol/authorized_keys ~/.ssh/authorized_keys

if [ $NN_HA = "true" ]; then
    ${HADOOP_HOME}/scripts/configha.sh;
fi

#start the related-type hdfs
if [ $HDFS_TYPE = "namenode" ]; then
    if [ $NN_HA = "true" ]; then
        # create a znode in ZooKeeper inside of which the automatic failover system stores its data.
        hdfs zkfc -formatZK -nonInteractive;
        hdfs namenode -format -clusterid ${NAMESERVICES} -nonInteractive;
    else
        # format namenode
        hdfs namenode -format;    
    fi

    # start hdfs namenode;
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
elif [ $HDFS_TYPE = "standbynamenode" ]; then
    # ensure that the JournalNodes (as configured by dfs.namenode.shared.edits.dir)
    # contain sufficient edits transactions to be able to start both NameNodes.
    hdfs namenode -bootstrapStandby;
    # start hdfs namenode;
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
elif [ $HDFS_TYPE = "datanode" ]; then
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode;
elif [ $HDFS_TYPE = "journalnode" ]; then
    # start journal node
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start journalnode;
elif [ $HDFS_TYPE = "backup" ]; then
    hdfs namenode -backup;
elif [ $HDFS_TYPE = "checkpoint" ]; then
    hdfs namenode -checkpoint;
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
