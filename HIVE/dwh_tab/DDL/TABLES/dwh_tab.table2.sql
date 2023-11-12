create external table table2(
	cob_date bigint,
	column1 string,
	column2 timestamp)
STORED AS PARQUET
LOCATION '/data/hdfs/location/table2';
