Original:

CREATE TABLE IF NOT EXISTS employee ( eid int, name String,
salary String, destination String)
COMMENT "Employee details"
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\n"
STORED AS TEXTFILE;

Better (for CSV):

CREATE TABLE IF NOT EXISTS employee 
( eid int, name String, salary double, destination String)
COMMENT 'Employee details'
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
STORED AS TEXTFILE;
