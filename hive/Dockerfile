FROM hongchhe/hadoop
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

# set environment variable
ENV     HIVE_HOME=/opt/hive 
ENV     HIVE_CONF_DIR=$HIVE_HOME/conf
ENV     PATH=$PATH:$HIVE_HOME/bin:$HIVE_HOME/sbin 
ENV     HIVE_VERSION=2.1.1
ENV     HIVE_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/hive

#install hive 2.1.1	
RUN     mkdir -p ${HIVE_HOME} \
     && wget -q -O - ${HIVE_URL}/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar -xzC ${HIVE_HOME} --strip-components=1 \
     && mkdir -p ${HIVE_HOME}/tmp \
     && wget -q -O - https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz | tar -xzC ${HIVE_HOME}/tmp --strip-components=1 \
     && mv ${HIVE_HOME}/tmp/mysql-connector-java-5.1.42-bin.jar ${HIVE_HOME}/lib \
     && rm -rf ${HIVE_HOME}/tmp



ENV     PATH="$PATH:$HIVE_HOME/bin"

# masterWebUI / master service / REST server
#EXPOSE  8080 7077 6066


COPY    conf/* $HIVE_CONF_DIR/
COPY    run.sh $HIVE_HOME/

RUN     chmod +x $HIVE_HOME/run.sh \
     && mkdir -p /myvol \
        # ssh without key
     && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
     && mv $HIVE_CONF_DIR/ssh_config ~/.ssh/config 

VOLUME /myvol

WORKDIR $HIVE_HOME

ENTRYPOINT ["./run.sh"]

