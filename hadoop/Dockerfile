FROM hongchhe/ubuntu-python3-java
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

# set environment variable
ENV     HADOOP_HOME=/opt/hadoop
ENV     HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV     YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV     PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin 
ENV     HADOOP_VERSION=2.7.4
#ENV     HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV     HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

#install hadoop 2.7.4
RUN     mkdir -p ${HADOOP_HOME} \
     && wget -q -O - http://mirrors.hust.edu.cn/apache/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz | tar -xzC ${HADOOP_HOME} --strip-components=1 

# Hdfs name node ports
EXPOSE  50070 50470 8020 9000
# Hdfs data node ports
EXPOSE  50010 50020 50075 50475
# HDFS journal node ports
EXPOSE  8485 8480
# Hdfs checkpoint/backup/SecondaryNameNode ports
EXPOSE  50090 50100 50105
# Mapred ports
EXPOSE  10020 19888
# YARN Resource Manager webapp.address/webapp.https.address ports
EXPOSE  8088 8090
# YARN Resource Manager ports scheduler/resource-tracker/applications manager interface/admin
EXPOSE  8030 8031 8032 8033
# YARN Node Manager ports  localizer/webapp
EXPOSE  8040 8042

COPY    conf/* $HADOOP_CONF_DIR/
COPY    scripts/ $HADOOP_HOME/scripts

RUN     chmod +x $HADOOP_HOME/scripts/run.sh \
     && sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64:' $HADOOP_CONF_DIR/hadoop-env.sh \
     && sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop/:' $HADOOP_CONF_DIR/hadoop-env.sh \
     && mkdir -p /myvol \
     # allow ssh using root user as a temporary solution. 
     && mv $HADOOP_CONF_DIR/sshd_config /etc/ssh/sshd_config

VOLUME /myvol

WORKDIR $HADOOP_HOME

ENTRYPOINT ["./scripts/run.sh"]

