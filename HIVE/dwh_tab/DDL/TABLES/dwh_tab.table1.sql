create external table table1(
	cob_date bigint,
	column1 string,
	column2 timestamp)
STORED AS PARQUET
LOCATION '/data/hdfs/location/table1';
