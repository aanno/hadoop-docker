#!/bin/bash

# ENVIRONMENT AND DIRECTORIES

source cluster.env

$DOCKER run -v .:/mnt:z --name playground -it --rm localhost/hadoop-base:3.3.6 bash
