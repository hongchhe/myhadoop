From ubuntu:16.04
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

# install openssh-server, openjdk and wget
RUN     apt-get update \
     && apt-get install -y openssh-server openjdk-8-jdk wget ssh rsync

#install hbase-1.2.5
RUN     wget http://ftp.wayne.edu/apache/hbase/stable/hbase-1.2.5-bin.tar.gz \
     && tar -xzvf hbase-1.2.5-bin.tar.gz \
     && mv hbase-1.2.5 /usr/local/hbase \
     && rm -f hbase-1.2.5-bin.tar.gz \
     && cd /usr/local/hbase

# set environment variable
ENV     JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV     PATH=$PATH:/usr/local/hbase/bin:/usr/local/hbase/sbin 

# ssh without key
RUN     ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY    conf/* /usr/local/hbase/conf

RUN     mv /tmp/ssh_config ~/.ssh/config

EXPOSE  16010

WORKDIR /usr/local/hbase/
CMD     [ "sh", "-c", "/usr/local/hbase/bin/start-hbase.sh; bash"]
