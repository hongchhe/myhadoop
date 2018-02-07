FROM       centos:7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

ARG        ZK_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/
ARG        ZK_VERSION=3.4.11

LABEL      name="zookeeper" version=$VERSION

# set environment variable
ENV        ZK_HOME=/opt/zookeeper
ENV        PATH=$PATH:${ZK_HOME}/bin:${ZK_HOME}/sbin 

RUN        yum update -y \
        && yum install -y java-1.8.0-openjdk.x86_64 \
        && mkdir -p ${ZK_HOME} \
        && curl ${ZK_URL}/zookeeper-${ZK_VERSION}/zookeeper-${ZK_VERSION}.tar.gz \
           | tar -xzC ${ZK_HOME} --strip-components=1 \
        && yum clean all \
        && rm -rf /var/cache/yum

COPY       conf/* ${ZK_HOME}/conf/
COPY       scripts/* ${ZK_HOME}/

RUN        chmod +x ${ZK_HOME}/run.sh

EXPOSE     2181 2888 3888

WORKDIR    ${ZK_HOME}

ENTRYPOINT ["./run.sh"]
