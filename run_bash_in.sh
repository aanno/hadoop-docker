#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER exec -it $* bash

# localhost/hadoop-base:3.3.6
# docker.io/apache/hive:4.0.0-beta-1
