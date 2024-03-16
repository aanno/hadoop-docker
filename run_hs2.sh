#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER run --rm -v .:/mnt:z -v ./conf/hive-site.xml:/opt/hive/conf/hive-site.xml:z,ro --net hadoop_network -p 10000:10000 -p 10002:10002 --env SERVICE_NAME=hiveserver2 --name hive4 $* localhost/hadoop-base:3.3.6

# localhost/hadoop-base:3.3.6
# docker.io/apache/hive:4.0.0-beta-1
