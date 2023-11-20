create external table table4(`(
	cob_date bigint,
	column1 string,
	column2 timestamp)
STORED AS PARQUET
LOCATION '/data/hdfs/location/table4';
