apt-get update
apt-get install -y openssh-server openjdk-8-jdk wget
wget http://mirrors.hust.edu.cn/apache/hadoop/common/stable/hadoop-2.7.3.tar.gz
tar -xzvf hadoop-2.7.3.tar.gz
mv hadoop-2.7.3 /usr/local/hadoop
rm hadoop-2.7.3.tar.gz


bin/hdfs namenode -format
sbin/start-dfs.sh

