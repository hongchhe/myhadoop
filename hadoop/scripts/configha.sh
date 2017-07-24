#!/bin/bash

: ${NAMESERVICES:=mycluster}

: ${NN1_HOST:=namenode1}

: ${NN2_HOST:=namenode2}

: ${JN_HOSTS:="jl1:8485;jl2:8485;jl3:8485"}

: ${USER_HOME:="\/root"}

: ${JOURNAL_EDITS_DIR:="\/opt\/hadoop\/journaledits"}

: ${ZK_HOSTS:="zk1:2181,zk2:2181,zk3:2181"}

sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{nameservices}}/${NAMESERVICES}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{nn1Host}}/${NN1_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{nn2Host}}/${NN2_HOST}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{JNHosts}}/${JN_HOSTS}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{journalEditsDir}}/${JOURNAL_EDITS_DIR}/"
sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml.ha -e "s/{{userHome}}/${USER_HOME}/"

sed -i ${HADOOP_CONF_DIR}/core-site.xml.ha -e "s/{{ZKHosts}}/${ZK_HOSTS}/"
sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/${HDFS_HOST}:9000/${NAMESERVICES}/"
sed -i ${HADOOP_CONF_DIR}/core-site.xml.ha -e "s/{{userHome}}/${USER_HOME}/"

sed -i ${HADOOP_CONF_DIR}/core-site.xml -e "s/<\/configuration>//"
cat ${HADOOP_CONF_DIR}/core-site.xml.ha >> ${HADOOP_CONF_DIR}/core-site.xml
echo "</configuration>" >> ${HADOOP_CONF_DIR}/core-site.xml

sed -i ${HADOOP_CONF_DIR}/hdfs-site.xml -e "s/<\/configuration>//"
cat ${HADOOP_CONF_DIR}/hdfs-site.xml.ha >> ${HADOOP_CONF_DIR}/hdfs-site.xml
echo "</configuration>" >> ${HADOOP_CONF_DIR}/hdfs-site.xml

