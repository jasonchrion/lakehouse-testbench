create database if not exists ${DB};
use ${DB};

drop table if exists partsupp;

create table partsupp
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select * from ${SOURCE}.partsupp
cluster by PS_SUPPKEY
;
