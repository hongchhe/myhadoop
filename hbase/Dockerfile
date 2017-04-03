From hongchhe/ubuntu-java7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

#install hbase-1.2.5
RUN     wget -q http://ftp.wayne.edu/apache/hbase/stable/hbase-1.2.5-bin.tar.gz \
     && tar -xzf hbase-1.2.5-bin.tar.gz \
     && mv hbase-1.2.5 /usr/local/hbase \
     && rm -f hbase-1.2.5-bin.tar.gz \
     && cd /usr/local/hbase

# set environment variable
ENV     HBASE_HOME=/usr/local/hbase
ENV     PATH=$PATH:${HBASE_HOME}/bin:${HBASE_HOME}/sbin 

COPY    conf/* ${HBASE_HOME}/conf/
COPY    run.sh ${HBASE_HOME}

RUN     chmod +x ${HBASE_HOME}/run.sh \
     && sed -i '/^# export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64:' ${HBASE_HOME}/conf/hbase-env.sh \
# ssh without key
     && ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
     && chmod 0600 ~/.ssh/authorized_keys \
     && mv ${HBASE_HOME}/conf/ssh_config ~/.ssh/config

EXPOSE  16010 16020 16030

WORKDIR ${HBASE_HOME}

#ENTRYPOINT [ "sh", "-c", "/usr/local/hbase/bin/start-hbase.sh; bash"]
ENTRYPOINT ["./run.sh"]
