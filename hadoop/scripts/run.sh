#!/bin/bash

: ${HDFS_HOST:=localhost}
: ${HDFS_WORK_BASE_DIR:="\/tmp"}
# split each slave using "\n". For example: lh1 \nlh2 
: ${SLAVE_LIST:=localhost}

# HDFS types: namenode, checkpoint, backup, datanode
: ${HDFS_TYPE:=all}

# YARN types: resourcemanager, nodemanager, webappproxy
: ${YARN_TYPE:=all}

: ${HDFS_REPLICA:=1}
# set if Namenode is HA state.
: ${NN_HA=false}
: ${NN_REGISTRATION_IP_HOSTNAME_CHECK=true}

sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/{{hdfsWorkBaseDir}}/${HDFS_WORK_BASE_DIR}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/mapred-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/yarn-site.xml -e "s/{{hdfsHost}}/${HDFS_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{dfsReplication}}/${HDFS_REPLICA}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/{{nnRegistrationIpHostnameCheck}}/${NN_REGISTRATION_IP_HOSTNAME_CHECK}/"

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
        # wait to start all journalnode service
        sleep 20s
        # create a znode in ZooKeeper inside of which the automatic failover system stores its data.
        hdfs zkfc -formatZK -nonInteractive;
        hdfs namenode -format -clusterid ${NAMESERVICES} -nonInteractive;
        # If you manually manage the services on your cluster, you will need to
        # manually start the zkfc daemon on each of the machines that runs a NameNode.
        # You can start the daemon by running:
        hadoop-daemon.sh --script hdfs start zkfc
        
        # start hdfs namenode;
        hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;

        # Since automatic failover has been enabled in the configuration, the start-dfs.sh
        # script will now automatically start a ZKFC daemon on any machine that runs a NameNode.
        # When the ZKFCs start, they will automatically select one of the NameNodes to become active.
        #start-dfs.sh
    else
        # format namenode
        hdfs namenode -format -nonInteractive;
        # start hdfs namenode;
        hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
    fi

elif [ $HDFS_TYPE = "standbynamenode" ]; then
    # wait to start all journalnode service
    sleep 30s
    hdfs namenode -format -nonInteractive;
    # ensure that the JournalNodes (as configured by dfs.namenode.shared.edits.dir)
    # contain sufficient edits transactions to be able to start both NameNodes.

    # BTW, it's unnecessary to configure standbynamenode in the auto-failover HA environment.
    # When the ZKFCs start, they will automatically select one of the NameNodes to become active. 
    hdfs namenode -bootstrapStandby;
    # start hdfs namenode;
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
    hadoop-daemon.sh --script hdfs start zkfc
    #start-dfs.sh
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
    hdfs namenode -format -nonInteractive;
    #start-dfs.sh
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
    hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode;
else
    echo "Do nothing for hdfs service."
fi

#start the related-type yarn service.
if [ $YARN_TYPE = "resourcemanager" ]; then
    yarn-daemon.sh --config $YARN_CONF_DIR  start resourcemanager
elif [ $YARN_TYPE = "nodemanager" ]; then
    yarn-daemons.sh --config $YARN_CONF_DIR  start nodemanager
elif [ $YARN_TYPE = "proxyserver" ]; then
    yarn-daemon.sh --config $YARN_CONF_DIR  start proxyserver
elif [ $YARN_TYPE = "all" ]; then
    start-yarn.sh
else
    echo "Do nothing for yarn service."
fi

tail -f /dev/null
