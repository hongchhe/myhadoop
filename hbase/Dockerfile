From hongchhe/ubuntu-java7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

#install hbase-1.2.5
RUN     wget http://ftp.wayne.edu/apache/hbase/stable/hbase-1.2.5-bin.tar.gz \
     && tar -xzvf hbase-1.2.5-bin.tar.gz \
     && mv hbase-1.2.5 /usr/local/hbase \
     && rm -f hbase-1.2.5-bin.tar.gz \
     && cd /usr/local/hbase

# set environment variable
ENV     PATH=$PATH:/usr/local/hbase/bin:/usr/local/hbase/sbin 

# ssh without key
RUN     ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

COPY    conf/* /usr/local/hbase/conf/

EXPOSE  16010 16020 16030

WORKDIR /usr/local/hbase/

ENTRYPOINT [ "sh", "-c", "/usr/local/hbase/bin/start-hbase.sh"]
