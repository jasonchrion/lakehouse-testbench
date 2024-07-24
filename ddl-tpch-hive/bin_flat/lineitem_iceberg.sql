create database if not exists ${DB};
use ${DB};

drop table if exists lineitem;

create table lineitem
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select * from ${SOURCE}.lineitem
cluster by L_SHIPDATE
;
