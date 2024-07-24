create database if not exists ${DB};
use ${DB};

drop table if exists supplier;

create table supplier
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.supplier
cluster by s_nationkey, s_suppkey
;
