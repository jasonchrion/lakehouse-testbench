create database if not exists ${DB};
use ${DB};

drop table if exists supplier;

create table supplier
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select * from ${SOURCE}.supplier
cluster by s_nationkey, s_suppkey
;
