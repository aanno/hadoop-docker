# Note (tp)

## Overview

This project will setup

* an hadoop cluster (name node, resource manager, history server, node manager, 2 data nodes)
  + yarn config
  + including HDFS (hadoop distributed file system)
* airflow cluster (init server, scheduler, webserver)
* spark standalone cluster (1 master, 2 workers) _obsolete_
* postgreSQL DB server (needed for airflow)

It also contains some (minimal) examples (map-reduce tasks, data).

It currently does _not_ contain:

* an spark history server

Also refer to https://blog.det.life/developing-multi-nodes-hadoop-spark-cluster-and-airflow-in-docker-compose-part-e75ff6942ef

## Running hadoop command

Log into one of the airflow container

```bash
docker exec -it <containerid> bash
```

Then execute:

```bash
python3 /hadoop-data/map_reduce/ratings_breakdown.py -r hadoop --hadoop-streaming-jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar /hadoop-data/input/u.data
```

TODO:
Where is the result?

## Airflow

TODO:
Both jobs fail. Why?

airflow.exceptions.AirflowException: Cannot execute: spark-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py. Error code is: 1.

24/03/11 16:57:51 INFO Client: Uploading resource file:/opt/spark/python/lib/pyspark.zip -> hdfs://namenode:8020/user/airflow/.sparkStaging/application_1710172294329_0006/pyspark.zip

  File "/opt/spark/python/lib/py4j-0.10.9.7-src.zip/py4j/protocol.py", line 326, in get_return_value
py4j.protocol.Py4JJavaError: An error occurred while calling o22.partitions.
: org.apache.hadoop.mapred.InvalidInputException: Input path does not exist: hdfs://namenode:8020/user/root/input/u.data
        at org.apache.hadoop.mapred.FileInputFormat.singleThreadedListStatus(FileInputFormat.java:304)




```bash
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
spark-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py
spark-submit --master yarn --name arrow-spark /hadoop-data/map_reduce/spark/average_price.py
```

Run on yarn cluster:

```bash
spark-submit --master yarn --deploy-mode cluster --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py
```

Run on sparks standalone cluster:

```bash
spark-submit --master spark://spark-master:7077 --deploy-mode cluster --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py
# Error:
SparkException: Cluster deploy mode is currently not supported for python applications on standalone clusters.

spark-submit --master spark://spark-master:7077 --deploy-mode cluster --name arrow-spark /hadoop-data/map_reduce/spark/lowest_rated_movies_spark.py
```

Init hive:

```bash
hdfs dfs -mkdir /tmp/hive /user/hive
hdfs dfs -chmod 777 /tmp/hive /user/hive
schematool -initSchema -dbType derby -verbose || true
schematool -initSchemaTo 4.0.0-beta-1 -dbType postgres -verbose
```

* https://cwiki.apache.org/confluence/display/Hive/GettingStarted
* https://cwiki.apache.org/confluence/display/Hive/Hive+Schema+Tool
* https://medium.com/@malinda.ashan/configure-apache-hive-to-use-postgres-as-metastore-fae1703e29d5
* https://stackoverflow.com/questions/34196302/the-root-scratch-dir-tmp-hive-on-hdfs-should-be-writable-current-permissions

Hive is really picky about permission and I do not understand its user 
management. The following may help:

* [hive quickstart with docker](https://hive.apache.org/developement/quickstart/)
  + [docker image description](https://hub.docker.com/r/apache/hive)
* [new user in hadoop](https://community.cloudera.com/t5/Support-Questions/How-to-create-user-in-hadoop/m-p/234730)
  + https://data-flair.training/forums/topic/how-to-create-user-in-hadoop/
* [Managed vs. External Tables](https://cwiki.apache.org/confluence/display/Hive/Managed+vs.+External+Tables) you normally want managed tables
  + https://docs.cloudera.com/runtime/7.2.7/using-hiveql/topics/hive_managed_location.html
* [Hive Authorization](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Authorization) is normally turned off
  + [Hive query should run as user 'hive'](https://community.cloudera.com/t5/Support-Questions/hive-create-table-error/td-p/269790)
  + [impersonate and proxy problems](https://stackoverflow.com/questions/52994585/user-is-not-allowed-to-impersonate-anonymous-state-08s01-code-0-org-apache-had) probably misleading!
  + https://docs.cloudera.com/cdp-private-cloud-base/latest/securing-hive/topics/hive_hive_authorization_models.html
* [run Hive on Yarn (directly)](https://community.cloudera.com/t5/Community-Articles/Running-docker-containerized-services-in-HDP-3-x-Part2-Hive/ta-p/244224)
* [hive enable concurrency](https://community.cloudera.com/t5/Support-Questions/Hive-Can-we-enable-concurrency-support-without-enabling-ACID/m-p/194845)
  + concurrency _needs_ a zookeeper server
* [dynamic partitions](https://community.cloudera.com/t5/Support-Questions/Hive-INSERT-failing-for-a-large-table/td-p/169441)

```bash
```

## tips and tricks

* ensure that the logs directory is writeable to everyone
* ensure that the output directory is writeable to everyone

## Web UI and Monitoring

### Hadoop

* namenode: http://localhost:9870 (DFS health)
  overview - datanodes - volume failures - snapshots - startup progress
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

### Hive

* hiveserver2: http://localhost:10002
  Home, Local logs, Metrics Dump, Hive Configuration, Stack Trace, Llap Daemons, Configure logging
* Main hive log defaults to `/tmp/<user>/hive.log` where <user> is the intern docker user running hive

Reference:

* [llap](https://cwiki.apache.org/confluence/display/hive/llap)

### Spark standalone (deprecated)

* master: http://localhost:9090
  workers - running applications - completed applications
* master for `spark-submit`: spark://spark-master:7077
* worker1: http://localhost:9091 - running executors
* worker2: http://localhost:9092 - running executors
* resourcemanager:8030 scheduler
* resourcemanager:8031 resource-tracker
* resourcemanager:8032 resourcemanager
* resourcemanager: http://localhost:8089

### Other used (and exposed) ports

* 5432: PostgreSQL server
* 8020: Hadoop IPC port
* 10000: Service for programatically (Thrift/JDBC) connecting to Hive
* 9083: Thrift connecting to hivemetastore

Deprecated:
* 7000: Spark worker port
* 6066: Spark master REST port
* 7077: Spark master port

## References

### Hadoop

* [ambari](https://ambari.apache.org/) hadoop management: provision, manage, monitor
* [hue](https://gethue.com/) SQL Assistant for Databases & Data Warehouses

### Yarn

* [yarn](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html) explicates resource and node managers
* [run spark on yarn](https://spark.apache.org/docs/latest/running-on-yarn.html)
* [monitoring spark and history server](https://spark.apache.org/docs/3.5.1/monitoring.html)
* [spark history server](https://github.com/rangareddy/spark-history-server-docker)
* [spark ports](https://spark.apache.org/docs/latest/security.html#configuring-ports-for-network-security)
