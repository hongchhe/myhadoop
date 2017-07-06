FROM hongchhe/ubuntu-java7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>


# set environment variable
ENV     HBASE_HOME=/usr/local/hbase
ENV     PATH=$PATH:${HBASE_HOME}/bin:${HBASE_HOME}/sbin 
ENV     HBASE_URL=http://mirrors.hust.edu.cn/apache/hbase/stable
#ENV     HBASE_URL=http://ftp.wayne.edu/apache/hbase/stable
ENV     HBASE_VERSION=1.2.5

#install hbase-1.2.5
RUN     mkdir -p ${HBASE_HOME} \ 
     && wget -q -O - ${HBASE_URL}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xzC ${HBASE_HOME} --strip-components=1

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
