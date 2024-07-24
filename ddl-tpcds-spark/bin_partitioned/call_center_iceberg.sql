create database if not exists ${DB};
use ${DB};

drop table if exists call_center;

create table call_center
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.call_center;
