create database if not exists ${DB};
use ${DB};

drop table if exists warehouse;

create table warehouse
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.warehouse;
