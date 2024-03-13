#!/bin/bash

source ../cluster.env
ln -s ../tmp . || true

$DOCKER build \
  -v $PWD/tmp:/tmp:z -v $PWD/tmp/pip:/root/.cache/pip:z \
  -v $PWD/tmp/var/cache/apt/archives:/var/cache/apt/archives:z \
  -t localhost/spark-base:3.5.1 .
$DOCKER_COMPOSE up -d
