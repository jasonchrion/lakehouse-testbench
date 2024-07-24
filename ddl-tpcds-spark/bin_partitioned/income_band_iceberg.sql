create database if not exists ${DB};
use ${DB};

drop table if exists income_band;

create table income_band
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.income_band;
