#!/bin/bash

source cluster.env

# Stop Airflow
$DOCKER_COMPOSE -f docker-compose-airflow.yml down
# Stop Hadoop
$DOCKER_COMPOSE -f docker-compose-hadoop.yml down

echo "All services stoped"
