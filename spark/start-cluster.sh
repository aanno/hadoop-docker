#!/bin/bash

docker build -t spark-base:3.5.1 .
docker-compose up -d
