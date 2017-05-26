#!/bin/bash

#echo "export PYSPARK_PYTHON=/usr/bin/python2.7" >> ~/.bash_profile
#echo "export PYSPARK_DRIVER_PYTHON=ipython2.7" >> ~/.bash_profile
## the notebook can be accessed using the command: ipython notebook --no-browser --ip=* --matplotlib
#echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"notebook --no-browser --ip=* --matplotlib\"" >> ~/.bash_profile
#echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin" >> ~/.bash_profile
: ${HOST_TYPE:=master} 
: ${SLAVE_LIST:=} 

cat ~/.ssh/id_rsa.pub >> /myvol/authorized_keys

#start ssh service
service ssh start

#waitting for the id_rsa.pub of all nodes has been added into the /myvol/authorized_keys file
sleep 3
cp /myvol/authorized_keys ~/.ssh/authorized_keys

#start spark if it's master node
if [ $HOST_TYPE = "master" ]
then
  echo -e ${SLAVE_LIST} > ${SPARK_CONF_DIR}/slaves;
  ./sbin/start-all.sh;
fi

tail -f /dev/null
