create external table table3(`(
	cob_date bigint,
	column1 string,
	column2 timestamp)
STORED AS PARQUET
LOCATION '/data/hdfs/location/table3';
