create database if not exists ${DB};
use ${DB};

drop table if exists orders;

create table orders
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.orders
cluster by O_ORDERDATE
;
