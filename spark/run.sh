#!/bin/bash

#start ssh service
service ssh start

#start spark
./sbin/start-all.sh

tail -f /dev/null
