#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER run --rm --net hadoop_network -p 10000:10000 -p 10002:10002 --env SERVICE_NAME=hiveserver2 --name hive4 docker.io/apache/hive:4.0.0-beta-1
