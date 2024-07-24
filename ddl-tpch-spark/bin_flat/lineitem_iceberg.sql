create database if not exists ${DB};
use ${DB};

drop table if exists lineitem;

create table lineitem
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.lineitem
cluster by L_SHIPDATE
;
