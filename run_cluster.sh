#!/bin/bash

source cluster.env

mkdir -p ./tmp/pip ./tmp/var/cache/apt/archives/partial || true
# containers write into logs and output
chmod -R a+w logs output

HADOOP_VERSION=3.3.6
HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
! [ -f ./tmp/hadoop.tar.gz ] && curl -fSL "$HADOOP_URL" -o ./tmp/hadoop.tar.gz

SPARK_VERSION=spark-3.5.1
SPARK_URL=https://downloads.apache.org/spark/${SPARK_VERSION}/${SPARK_VERSION}-bin-hadoop3.tgz
! [ -f ./tmp/spark.tar.gz ] && curl -fSL "${SPARK_URL}" -o ./tmp/spark.tar.gz

HIVE_VERSION=3.1.3
HIVE_URL=https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
! [ -f ./tmp/hive.tar.gz ] && curl -fSL "${HIVE_URL}" -o ./tmp/hive.tar.gz

# create new network
$DOCKER network create hadoop_network

# build docker image with image name hadoop-base:3.3.6
$DOCKER build \
  -v $PWD/tmp:/tmp:z -v $PWD/tmp/pip:/root/.cache/pip:z \
  -v $PWD/tmp/var/cache/apt/archives:/var/cache/apt/archives:z \
  -t localhost/hadoop-base:3.3.6 -f Dockerfile-hadoop .

# running image to container, -d to run it in daemon mode
$DOCKER_COMPOSE -p hadoop -f docker-compose-hadoop.yml up -d

# Run Airflow Cluster
if [[ "$PWD" != "airflow" ]]; then
  cd airflow && ./run_airflow.sh && cd ..
fi

$DOCKER_COMPOSE -p airflow -f docker-compose-airflow.yml up -d

echo "Current dir is $PWD"
