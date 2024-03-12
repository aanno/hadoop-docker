# Note (tp)

## Overview

This project will setup

* an hadoop cluster (name node, resource manager, history server, node manager, 2 data nodes)
  + yarn config
  + including HDFS (hadoop distributed file system)
* airflow cluster (init server, scheduler, webserver)
* spark cluster (1 master, 2 workers)
* postgreSQL DB server (needed for airflow)

It also contains some (minimal) examples (map-reduce tasks, data).

It currently does _not_ contain:

* an spark history server

## Running hadoop command

Log into one of the airflow container

```bash
docker exec -it <containerid> bash
```

Then execute:

```bash
python3 /hadoop-data/map_reduce/ratings_breakdown.py -r hadoop --hadoop-streaming-jar /opt/hadoop-3.3.6/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar /hadoop-data/input/u.data
```

TODO:
Where is the result?

## Airflow

TODO:
Both jobs fail. Why?

airflow.exceptions.AirflowException: Cannot execute: spark-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py. Error code is: 1.

24/03/11 16:57:51 INFO Client: Uploading resource file:/opt/spark-3.5.1/python/lib/pyspark.zip -> hdfs://namenode:8020/user/airflow/.sparkStaging/application_1710172294329_0006/pyspark.zip

  File "/opt/spark-3.5.1/python/lib/py4j-0.10.9.7-src.zip/py4j/protocol.py", line 326, in get_return_value
py4j.protocol.Py4JJavaError: An error occurred while calling o22.partitions.
: org.apache.hadoop.mapred.InvalidInputException: Input path does not exist: hdfs://namenode:8020/user/root/input/u.data
        at org.apache.hadoop.mapred.FileInputFormat.singleThreadedListStatus(FileInputFormat.java:304)




```bash
airflow@49fa94215d08:~$ hadoop fs -mkdir hdfs://namenode:8020/user/root/input
WARNING: HADOOP_PREFIX has been replaced by HADOOP_HOME. Using value of HADOOP_PREFIX.
airflow@49fa94215d08:~$ hadoop fs -copyFromLocal /hadoop-data/input/* hdfs://namenode:8020/user/root/input/
WARNING: HADOOP_PREFIX has been replaced by HADOOP_HOME. Using value of HADOOP_PREFIX.
airflow@49fa94215d08:~$ hadoop fs -ls hdfs://namenode:8020/user/root/input
WARNING: HADOOP_PREFIX has been replaced by HADOOP_HOME. Using value of HADOOP_PREFIX.
Found 5 items
-rw-r--r--   3 airflow supergroup    1593386 2024-03-11 17:31 hdfs://namenode:8020/user/root/input/Sales.csv
-rw-r--r--   3 airflow supergroup      19200 2024-03-11 17:31 hdfs://namenode:8020/user/root/input/benda.txt
-rw-r--r--   3 airflow supergroup    2079229 2024-03-11 17:31 hdfs://namenode:8020/user/root/input/u.data
-rw-r--r--   3 airflow supergroup     236344 2024-03-11 17:31 hdfs://namenode:8020/user/root/input/u.item
-rw-r--r--   3 airflow supergroup         47 2024-03-11 17:31 hdfs://namenode:8020/user/root/input/words.txt
```

```bash
$ hadoop fs -copyToLocal hdfs://namenode:8020/user/root/output/average_price.csv output/
```

```bash
park-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py
spark-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/average_price.py
```


```bash
```

## tips and tricks

* ensure that the logs directory is writeable to everyone
* ensure that the output directory is writeable to everyone

## Web UI and Monitoring

### Hadoop

* namenode: http://localhost:9870 (DFS health)
  overview - datanotes - volume failures - snapshots - startup progress
* resource manager: http://localhost:8089
  + about: cluster metrics - cluster node metrics - scheduler metrics
  + nodes
  + node labels
  + applications: can be filtered:  NEW NEW_SAVING SUBMITTED ACCEPTED RUNNING FINISHED FAILED KILLED
  + scheduler:
    - Application Queues
    - Aggregate scheduler counts
    - Last scheduler run
    - Last Preemption
    - Last Reservation
    - Last Allocation
    - Last Release
* history server: http://localhost:8188
  see resource manager (but only applications)
* node manager: http://localhost:8042
  see resource manager (but only nodes)

### Airflow

* webserver: http://localhost:8080/home 
  + login with airflow/airflow
  + DAGs - Cluster Activity - Datasets - Security - Browse - Admin - Docs

### Spark

* master: http://localhost:9090 
  workers - running applications - completed applications
* worker1: http://localhost:9091 - running executors
* worker2: http://localhost:9092 - running executors

### Other used (and exposed) ports

* 5432: PostgreSQL server
* 8020: Hadoop IPC port
* 7000: Spark (but what?)

## References

### Yarn

* [yarn](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html) explicates resource and node managers
* [run spark on yarn](https://spark.apache.org/docs/latest/running-on-yarn.html)
* [monitoring spark and history server](https://spark.apache.org/docs/3.5.1/monitoring.html)
* [spark history server](https://github.com/rangareddy/spark-history-server-docker)
