#!/bin/bash

source ../cluster.env
ln -s ../tmp . || true

$DOCKER build \
  -v $PWD/tmp:/tmp:z -v $PWD/tmp/pip:/root/.cache/pip:z \
  -v $PWD/tmp/var/cache/apt/archives:/var/cache/apt/archives:z \
  -t localhost/airflow-hadoop-base:3.3.6 .
