#!/bin/bash

set -xehuv

# ENVIRONMENT AND DIRECTORIES

source cluster.env

mkdir -p ./tmp/pip ./tmp/var/cache/apt/archives/partial || true
# containers write into logs and output
sudo chmod -R a+w logs output tmp || true

# HADOOP DOWNLOAD

HADOOP_VERSION=3.3.6
HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
! [ -f ./tmp/hadoop.tar.gz ] && curl -fSL "${HADOOP_URL}" -o ./tmp/hadoop.tar.gz
! [ -f ./tmp/hadoop.tar.gz.asc ] && curl -fSL "${HADOOP_URL}.asc" -o ./tmp/hadoop.tar.gz.asc

# SPARK DOWNLOAD

SPARK_VERSION=spark-3.5.1
SPARK_URL=https://downloads.apache.org/spark/${SPARK_VERSION}/${SPARK_VERSION}-bin-hadoop3.tgz
! [ -f ./tmp/spark.tar.gz ] && curl -fSL "${SPARK_URL}" -o ./tmp/spark.tar.gz
! [ -f ./tmp/spark.tar.gz.asc ] && curl -fSL "${SPARK_URL}.asc" -o ./tmp/spark.tar.gz.asc

# HIVE DOWNLOAD

# HIVE3 needs jdk8 and is out of scope
HIVE_VERSION=4.0.0-beta-1
HIVE_URL=https://dlcdn.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
! [ -f ./tmp/hive.tar.gz ] && curl -fSL "${HIVE_URL}" -o ./tmp/hive.tar.gz
! [ -f ./tmp/hive.tar.gz.asc ] && curl -fSL "${HIVE_URL}.asc" -o ./tmp/hive.tar.gz.asc

# FLINK DOWNLOAD

FLINK_VERSION=1.18.1
SCALA_VERSION=2.12
FLINK_URL=https://dlcdn.apache.org/flink/flink-$FLINK_VERSION/flink-$FLINK_VERSION-bin-scala_$SCALA_VERSION.tgz
! [ -f ./tmp/flink.tar.gz ] && curl -fSL "${FLINK_URL}" -o ./tmp/flink.tar.gz
! [ -f ./tmp/flink.tar.gz.asc ] && curl -fSL "${FLINK_URL}.asc" -o ./tmp/flink.tar.gz.asc

# POSTGRESQL JDBC DOWNLOAD

PG_JDBC_VERSION=42.7.3
PG_JDBC_URL=https://jdbc.postgresql.org/download/postgresql-$PG_JDBC_VERSION.jar
! [ -f ./tmp/postgresql.jar ] && curl -fSL "${PG_JDBC_URL}" -o ./tmp/postgresql.jar

# create new network
$DOCKER network create hadoop_network || true

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
