# Note (tp)

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

```bash
```


```bash
```


```bash
```


```bash
```

## tips and tricks

* ensure that the logs directory is writeable to everyone
* ensure that the output directory is writeable to everyone


## References

### Yarn

* [yarn](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html) explicates resource and node managers
* [run spark on yarn](https://spark.apache.org/docs/latest/running-on-yarn.html)
