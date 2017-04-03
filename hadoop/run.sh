#!/bin/bash

# format namenode
hdfs namenode -format

#start ssh service
service ssh start

#start hdfs
start-dfs.sh

tail -f /dev/null
