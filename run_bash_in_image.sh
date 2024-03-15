#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER run --net hadoop_network -v .:/mnt:z --name playground -it --rm localhost/hadoop-base:3.3.6 bash
