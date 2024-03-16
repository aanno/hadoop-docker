#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER podman run --rm --net hadoop_network -it -p 8888:8888 docker.io/gethue/hue:latest

# localhost/hadoop-base:3.3.6
# docker.io/apache/hive:4.0.0-beta-1
