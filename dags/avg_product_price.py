from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.bash import BashOperator
from airflow.contrib.operators.spark_submit_operator import SparkSubmitOperator
from datetime import datetime, timedelta


default_args = {
    'owner' : 'ayyoub',
    'depend_on_past' : False,
    'start_date' : datetime(2023, 1, 20),
    'email_on_failure' : False,
    'email_on_retry' : False,
    'retries' : 1,
    'retry_delay' : timedelta(minutes=5)
}

with DAG('avg_product_price', default_args=default_args, schedule_interval=None, catchup=False) as dag:

    start = BashOperator(
        task_id='start_avg_product_price',
        bash_command='hadoop fs -mkdir -p hdfs://namenode:8020/user/root/input; hadoop fs -copyFromLocal /hadoop-data/input/* hdfs://namenode:8020/user/root/input/; exit 0'
    )

    spark_submit = SparkSubmitOperator(
        task_id='spark_submit_avg_product_price',
        conn_id='spark-hadoop',
        application="/hadoop-data/map_reduce/spark/average_price.py"
    )

    end = BashOperator(
        task_id='end_avg_product_price',
        bash_command='hadoop fs -copyToLocal hdfs://namenode:8020/user/root/output/average_price.csv /home/airflow/output/; exit 0'
    )

    start >> spark_submit >> end
