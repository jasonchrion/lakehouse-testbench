create database if not exists ${DB};
use ${DB};

drop table if exists orders;

create table orders
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select * from ${SOURCE}.orders
cluster by O_ORDERDATE
;
