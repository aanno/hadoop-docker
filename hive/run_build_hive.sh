#!/bin/bash

source ../cluster.env
ln -s ../tmp .
mkdir tmp2 || true
ln ../tmp/postgresql.jar tmp2/ || true

$DOCKER build \
  -v $PWD/tmp:/tmp:z -v $PWD/tmp/pip:/root/.cache/pip:z \
  -v $PWD/tmp/var/cache/apt/archives:/var/cache/apt/archives:z \
  -t localhost/hive:4.0.0-beta-1 .
