create database if not exists ${DB};
use ${DB};

drop table if exists promotion;

create table promotion
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.promotion;
