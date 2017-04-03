From hongchhe/ubuntu-java7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

# set environment variable
ENV     HADOOP_HOME=/usr/local/hadoop 
ENV     HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV     YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV     PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
ENV     HADOOP_VERSION=2.7.3

#install hadoop 2.7.3
RUN     curl -s http://mirrors.hust.edu.cn/apache/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C /usr/local/ \
     && cd /usr/local \
     && ln -s ./hadoop-${HADOOP_VERSION} hadoop

# Hdfs ports
EXPOSE  50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE  10020 19888
#Yarn ports
EXPOSE  8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE  49707 2122

COPY    conf/* $HADOOP_CONF_DIR/
COPY    run.sh $HADOOP_HOME/

RUN     chmod +x $HADOOP_HOME/run.sh \
     && sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64:' $HADOOP_CONF_DIR/hadoop-env.sh \
     && sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_CONF_DIR/hadoop-env.sh \
# ssh without key
     && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
     && chmod 0600 ~/.ssh/authorized_keys \
     && mv $HADOOP_CONF_DIR/ssh_config ~/.ssh/config 

WORKDIR $HADOOP_HOME

ENTRYPOINT ["./run.sh"]

