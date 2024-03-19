# Hive Tutorial

* from https://www.tutorialspoint.com/hive/index.htm

```bash
hdfs dfs -copyFromLocal /mnt/hive-tutorial/sample.txt hdfs://namenode/user/hive/input/
hdfs dfs -ls hdfs://namenode/user/hive/input/
beeline -u "jdbc:hive2://hive4:10000"
```

```bash
LOAD DATA INPATH "hdfs://namenode/user/hive/input/sample.txt" OVERWRITE INTO TABLE employee;
```

```bash
```

```bash
```

```bash
```

```bash
```

