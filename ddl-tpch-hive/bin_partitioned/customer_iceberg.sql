create database if not exists ${DB};
use ${DB};

drop table if exists customer;

create table customer
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select * from ${SOURCE}.customer
cluster by C_MKTSEGMENT
;
