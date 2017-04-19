From hongchhe/ubuntu-java7
MAINTAINER Hongchuang <hehongchuang@hotmail.com>

# set environment variable
ENV     SPARK_HOME=/opt/spark 
ENV     SPARK_CONF_DIR=$SPARK_HOME/conf
ENV     PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin 
ENV     SPARK_VERSION=2.1.0
ENV     SPARK_URL=http://mirror.bit.edu.cn/apache
#ENV     SPARK_URL=http://www.gtlib.gatech.edu/pub/apache

#install spark 2.1.0
RUN     mkdir -p ${SPARK_HOME} \
     && wget -q -O - ${SPARK_URL}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | tar -xzC ${SPARK_HOME} --strip-components=1

#install python related library
RUN     apt-get install -y  ipython \
     && wget https://bootstrap.pypa.io/get-pip.py \
     && python get-pip.py \
     && pip install numpy scipy pandas


# masterWebUI / master service / REST server
EXPOSE  8080 7077 6066
# workerUI / driverProgramWebUI
EXPOSE 8081 4040 4041

COPY    conf/* $SPARK_CONF_DIR/
COPY    run.sh $SPARK_HOME/

RUN     chmod +x $SPARK_HOME/run.sh \
# ssh without key
     && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
     && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
     && chmod 0600 ~/.ssh/authorized_keys \
     && mv $SPARK_CONF_DIR/ssh_config ~/.ssh/config 

WORKDIR $SPARK_HOME

ENTRYPOINT ["./run.sh"]

