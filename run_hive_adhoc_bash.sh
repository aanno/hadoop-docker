#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER run --rm -v .:/mnt:z -v ./conf/hive-site.xml:/opt/hive/conf/hive-site.xml:z,ro --net hadoop_network --name hive-adhoc --entrypoint=/bin/bash -it $* localhost/hive:4.0.0-beta-1

# localhost/hadoop-base:3.3.6
# docker.io/apache/hive:4.0.0-beta-1
