#!/bin/bash

echo "export PYSPARK_PYTHON=/usr/bin/python2.7" >> ~/.bash_profile
echo "export PYSPARK_DRIVER_PYTHON=ipython2.7" >> ~/.bash_profile
# the notebook can be accessed using the command: ipython notebook --no-browser --ip=*
echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"notebook --no-browser --ip=*\"" >> ~/.bash_profile
echo "export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin" >> ~/.bash_profile

cat ~/.ssh/id_rsa.pub >> /myvol/authorized_keys

#start ssh service
service ssh start

#waitting for the id_rsa.pub of all nodes has been added into the /myvol/authorized_keys file
sleep 3
cp /myvol/authorized_keys ~/.ssh/authorized_keys

#start spark
./sbin/start-all.sh

source ~/.bash_profile

tail -f /dev/null
