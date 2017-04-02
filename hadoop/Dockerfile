From ubuntu:16.04
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8

# install openssh-server, openjdk and wget
RUN     apt-get update \
     && apt-get install -y openssh-server openjdk-8-jdk wget ssh rsync

#install hadoop 2.7.3
RUN     wget http://mirrors.hust.edu.cn/apache/hadoop/common/stable/hadoop-2.7.3.tar.gz \
     && tar -xzvf hadoop-2.7.3.tar.gz \
     && mv hadoop-2.7.3 /usr/local/hadoop \
     && rm hadoop-2.7.3.tar.gz

# set environment variable
ENV     JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV     HADOOP_HOME=/usr/local/hadoop 
ENV     PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN     ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
     && chmod 0600 ~/.ssh/authorized_keys

COPY conf/* /usr/local/hadoop/etc/hadoop/

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; start-dfs.sh; bash"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122
