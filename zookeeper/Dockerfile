FROM       hongchhe/ubuntu-python-java
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

ARG        ZK_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/
ARG        ZK_VERSION=3.4.10

LABEL      name="zookeeper" version=$VERSION

# set environment variable
ENV        ZK_HOME=/opt/zookeeper
ENV        PATH=$PATH:${ZK_HOME}/bin:${ZK_HOME}/sbin 

RUN        mkdir -p ${ZK_HOME} \
        && wget -q -O - ${ZK_URL}/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz \
           | tar -xzC ${ZK_HOME} --strip-components=1

COPY       conf/* ${ZK_HOME}/conf/
COPY       scripts/* ${ZK_HOME}/

RUN        chmod +x ${ZK_HOME}/run.sh \
        && mkdir -p ${ZK_HOME}/var/data \
        && mkdir -p /myvol \
           # allow ssh using root user as a temporary solution. 
        && mv ${ZK_HOME}/conf/sshd_config /etc/ssh/sshd_config

VOLUME     /myvol

EXPOSE     2181 2888 3888

WORKDIR    ${ZK_HOME}

ENTRYPOINT ["./run.sh"]
