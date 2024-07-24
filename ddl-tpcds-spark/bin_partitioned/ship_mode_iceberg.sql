create database if not exists ${DB};
use ${DB};

drop table if exists ship_mode;

create table ship_mode
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.ship_mode;
